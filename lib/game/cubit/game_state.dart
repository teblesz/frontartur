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

enum QuestStatus {
  success,
  fail,
  ongoing,
  upcoming,
  error,
}

class GameState extends Equatable {
  const GameState({
    this.status = GameStatus.squadChoice,
    this.questNumber = 1,
    this.lastQuestOutcome = false,
    this.questStatuses = const [
      QuestStatus.ongoing,
      QuestStatus.upcoming,
      QuestStatus.upcoming,
      QuestStatus.upcoming,
      QuestStatus.upcoming,
    ],
    this.winningTeam = true,
  });

  final GameStatus status;
  final int questNumber;
  final bool lastQuestOutcome;
  final List<QuestStatus> questStatuses;
  final bool winningTeam;

  @override
  List<Object> get props =>
      [status, questNumber, lastQuestOutcome, questStatuses, winningTeam];

  GameState copyWith({
    GameStatus? status,
    int? questNumber,
    bool? lastQuestOutcome,
    List<QuestStatus>? questStatuses,
    bool? gameIsWon,
  }) {
    return GameState(
      status: status ?? this.status,
      questNumber: questNumber ?? this.questNumber,
      lastQuestOutcome: lastQuestOutcome ?? this.lastQuestOutcome,
      questStatuses: questStatuses ?? this.questStatuses,
      winningTeam: gameIsWon ?? this.winningTeam,
    );
  }

  List<QuestStatus> insertToQuestStatuses(QuestStatus status) {
    final statuses = questStatuses.toList(growable: false);
    statuses[questNumber - 1] = status;
    return statuses;
  }
}

class SquadMissingFieldOnResultsFailure implements Exception {
  const SquadMissingFieldOnResultsFailure(
      [this.message =
          'Squad is approved but field is_successful field is missing, '
              'while user displays quest results.']);

  final String message;
}
