part of 'game_cubit.dart';

enum GameStatus {
  /// just started, roles need to be assigned
  initialized,

  /// squad is being chosed
  squadVoting,

  /// chosen squad votes in secret
  questVoting,

  /// one of the teams has won
  questResults,
}

class GameState extends Equatable {
  const GameState({
    this.status = GameStatus.initialized,
    this.questNumber = 1,
  });

  final GameStatus status;
  final int questNumber;

  @override
  List<Object> get props => [status, questNumber];

  GameState copyWith({
    GameStatus? status,
    int? questNumber,
  }) {
    return GameState(
      status: status ?? this.status,
      questNumber: questNumber ?? this.questNumber,
    );
  }
}
