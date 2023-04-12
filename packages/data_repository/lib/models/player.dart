import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

//TODO divide models and DTOs (?)

class Player extends Equatable {
  const Player({
    this.id = '',
    required this.userId,
    required this.nick,
    required this.isLeader,
    this.character,
  });

  final String id;
  final String userId;
  final String nick;
  final bool isLeader;
  final String? character;

  /// Empty player which represents that user is currently not in any player.
  static const empty = Player(userId: '', nick: '', isLeader: false);

  /// Convenience getter to determine whether the current player is empty.
  bool get isEmpty => this == Player.empty;

  /// Convenience getter to determine whether the current player is not empty.
  bool get isNotEmpty => this != Player.empty;

  @override
  List<Object?> get props => [id, userId, nick, isLeader, character];

  factory Player.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data();
    return Player(
      id: doc.id,
      userId: data?["user_id"],
      nick: data?['nick'],
      isLeader: data?['is_leader'],
      character: data?['character'],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      "user_id": userId,
      "nick": nick,
      'is_leader': isLeader,
      if (character != null) "character": character,
    };
  }
}
