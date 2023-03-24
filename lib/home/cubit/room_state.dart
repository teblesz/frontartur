part of 'room_cubit.dart';

enum RoomStatus {
  /// user is not in any room
  inLobby,

  /// user is in room durning matchup
  inMathup,

  /// user is in room durning game
  inGame,
}

class RoomState extends Equatable {
  const RoomState({
    this.room = Room.empty,
    this.status = RoomStatus.inLobby,
  });

  final Room room;
  final RoomStatus status;

  @override
  List<Object> get props => [room, status];

  RoomState copyWith({
    Room? room,
    RoomStatus? status,
  }) {
    return RoomState(
      room: room ?? this.room,
      status: status ?? this.status,
    );
  }
}
