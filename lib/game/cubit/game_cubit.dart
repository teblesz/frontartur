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
  GameCubit(this._dataRepository) : super(const GameState());

  final DataRepository _dataRepository;

  // bool isQuestResultUnknown({required int questNumber}) {
  //   if (state.questNumber < questNumber) return true;
  //   if (state.questNumber == questNumber &&
  //       state.status != GameStatus.questResults) return true;
  //   return false;
  // } // TODO use above thing in quest results preferably

  Stream<QuestStatus> streamQuestResult({required int questNumber}) {
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
    await _dataRepository.addMember(
      questNumber: state.questNumber,
      playerId: player.id,
      nick: player.nick,
    );
  }

  /// remove player from squad
  Future<void> removeMember({required Member member}) async {
    await _dataRepository.removeMember(
      questNumber: state.questNumber,
      memberId: member.id,
    );
  }

  /// remove all players from squad
  Future<void> removeAllMembers() async {
    await _dataRepository.removeAllMembers(
      questNumber: state.questNumber,
    );
  }
}
