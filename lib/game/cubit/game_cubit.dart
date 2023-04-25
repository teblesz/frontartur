import 'package:data_repository/data_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'game_state.dart';

enum QuestStatus {
  success,
  defeat,
  ongoing,
  upcoming,
}

class GameCubit extends Cubit<GameState> {
  final DataRepository _dataRepository;

  GameCubit(this._dataRepository) : super(const GameState()) {
    _dataRepository.subscribeSquadWith(
      doLogic: doGameLoop,
    ); //first squad
    _dataRepository.subscribeCurrentSquadIdWith(
      doLogic: (currentSquadId) {
        _dataRepository.unsubscribeSquadIsSubmitted();
        _dataRepository.subscribeSquadWith(
          squadId: currentSquadId,
          doLogic: doGameLoop,
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

  Stream<List<Member>> streamMembersList() {
    return _dataRepository.streamMembersList(
      questNumber: state.questNumber,
    );
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

  Future<void> _assessSquadVoteResults(List<bool> votes) async {
    final playersCount = await _dataRepository.playersCount;
    if (playersCount > votes.length) return;

    _dataRepository.unsubscribeSquadVotes();

    final positiveVotesCount = votes.where((v) => v == true).length;
    if (positiveVotesCount > votes.length / 2) {
      await _dataRepository.updateSquadIsApproved();
    } else {
      await _dataRepository.updateSquadIsApproved(isApproved: false);
      await _dataRepository.nextLeader();
      await _dataRepository.nextSquad(questNumber: state.questNumber);
    }

    // leader counts quest votes
    _dataRepository.subscribeQuestVotesWith(doLogic: _assessQuestVoteResults);
  }

  Future<void> _assessQuestVoteResults(List<bool?> votes) async {
    if (votes.any((v) => v == null)) return;

    _dataRepository.unsubscribeQuestVotes();

    final playersCount = await _dataRepository.playersCount;
    final isTwoFailsQuest = _isTwoFailsQuest(playersCount, state.questNumber);

    final negativeVotesCount = votes.where((v) => v == false).length;
    if ((isTwoFailsQuest && negativeVotesCount >= 2) ||
        (!isTwoFailsQuest && negativeVotesCount >= 1)) {
      await _dataRepository.updateSquadIsSuccessfull();
    } else {
      await _dataRepository.updateSquadIsSuccessfull(isSuccessfull: false);
    }

    await _dataRepository.nextLeader();
    await _dataRepository.nextSquad(questNumber: state.questNumber);
  }
  //--------------------------------players's logic-------------------------------------

  Future<void> voteSquad(bool vote) async {
    await _dataRepository.voteSquad(vote);
  }

  /// steering the game course through states and squad props
  /// reacts to changes in squad parameter and
  Future<void> doGameLoop(Squad squad) async {
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
      case GameStatus.questVoting: //TODO
        if (squad.isSuccessfull == null) return;
        emit(state.copyWith(status: GameStatus.questResults));
        // TODO popup results, emit either gamereuslts or squad voting after OK
        break;
      case GameStatus.questResults: //TODO

        if (await _checkEndGameCondition()) {
          emit(state.copyWith(status: GameStatus.gameResults));
          return;
        }
        break;
      case GameStatus.gameResults: //TODO
        //add state here - voting to kill merlin
        //present gaame results, give button to go back to lobby
        // show players characters

        break;
    }
  }

  //--------------------------------other logic-------------------------------------
  Future<bool> _checkEndGameCondition() async {
    //TODO
    // check quest votes and set up isSuccessfull
    return true;
  }

  Future<void> closeQuestResults() async {
    //TODO
    if (_dataRepository.currentPlayer.isLeader) {
      await _dataRepository.nextSquad(questNumber: state.questNumber + 1);
    }
    emit(state.copyWith(status: GameStatus.gameResults));
  }

  // TODO Add method using nextSquad

  //Subscribtion to isSubmitted
  // state = squadVOting
  // doLogic:
  // Navigator.push(
  //         context,
  //         MaterialPageRoute(builder: (context) => const MissionPage()),
  //       );

  //--------------

  // bool isQuestResultUnknown({required int questNumber}) {
  //   if (state.questNumber < questNumber) return true;
  //   if (state.questNumber == questNumber &&
  //       state.status != GameStatus.questResults) return true;
  //   return false;
  // } // TODO use above thing in quest results preferably
  Stream<QuestStatus> streamQuestResult({required int questNumber}) {
    //TODO trash this and rework
    //TODO !!! exception for 4th
    return _dataRepository
        .streamMembersList(questNumber: questNumber)
        .map((members) {
      if (members.isEmpty) return QuestStatus.upcoming;
      if (members.any((member) => member.secretVote == null)) {
        return QuestStatus.ongoing;
      }
      return members.any((member) => member.secretVote == false)
          ? QuestStatus.defeat
          : QuestStatus.success;
    });
  }

  void checkQuestInfo(int questNumber) {
    //if quest.successfull ?? giveinfoAboutVotes()
  }

  Future<bool> isCurrentPlayerAMember() async {
    return _dataRepository.isCurrentPlayerAMember();
  }

//--------------------------------game rules logic-------------------------------------
  bool _isTwoFailsQuest(int playersCount, int questNumber) =>
      playersCount >= 7 && questNumber == 4;
}
