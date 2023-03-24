import 'dart:async';
import 'dart:ffi';
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
              ? LobbyState.playingGame(dataRepository.currentRoom)
              : LobbyState.inMatchup(dataRepository.currentRoom),
        ) {
    on<_LobbyRoomChanged>(_onRoomChanged);
    on<LobbyLeaveRoomRequested>(_onLeaveRoomRequested);
    _roomSubscription = _dataRepository.room.listen(
      (room) => add(_LobbyRoomChanged(room)),
    );
  }

  final DataRepository _dataRepository;
  late final StreamSubscription<Room> _roomSubscription;

  void _onRoomChanged(
    _LobbyRoomChanged event,
    Emitter<LobbyState> emit,
  ) {
    emit(
      event.room.isNotEmpty
          ? LobbyState.playingGame(event.room)
          : LobbyState.inMatchup(event.room),
    );
  }

  void _onLeaveRoomRequested(
    LobbyLeaveRoomRequested event,
    Emitter<LobbyState> emit,
  ) {
    _dataRepository.leaveRoom();
  }

  @override
  Future<void> close() {
    _roomSubscription.cancel();
    return super.close();
  }
}
