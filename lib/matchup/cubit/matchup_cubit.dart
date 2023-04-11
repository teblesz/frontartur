import 'package:bloc/bloc.dart';
import 'package:data_repository/data_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:form_inputs/form_inputs.dart';
import 'package:formz/formz.dart';
import 'dart:math';

part 'matchup_state.dart';

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
      await _dataRepository.addPlayer(
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

  /// handles starting game logic
  Future<void> initGame() async {
    await _assignCharacters();
    await _assignLeader();
    await _dataRepository.setGameStarted();
  }

  Future<void> _assignCharacters() async {
    final numberOfPlayers = await _dataRepository.numberOfPlayers;
    final characters = _dataRepository.currentRoom.characters.isNotEmpty
        ? [..._dataRepository.currentRoom.characters] // clone
        : defaultCharacters(numberOfPlayers);
    characters.shuffle();
    await _dataRepository.assignCharacters(characters);
  }

  Future<void> _assignLeader() async {
    final numberOfPlayers = await _dataRepository.numberOfPlayers;
    int leaderIndex = Random().nextInt(numberOfPlayers);
    await _dataRepository.assignLeader(leaderIndex);
  }

  List<String> defaultCharacters(numberOfPlayers) {
    final numberOfEvils = (numberOfPlayers + 2) ~/ 3;
    return List.generate(
      numberOfPlayers,
      (index) => index < numberOfEvils ? 'evil' : 'good',
    );
  }

  Stream<bool> streamGameStarted() {
    return _dataRepository.streamRoom().map((room) => room.gameStarted);
  }
}
