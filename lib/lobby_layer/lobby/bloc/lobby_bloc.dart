import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:data_repository/data_repository.dart';
import 'package:equatable/equatable.dart';

part 'lobby_event.dart';
part 'lobby_state.dart';

class LobbyBloc extends Bloc<LobbyEvent, LobbyState> {
  LobbyBloc({required DataRepository dataRepository})
      : _dataRepository = dataRepository,
        super(
          dataRepository.currentRoom.isNotEmpty
              ? LobbyState.hostingRoom(dataRepository.currentRoom)
              : const LobbyState.withoutRoom(),
        ) {
    on<LobbyLeaveRoomRequested>(_onLeaveRoomRequested);
    _roomSubscription = _dataRepository.streamRoom().listen(
          (room) => add(_LobbyRoomChanged(room)),
        );
  }

  final DataRepository _dataRepository;
  late final StreamSubscription<Room> _roomSubscription;

  void _onRoomChanged(_LobbyRoomChanged event, Emitter<LobbyState> emit) {
    emit(
      event.room.isNotEmpty
          ? LobbyState.authenticated(event.room)
          : const LobbyState.unauthenticated(),
    );
  }

  void _onLeaveRoomRequested(
      LobbyLeaveRoomRequested event, Emitter<LobbyState> emit) {
    unawaited(_dataRepository.logOut());
  }

  @override
  Future<void> close() {
    _roomSubscription.cancel();
    return super.close();
  }
}
