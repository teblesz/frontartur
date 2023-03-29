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
  // }

  Stream<QuestStatus> streamQuestResult({required int questNumber}) {
    //TODO ! exception for 4th
    //TODO make cleaner
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
}
