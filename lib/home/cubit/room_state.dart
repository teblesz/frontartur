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
    this.status = RoomStatus.inLobby,
  });

  final RoomStatus status;

  @override
  List<Object> get props => [status];

  RoomState copyWith({
    Room? room,
    RoomStatus? status,
  }) {
    return RoomState(
      status: status ?? this.status,
    );
  }
}
