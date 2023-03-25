part of 'lobby_cubit.dart';

class LobbyState extends Equatable {
  const LobbyState({
    this.roomIdInput = const RoomId.pure(),
    this.statusOfJoin = FormzStatus.pure,
    this.statusOfCreate = FormzStatus.pure,
  });

  final RoomId roomIdInput;
  final FormzStatus statusOfJoin;
  final FormzStatus statusOfCreate; // workaround

  @override
  List<Object> get props => [roomIdInput, statusOfJoin, statusOfCreate];

  LobbyState copyWith({
    RoomId? roomIdInput,
    FormzStatus? statusOfJoin,
    FormzStatus? statusOfCreate,
  }) {
    return LobbyState(
      roomIdInput: roomIdInput ?? this.roomIdInput,
      statusOfJoin: statusOfJoin ?? this.statusOfJoin,
      statusOfCreate: statusOfCreate ?? this.statusOfCreate,
    );
  }
}
