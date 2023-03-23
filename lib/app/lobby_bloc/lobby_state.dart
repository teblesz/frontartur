part of 'lobby_bloc.dart';

enum LobbyStatus {
  playingGame,
  inMatchup,
  withoutRoom, // TODO ?
}

class LobbyState extends Equatable {
  const LobbyState._({
    required this.status,
    this.room = Room.empty,
  });

  const LobbyState.playingGame(Room room)
      : this._(status: LobbyStatus.playingGame, room: room);

  const LobbyState.inMatchup(Room room)
      : this._(
          status: LobbyStatus.inMatchup,
          room: room,
        );

  final LobbyStatus status;
  final Room room;

  @override
  List<Object> get props => [status, room];
}
