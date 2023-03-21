part of 'lobby_bloc.dart';

abstract class LobbyEvent {
  const LobbyEvent();
}

class LobbyLeaveRoomRequested extends LobbyEvent {
  const LobbyLeaveRoomRequested();
}
