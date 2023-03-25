// ignore_for_file: unnecessary_null_comparison

import 'package:cloud_firestore/cloud_firestore.dart';

class Player {
  const Player({
    required this.id,
    required this.userUid,
    required this.nick,
    this.character,
  });

  final String id;
  final String userUid;
  final String nick;
  final String? character;

  factory Player.fromFiresore(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data();
    return Player(
      id: doc.id,
      userUid: data?["user_uid"],
      nick: data?['nick'],
      character: data?['character'],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      "user_uid": userUid,
      "nick": nick,
      if (character != null) "character": character,
    };
  }
}
