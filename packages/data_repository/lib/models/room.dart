import 'package:equatable/equatable.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Room extends Equatable {
  final String id;
  final String hostUserId;
  final bool gameStarted;
  final List<String> characters;
  // final List<Player>? players;
  // final Map<Player, bool>? commonVotes; // TODO lista, ilosc na NIE
  // final List<Squad>? squads;

  const Room({
    required this.id,
    required this.hostUserId,
    required this.gameStarted,
    required this.characters,
  });

  Room.init({required this.hostUserId})
      : id = '',
        gameStarted = false,
        characters = <String>[];

  /// Empty room which represents that user is currently not in any room.
  static const empty = Room(
    id: '',
    hostUserId: '',
    gameStarted: false,
    characters: <String>[],
  );

  /// Convenience getter to determine whether the current room is empty.
  bool get isEmpty => this == Room.empty;

  /// Convenience getter to determine whether the current room is not empty.
  bool get isNotEmpty => this != Room.empty;

  @override
  List<Object?> get props => [id, hostUserId, gameStarted, characters];

  factory Room.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data();
    return Room(
      id: doc.id,
      hostUserId: data?['host_user_id'],
      gameStarted: data?['game_started'],
      characters: data?['characters'] is Iterable
          ? List.from(data?['characters'])
          : List.empty(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'host_user_id': hostUserId,
      'game_started': gameStarted,
      "characters": characters,
    };
  }
}
