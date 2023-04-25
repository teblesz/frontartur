part of 'game_cubit.dart';

enum GameStatus {
  /// squad is being chosed
  squadChoice,

  /// squad is being voted on
  squadVoting,

  /// chosen squad votes in secret
  questVoting,

  /// quest resolved
  questResults,

  /// one of the teams has won
  gameResults,
}

class GameState extends Equatable {
  const GameState({
    this.status = GameStatus.squadChoice,
    this.questNumber = 1,
    this.lastQuestOutcome = false,
  });

  final GameStatus status;
  final int questNumber;
  final bool lastQuestOutcome;

  @override
  List<Object> get props => [status, questNumber, lastQuestOutcome];

  GameState copyWith({
    GameStatus? status,
    int? questNumber,
    bool? lastQuestOutcome,
  }) {
    return GameState(
      status: status ?? this.status,
      questNumber: questNumber ?? this.questNumber,
      lastQuestOutcome: lastQuestOutcome ?? this.lastQuestOutcome,
    );
  }
}

class SquadMissingFieldOnResultsFailure implements Exception {
  const SquadMissingFieldOnResultsFailure(
      [this.message =
          'Squad is approved but field is_successful field is missing, '
              'while user displays quest results.']);

  final String message;
}
