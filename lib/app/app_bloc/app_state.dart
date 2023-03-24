part of 'app_bloc.dart';

enum AppStatus {
  authenticated,
  unauthenticated,
  inRoom,
}

class AppState extends Equatable {
  const AppState._({
    required this.status,
    this.user = User.empty,
    this.room = Room.empty,
  });

  const AppState.authenticated(User user)
      : this._(status: AppStatus.authenticated, user: user);

  const AppState.unauthenticated() : this._(status: AppStatus.unauthenticated);

  const AppState.inRoom(User user, Room room)
      : this._(status: AppStatus.inRoom, room: room);

  final AppStatus status;
  final User user;
  final Room room;

  @override
  List<Object> get props => [status, user, room];
}
