part of 'lobby_bloc.dart';

abstract class LobbyEvent {
  const LobbyEvent();
}

class LobbyLeaveRoomRequested extends LobbyEvent {
  const LobbyLeaveRoomRequested();
}

class _LobbyRoomChanged extends LobbyEvent {
  const _LobbyRoomChanged(this.room);

  final Room room;
}
