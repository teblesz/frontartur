import 'package:equatable/equatable.dart';

import 'models.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// TODO unique room name (kahoot-like) https://stackoverflow.com/questions/47543251/firestore-unique-index-or-unique-constraint
// TODO limitatons on number of records in subcollections

// TODO !!! host, and current squad leader info
class Room extends Equatable {
  final String id;
  final List<String>? characters;
  final List<Player>? players;
  final Map<Player, bool>? commonVotes; // TODO lista, ilosc na NIE
  final List<Squad>? squads;

  const Room({
    required this.id,
    this.characters,
    this.players,
    this.commonVotes,
    this.squads,
  });

  /// Empty room which represents that user is currently not in any room.
  static const empty = Room(id: '');

  /// Convenience getter to determine whether the current room is empty.
  bool get isEmpty => this == Room.empty;

  /// Convenience getter to determine whether the current room is not empty.
  bool get isNotEmpty => this != Room.empty;

  @override
  List<Object?> get props => [id, characters, players, commonVotes, squads];

  factory Room.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data();
    return Room(
      id: doc.id,
      characters: data?['characters'] is Iterable
          ? List.from(data?['characters'])
          : List.empty(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      if (characters != null) "characters": characters,
    };
  }
}
