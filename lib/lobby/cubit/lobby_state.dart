part of 'lobby_cubit.dart';

class LobbyState extends Equatable {
  const LobbyState({
    this.roomIdInput = const RoomId.pure(),
    this.status = FormzStatus.pure,
  });

  final RoomId roomIdInput;
  final FormzStatus status;

  @override
  List<Object> get props => [roomIdInput, status];

  LobbyState copyWith({
    RoomId? roomIdInput,
    FormzStatus? status,
  }) {
    return LobbyState(
      roomIdInput: roomIdInput ?? this.roomIdInput,
      status: status ?? this.status,
    );
  }
}
