part of 'matchup_cubit.dart';

class MatchupState extends Equatable {
  const MatchupState({
    this.nick = const Nick.pure(),
    this.status = FormzStatus.pure,
    this.errorMessage,
  });

  final Nick nick;
  // TODO add chharacter config status here
  final FormzStatus status;
  final String? errorMessage;

  @override
  List<Object> get props => [nick, status];

  MatchupState copyWith({
    Nick? nick,
    FormzStatus? status,
    String? errorMessage,
  }) {
    return MatchupState(
      nick: nick ?? this.nick,
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
