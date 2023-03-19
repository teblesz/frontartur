import 'models.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// TODO unique room name (kahoot-like) https://stackoverflow.com/questions/47543251/firestore-unique-index-or-unique-constraint

class Room {
  late String id;
  late List<String> characters;
  List<Player>? players;
  Map<Player, Vote>? commonVotes; // TODO lista, ilosc glosowan na NIE
  List<Squad>? squads;

  Room({
    required this.id,
    required this.characters,
    this.players,
    this.commonVotes,
    this.squads,
  });

  factory Room.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data();
    return Room(
      id: doc.id,
      characters: data?['characters'] is Iterable
          ? List.from(data?['characters'])
          : List.empty(),
    );
  }
}
