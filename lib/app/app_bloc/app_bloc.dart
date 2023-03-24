import 'dart:async';

import 'package:authentication_repository/authentication_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:data_repository/data_repository.dart';
import 'package:equatable/equatable.dart';

part 'app_event.dart';
part 'app_state.dart';

class AppBloc extends Bloc<AppEvent, AppState> {
  AppBloc({
    required AuthenticationRepository authenticationRepository,
    required DataRepository dataRepository,
  })  : _authenticationRepository = authenticationRepository,
        _dataRepository = dataRepository,
        super(authenticationRepository.currentUser.isEmpty
            ? const AppState.unauthenticated()
            : dataRepository.currentRoom.isEmpty
                ? AppState.authenticated(authenticationRepository.currentUser)
                : AppState.inRoom(authenticationRepository.currentUser,
                    dataRepository.currentRoom)) {
    on<_AppUserChanged>(_onUserChanged);
    on<AppLogoutRequested>(_onLogoutRequested);
    on<AppLeaveRoomRequested>(_onLeaveRoomRequested);
    on<AppEnterRoomReqested>(_onEnterRoomRequested);
    _userSubscription = _authenticationRepository.user.listen(
      (user) => add(_AppUserChanged(user)),
    );
  }

  final AuthenticationRepository _authenticationRepository;
  late final StreamSubscription<User> _userSubscription;
  final DataRepository _dataRepository;

  void _onUserChanged(
    _AppUserChanged event,
    Emitter<AppState> emit,
  ) {
    emit(
      event.user.isNotEmpty
          ? AppState.authenticated(event.user)
          : const AppState.unauthenticated(),
    );
  }

  void _onLogoutRequested(
    AppLogoutRequested event,
    Emitter<AppState> emit,
  ) {
    unawaited(_authenticationRepository.logOut());
  }

  //-------------------------------------room---------------------

  void _onEnterRoomRequested(
    AppEnterRoomReqested event,
    Emitter<AppState> emit,
  ) {
    final room = _dataRepository.currentRoom;
    final user = _authenticationRepository.currentUser;
    if (room.isEmpty) {
      //TODO some other state?
      emit(AppState.authenticated(user));
    }
    emit(AppState.inRoom(user, room));
  }

  void _onLeaveRoomRequested(
    AppLeaveRoomRequested event,
    Emitter<AppState> emit,
  ) {
    final user = _authenticationRepository.currentUser;

    _dataRepository.leaveRoom();

    emit(
      user.isNotEmpty
          ? AppState.authenticated(user)
          : const AppState.unauthenticated(),
    );
  }

  @override
  Future<void> close() {
    _userSubscription.cancel();
    return super.close();
  }
}
