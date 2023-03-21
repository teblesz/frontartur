part of 'home_cubit.dart';

class HomeState extends Equatable {
  const HomeState({
    this.roomIdInput = const RoomId.pure(),
    this.status = FormzStatus.pure,
  });

  final RoomId roomIdInput;
  final FormzStatus status;

  @override
  List<Object> get props => [roomIdInput, status];

  HomeState copyWith({
    RoomId? roomIdInput,
    FormzStatus? status,
  }) {
    return HomeState(
      roomIdInput: roomIdInput ?? this.roomIdInput,
      status: status ?? this.status,
    );
  }
}
