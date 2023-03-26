part of 'lobby_cubit.dart';

class LobbyState extends Equatable {
  const LobbyState({
    this.roomId = const RoomId.pure(),
    this.statusOfJoin = FormzStatus.pure,
    this.statusOfCreate = FormzStatus.pure,
  });

  final RoomId roomId;
  final FormzStatus statusOfJoin;
  final FormzStatus statusOfCreate; // workaround

  @override
  List<Object> get props => [roomId, statusOfJoin, statusOfCreate];

  LobbyState copyWith({
    RoomId? roomId,
    FormzStatus? statusOfJoin,
    FormzStatus? statusOfCreate,
  }) {
    return LobbyState(
      roomId: roomId ?? this.roomId,
      statusOfJoin: statusOfJoin ?? this.statusOfJoin,
      statusOfCreate: statusOfCreate ?? this.statusOfCreate,
    );
  }
}
