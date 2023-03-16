import 'models.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Room {
  Room({
    required this.id,
    required this.name,
  });

  final String id;
  final String name;
  List<Player>? players;
  List<Map<Player, Vote>>? commonVotes; // TODO ilosc glosowan na NIE
  List<Squad>? squads;
  RoomConfiguration? roomConfiguration;

  static Room fromSnapshot(
          QueryDocumentSnapshot<Map<String, dynamic>> snapshot) =>
      Room(
        id: snapshot.data()['id'],
        name: snapshot.data()['name'],
      );

  Map<String, dynamic> toMap() => {
        'id': id,
        'name': name,
      };
}
