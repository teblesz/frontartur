// ignore_for_file: unnecessary_null_comparison

import 'package:data_repository/models/models.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class Member extends Equatable {
  const Member({
    this.id = '',
    required this.playerId,
    required this.nick,
    this.vote,
  });

  final String id;
  final String playerId;
  final String nick;
  final bool? vote;

  /// Empty member which represents that user is currently not in any member.
  static const empty = Member(id: '', playerId: '', nick: '');

  /// Convenience getter to determine whether the current member is empty.
  bool get isEmpty => this == Member.empty;

  /// Convenience getter to determine whether the current member is not empty.
  bool get isNotEmpty => this != Member.empty;

  @override
  List<Object?> get props => [id, playerId, nick, vote];

  factory Member.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data();
    return Member(
      id: doc.id,
      playerId: data?["player_id"],
      nick: data?['nick'],
      vote: data?['secret_vote'],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      "player_id": playerId,
      "nick": nick,
      if (vote != null) "secret_vote": vote,
    };
  }
}
