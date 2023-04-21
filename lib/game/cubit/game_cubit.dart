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

  // TODO this just seems like doing BLoC but around
  GameCubit(this._dataRepository) : super(const GameState()) {
    _dataRepository.subscribeSquadWith(
      squadId: _dataRepository.currentRoom.currentSquadId,
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
  }

  /// steering the game course through states and squad props
  Future<void> doGameLoop(Squad squad) async {
    emit(state.copyWith(questNumber: squad.questNumber));
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
          if (_dataRepository.currentPlayer.isLeader) {
            await _dataRepository.nextSquad(questNumber: squad.questNumber);
            await _dataRepository.nextLeader();
          }
          emit(state.copyWith(status: GameStatus.squadChoice));
        }
        break;
      case GameStatus.questVoting: //TODO
        //leader listen for results and sets up isSuccessfull, //here exception for 4th quest
        //everybody listens for is succ and then see results
        // get resutls
        // leader sets up is successfull flag or it's counted everytime
        // popup results after circle progress idicator
        break;
      case GameStatus.questResults: //TODO
        //giveinfoAboutVotes()
        if (await _checkEndGameCondition()) {
          emit(state.copyWith(status: GameStatus.gameResults));
          return;
        }
        if (_dataRepository.currentPlayer.isLeader) {
          await _dataRepository.nextLeader();
        }
        break;
      case GameStatus.gameResults: //TODO
        //add state here - voting to kill merlin
        //present gaame results, give button to go back to lobby
        // show players characters

        break;
    }
  }

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
}
