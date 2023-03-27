part of 'game_cubit.dart';

enum GameStatus {
  /// just started, roles need to be assigned
  initialized,

  /// squad is being chosed
  squadVoting,

  /// chosen squad votes in secret
  questVoting,

  /// one of the teams has won
  gameEnded,
}

class GameState extends Equatable {
  const GameState({
    this.status = GameStatus.initialized,
  });

  final GameStatus status;

  @override
  List<Object> get props => [status];

  GameState copyWith({
    GameStatus? status,
  }) {
    return GameState(
      status: status ?? this.status,
    );
  }
}
