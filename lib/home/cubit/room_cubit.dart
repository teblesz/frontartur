import 'package:data_repository/data_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'room_state.dart';

/// cubit responsible for routing between lobby, matchup and game layers
class RoomCubit extends Cubit<RoomState> {
  RoomCubit(this._dataRepository) : super(const RoomState());

  final DataRepository _dataRepository;

  /// directs to game pages
  void goToGame() {
    _dataRepository.unsubscribeGameStarted();
    emit(state.copyWith(status: RoomStatus.inGame));
  }

  /// directs to matchup page
  void goToMatchup() {
    emit(state.copyWith(status: RoomStatus.inMathup));
  }

  /// directs back to lobby
  void leaveRoom() {
    _dataRepository.unsubscribeGameStarted();
    _dataRepository.leaveRoom();
    emit(state.copyWith(status: RoomStatus.inLobby));
  }

  void subscribeToGameStarted() {
    _dataRepository.subscribeGameStartedWith(doLogic: (gameStarted) {
      if (gameStarted) goToGame();
    });
  }
}
