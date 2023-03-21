part of 'lobby_bloc.dart';

enum LobbyStatus {
  withoutRoom,
  hostingRoom,
}

class LobbyState extends Equatable {
  const LobbyState._({
    required this.status,
    this.roomDocId = RoomDocId.empty,
  });

  const LobbyState.hostingRoom(RoomDocId roomDocId)
      : this._(status: LobbyStatus.withoutRoom, roomDocId: roomDocId);

  const LobbyState.withoutRoom() : this._(status: LobbyStatus.withoutRoom);

  final LobbyStatus status;
  final RoomDocId roomDocId;

  @override
  List<Object> get props => [status, roomDocId];
}
