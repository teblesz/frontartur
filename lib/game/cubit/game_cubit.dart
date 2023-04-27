import 'package:data_repository/data_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

part 'game_state.dart';

class GameCubit extends Cubit<GameState> {
  final DataRepository _dataRepository;

  GameCubit(this._dataRepository) : super(const GameState()) {
    _dataRepository.subscribeSquadIsSubmittedWith(
      doLogic: doSquadLoop,
    ); //first squad
    _dataRepository.subscribeCurrentSquadIdWith(
      doLogic: (currentSquadId) {
        _dataRepository.unsubscribeSquadIsSubmitted();
        _dataRepository.subscribeSquadIsSubmittedWith(
          squadId: currentSquadId,
          doLogic: doSquadLoop,
        );
      },
    ); // subs to next squads
  }

  @override
  Future<void> close() {
    _dataRepository.unsubscribeCurrentSquadId();
    return super.close();
  }

  Stream<List<Player>> streamPlayersList() {
    return _dataRepository.streamPlayersList();
  }

  Stream<List<Member>> streamMembersList({required squadId}) {
    return _dataRepository.streamMembersList(squadId: squadId);
  }

  //--------------------------------leader's logic-------------------------------------

  /// add player to squad
  Future<void> addMember({required Player player}) async {
    if (!_dataRepository.currentPlayer.isLeader) return;
    if (state.status != GameStatus.squadChoice) return;

    await _dataRepository.addMember(
      questNumber: state.questNumber,
      playerId: player.id,
      nick: player.nick,
    );
  }

  /// remove player from squad
  Future<void> removeMember({required Member member}) async {
    if (!_dataRepository.currentPlayer.isLeader) return;
    if (state.status != GameStatus.squadChoice) return;

    await _dataRepository.removeMember(
      questNumber: state.questNumber,
      memberId: member.id,
    );
  }

  Future<void> submitSquad() async {
    await _dataRepository.submitSquad();
    // leader counts squad votes
    _dataRepository.subscribeSquadVotesWith(doLogic: _assessSquadVoteResults);
  }

  Future<void> _assessSquadVoteResults(Map<String, bool> votes) async {
    final playersCount = await _dataRepository.playersCount;
    if (playersCount > votes.length) return;

    _dataRepository.unsubscribeSquadVotes();
    final positiveVotesCount = votes.values.where((v) => v == true).length;
    if (positiveVotesCount > votes.length / 2) {
      await _dataRepository.updateSquadIsApproved();
      _dataRepository.subscribeQuestVotesWith(doLogic: _assessQuestVoteResults);
    } else {
      await _dataRepository.updateSquadIsApproved(isApproved: false);
      await _dataRepository.nextLeader();
      await _dataRepository.nextSquad(questNumber: state.questNumber);
    }
  }

  Future<void> _assessQuestVoteResults(List<bool?> votes) async {
    // TODO change vote to enum and check them with any == voteenum.empty
    final membersCount = await _dataRepository.membersCount;
    if (membersCount > votes.length) return;
    if (votes.any((v) => v == null)) return;

    _dataRepository.unsubscribeQuestVotes();

    final playersCount = await _dataRepository.playersCount;
    final isTwoFailsQuest = _isTwoFailsQuest(playersCount, state.questNumber);

    final negativeVotesCount = votes.where((v) => v == false).length;
    if ((isTwoFailsQuest && negativeVotesCount >= 2) ||
        (!isTwoFailsQuest && negativeVotesCount >= 1)) {
      await _dataRepository.updateSquadIsSuccessfull(isSuccessfull: false);
    } else {
      await _dataRepository.updateSquadIsSuccessfull();
    }

    await _dataRepository.nextLeader();
    await _dataRepository.nextSquad(questNumber: state.questNumber + 1);
  }
  //--------------------------------players's logic-------------------------------------

  Future<void> voteSquad(bool vote) async {
    await _dataRepository.voteSquad(vote);
  }

  /// steering the game course through states and squad props
  Future<void> doSquadLoop(Squad squad) async {
    emit(state.copyWith(questNumber: squad.questNumber)); // update questNumber
    switch (state.status) {
      case GameStatus.squadChoice:
        if (squad.isSubmitted) {
          emit(state.copyWith(status: GameStatus.squadVoting));
        }
        break;
      case GameStatus.squadVoting:
        if (squad.isApproved == null) return;
        if (squad.isApproved!) {
          emit(state.copyWith(status: GameStatus.questVoting));
        } else {
          emit(state.copyWith(status: GameStatus.squadChoice));
        }
        break;
      case GameStatus.questVoting:
        if (squad.isSuccessfull == null) return;
        emit(state.copyWith(
            questStatuses: state.insertToQuestStatuses(
          squad.isSuccessfull == true ? QuestStatus.success : QuestStatus.fail,
        )));

        emit(state.copyWith(lastQuestOutcome: squad.isSuccessfull));
        emit(state.copyWith(status: GameStatus.questResults));
        break;
      case GameStatus.questResults:
        break;
      case GameStatus.gameResults:
        break;
    }
  }

  Future<void> closeQuestResults() async {
    final winningTeam = await winningTeamIs();
    if (winningTeam == null) {
      emit(state.copyWith(status: GameStatus.squadChoice));
      emit(state.copyWith(
          questStatuses: state.insertToQuestStatuses(QuestStatus.ongoing)));
    } else {
      emit(state.copyWith(status: GameStatus.gameResults));
    }
  }

  Future<bool> isCurrentPlayerAMember() async {
    return _dataRepository.isCurrentPlayerAMember();
  }

  Future<List<Player>> listOfEvilPlayers() async {
    final players = await _dataRepository.playersList();
    return players.where((p) => p.character == 'evil').toList();
  }

//--------------------------------game rules logic-------------------------------------
  bool _isTwoFailsQuest(int playersCount, int questNumber) =>
      playersCount >= 7 && questNumber == 4;

  Future<bool?> winningTeamIs() async {
    final approvedSquads = await _dataRepository.getApprovedSquads();

    int successCount = 0, failCount = 0;
    for (var squad in approvedSquads) {
      if (squad.isSuccessfull == null) {
        throw const SquadMissingFieldOnResultsFailure();
      }
      if (squad.isSuccessfull!) {
        successCount++;
      } else {
        failCount++;
      }
    }
    if (successCount >= 3) return true;
    if (failCount >= 3) return false;
    return null;
  }

  // GameCubit
}
