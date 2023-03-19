part of 'room_id_cubit.dart';

class RoomIdState extends Equatable {
  const RoomIdState({
    this.roomId = const RoomId.pure(),
    this.status = FormzStatus.pure,
  });

  final RoomId roomId;
  final FormzStatus status;

  @override
  List<Object> get props => [roomId, status];

  RoomIdState copyWith({
    RoomId? roomId,
    FormzStatus? status,
  }) {
    return RoomIdState(
      roomId: roomId ?? this.roomId,
      status: status ?? this.status,
    );
  }
}
