import 'package:bloc/bloc.dart';
import 'package:data_repository/data_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:form_inputs/form_inputs.dart';
import 'package:formz/formz.dart';

part 'matchup_states.dart';

class MatchupCubit extends Cubit<MatchupState> {
  MatchupCubit(this._dataRepository) : super(const MatchupState());

  final DataRepository _dataRepository;

  void nickChanged(String value) {
    final nick = Nick.dirty(value);
    emit(
      state.copyWith(
        nick: nick,
        status: Formz.validate([nick]),
      ),
    );
  }

  Future<void> writeinPlayerWithUserId(String userId) async {
    if (!state.status.isValidated) return;
    emit(state.copyWith(status: FormzStatus.submissionInProgress));
    try {
      await _dataRepository.writeinPlayer(
        nick: state.nick.value,
        userId: userId,
      );
      emit(state.copyWith(status: FormzStatus.submissionSuccess));
    } catch (_) {
      emit(state.copyWith(status: FormzStatus.submissionFailure));
    }
  }

  Future<void> removePlayer(Player player) async {
    _dataRepository.removePlayer(playerId: player.id);
  }
}
