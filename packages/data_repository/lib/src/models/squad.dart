import 'player.dart';
import 'vote.dart';

class Squad {
  String? id;
  int? missionNumber;
  List<Player>? players;
  Map<Player, Vote>? secretVotes;
  bool? wasSuccessfull;
}
