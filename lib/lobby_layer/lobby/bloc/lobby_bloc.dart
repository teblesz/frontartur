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
          dataRepository.currentRoomDocId.isNotEmpty
              ? LobbyState.hostingRoom(dataRepository.currentRoomDocId)
              : const LobbyState.withoutRoom(),
        ) {
    on<LobbyLeaveRoomRequested>(_onLeaveRoomRequested);
    _roomDocIdSubscription = _dataRepository.streamRoom().listen(
          (roomDocId) => add(_LobbyRoomDocIdChanged(roomDocId)),
        );
  }

  final DataRepository _dataRepository;
  late final StreamSubscription<RoomDocId> _roomDocIdSubscription;

  void _onRoomDocIdChanged(
      _LobbyRoomDocIdChanged event, Emitter<LobbyState> emit) {
    emit(
      event.roomDocId.isNotEmpty
          ? LobbyState.authenticated(event.roomDocId)
          : const LobbyState.unauthenticated(),
    );
  }

  void _onLeaveRoomRequested(
      LobbyLeaveRoomRequested event, Emitter<LobbyState> emit) {
    unawaited(_dataRepository.logOut());
  }

  @override
  Future<void> close() {
    _roomDocIdSubscription.cancel();
    return super.close();
  }
}
