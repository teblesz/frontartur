import 'package:equatable/equatable.dart';

import 'models.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// TODO unique room name (kahoot-like) https://stackoverflow.com/questions/47543251/firestore-unique-index-or-unique-constraint
// TODO limitatons on number of records in subcollections

class Room extends Equatable {
  final String id;
  final String hostUserId;
  final List<String>? characters;
  // final List<Player>? players;
  // final Map<Player, bool>? commonVotes; // TODO lista, ilosc na NIE
  // final List<Squad>? squads;

  const Room({
    required this.id,
    required this.hostUserId,
    this.characters,
  });

  const Room.init({required this.hostUserId})
      : id = '',
        characters = null;

  /// Empty room which represents that user is currently not in any room.
  static const empty = Room(id: '', hostUserId: '');

  /// Convenience getter to determine whether the current room is empty.
  bool get isEmpty => this == Room.empty;

  /// Convenience getter to determine whether the current room is not empty.
  bool get isNotEmpty => this != Room.empty;

  @override
  List<Object?> get props => [id, hostUserId, characters];

  factory Room.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data();
    return Room(
      id: doc.id,
      hostUserId: data?['host_user_id'],
      characters: data?['characters'] is Iterable
          ? List.from(data?['characters'])
          : List.empty(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'host_user_id': hostUserId,
      if (characters != null) "characters": characters,
    };
  }
}
