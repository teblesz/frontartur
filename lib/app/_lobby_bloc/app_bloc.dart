// import 'dart:async';

// import 'package:authentication_repository/authentication_repository.dart';
// import 'package:bloc/bloc.dart';
// import 'package:data_repository/data_repository.dart';
// import 'package:equatable/equatable.dart';

// part 'app_event.dart';
// part 'app_state.dart';

// class AppBloc extends Bloc<AppEvent, AppState> {
//   AppBloc({
//     required AuthenticationRepository authenticationRepository,
//     required DataRepository dataRepository,
//   })  : _authenticationRepository = authenticationRepository,
//         _dataRepository = dataRepository,
//         super(authenticationRepository.currentUser.isEmpty
//             ? const AppState.unauthenticated()
//             : dataRepository.currentRoom.isEmpty
//                 ? AppState.authenticated(authenticationRepository.currentUser)
//                 : AppState.inRoom(authenticationRepository.currentUser,
//                     dataRepository.currentRoom)) {
//     on<_AppUserChanged>(_onUserChanged);
//     on<AppLogoutRequested>(_onLogoutRequested);
//     on<_AppRoomChanged>(_onRoomChanged);
//     on<AppLeaveRoomRequested>(_onLeaveRoomRequested);
//     _userSubscription = _authenticationRepository.user.listen(
//       (user) => add(_AppUserChanged(user)),
//     );
//     _roomSubscription = _dataRepository.streamRoom().listen(
//           (room) => add(_AppRoomChanged(room)),
//         );
//   }

//   final AuthenticationRepository _authenticationRepository;
//   late final StreamSubscription<User> _userSubscription;
//   final DataRepository _dataRepository;
//   late final StreamSubscription<Room> _roomSubscription;

//   void _onUserChanged(
//     _AppUserChanged event,
//     Emitter<AppState> emit,
//   ) {
//     emit(
//       event.user.isNotEmpty
//           ? AppState.authenticated(event.user)
//           : const AppState.unauthenticated(),
//     );
//   }

//   void _onLogoutRequested(
//     AppLogoutRequested event,
//     Emitter<AppState> emit,
//   ) {
//     unawaited(_authenticationRepository.logOut());
//   }

//   void _onRoomChanged(
//     _AppRoomChanged event,
//     Emitter<AppState> emit,
//   ) {
//     emit(event.room.isNotEmpty
//         ? AppState.inRoom(
//             _authenticationRepository.currentUser,
//             event.room,
//           )
//         : AppState.authenticated(
//             _authenticationRepository.currentUser,
//           ));
//   }

//   void _onLeaveRoomRequested(
//     AppLeaveRoomRequested event,
//     Emitter<AppState> emit,
//   ) {
//     _dataRepository.leaveRoom();
//   }

//   @override
//   Future<void> close() {
//     _userSubscription.cancel();
//     _roomSubscription.cancel();
//     return super.close();
//   }
// }



























// import 'dart:async';

// import 'package:authentication_repository/authentication_repository.dart';
// import 'package:bloc/bloc.dart';
// import 'package:data_repository/data_repository.dart';
// import 'package:equatable/equatable.dart';

// part 'app_event.dart';
// part 'app_state.dart';

// class AppBloc extends Bloc<AppEvent, AppState> {
//   AppBloc({required AuthenticationRepository authenticationRepository})
//       : _authenticationRepository = authenticationRepository,
//         super(
//           authenticationRepository.currentUser.isEmpty
//               ? const AppState.unauthenticated()
//               : AppState.authenticated(authenticationRepository.currentUser),
//         ) {
//     on<_AppUserChanged>(_onUserChanged);
//     on<AppLogoutRequested>(_onLogoutRequested);
//     _userSubscription = _authenticationRepository.user.listen(
//       (user) => add(_AppUserChanged(user)),
//     );
//   }

//   final AuthenticationRepository _authenticationRepository;
//   late final StreamSubscription<User> _userSubscription;

//   void _onUserChanged(
//     _AppUserChanged event,
//     Emitter<AppState> emit,
//   ) {
//     emit(
//       event.user.isNotEmpty
//           ? AppState.authenticated(event.user)
//           : const AppState.unauthenticated(),
//     );
//   }

//   void _onLogoutRequested(
//     AppLogoutRequested event,
//     Emitter<AppState> emit,
//   ) {
//     unawaited(_authenticationRepository.logOut());
//   }

//   @override
//   Future<void> close() {
//     _userSubscription.cancel();
//     return super.close();
//   }
// }
