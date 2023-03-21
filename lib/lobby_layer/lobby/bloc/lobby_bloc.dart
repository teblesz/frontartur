// import 'dart:async';

// import 'package:authentication_repository/authentication_repository.dart';
// import 'package:bloc/bloc.dart';
// import 'package:equatable/equatable.dart';

// part 'lobby_event.dart';
// part 'lobby_state.dart';

// class LobbyBloc extends Bloc<LobbyEvent, LobbyState> {
//   LobbyBloc({required AuthenticationRepository authenticationRepository})
//       : _authenticationRepository = authenticationRepository,
//         super(
//           authenticationRepository.currentUser.isNotEmpty
//               ? LobbyState.authenticated(authenticationRepository.currentUser)
//               : const LobbyState.unauthenticated(),
//         ) {
//     on<_LobbyUserChanged>(_onUserChanged);
//     on<LobbyLogoutRequested>(_onLogoutRequested);
//     _userSubscription = _authenticationRepository.user.listen(
//       (user) => add(_LobbyUserChanged(user)),
//     );
//   }

//   final AuthenticationRepository _authenticationRepository;
//   late final StreamSubscription<User> _userSubscription;

//   void _onUserChanged(_LobbyUserChanged event, Emitter<LobbyState> emit) {
//     emit(
//       event.user.isNotEmpty
//           ? LobbyState.authenticated(event.user)
//           : const LobbyState.unauthenticated(),
//     );
//   }

//   void _onLogoutRequested(
//       LobbyLogoutRequested event, Emitter<LobbyState> emit) {
//     unawaited(_authenticationRepository.logOut());
//   }

//   @override
//   Future<void> close() {
//     _userSubscription.cancel();
//     return super.close();
//   }
// }
