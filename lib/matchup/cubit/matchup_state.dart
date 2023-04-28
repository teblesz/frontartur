part of 'matchup_cubit.dart';

// TODO add error messages in cubits
class MatchupState extends Equatable {
  const MatchupState({
    this.nick = const Nick.pure(),
    this.status = FormzStatus.pure,
    this.errorMessage,
    this.playersCount = 0,
  });

  final Nick nick;
  // TODO add chharacter config status here
  final FormzStatus status;
  final String? errorMessage;
  final int playersCount;

  @override
  List<Object> get props => [nick, status, playersCount];

  MatchupState copyWith({
    Nick? nick,
    FormzStatus? status,
    String? errorMessage,
    int? playersCount,
  }) {
    return MatchupState(
      nick: nick ?? this.nick,
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
      playersCount: playersCount ?? this.playersCount,
    );
  }
}
