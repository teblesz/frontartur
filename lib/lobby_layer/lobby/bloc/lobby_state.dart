// part of 'lobby_bloc.dart';

// enum LobbyStatus {
//   withoutRoom,
//   hostingRoom,
// }

// class LobbyState extends Equatable {
//   const LobbyState._({
//     required this.status,
//     this.room = Room.empty,
//   });

//   const LobbyState.hostingRoom(Room room)
//       : this._(status: LobbyStatus.withoutRoom, room: room);

//   const LobbyState.withoutRoom() : this._(status: LobbyStatus.withoutRoom);

//   final LobbyStatus status;
//   final Room room;

//   @override
//   List<Object> get props => [status, room];
// }
