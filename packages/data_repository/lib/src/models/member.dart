import 'package:data_repository/src/models/models.dart';

class Member {
  const Member({
    required this.id,
    required this.playerId,
    this.secretVote,
  });

  final String id;
  final String playerId;
  final Vote? secretVote;
}
