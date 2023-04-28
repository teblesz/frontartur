import 'package:equatable/equatable.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Room extends Equatable {
  final String id;
  final String hostUserId;
  final bool gameStarted;
  final String currentSquadId;
  final List<String> characters;
  final List<String> specialCharacters;
  final bool? merlinKilled;

  const Room({
    required this.id,
    required this.hostUserId,
    required this.gameStarted,
    required this.currentSquadId,
    required this.characters,
    required this.specialCharacters,
    this.merlinKilled,
  });

  Room.init({required this.hostUserId})
      : id = '',
        gameStarted = false,
        currentSquadId = '',
        characters = <String>[],
        specialCharacters = <String>[],
        merlinKilled = null;

  /// Empty room which represents that user is currently not in any room.
  static const empty = Room(
    id: '',
    hostUserId: '',
    gameStarted: false,
    currentSquadId: '',
    characters: <String>[],
    specialCharacters: <String>[],
    merlinKilled: null,
  );

  /// Convenience getter to determine whether the current room is empty.
  bool get isEmpty => this == Room.empty;

  /// Convenience getter to determine whether the current room is not empty.
  bool get isNotEmpty => this != Room.empty;

  @override
  List<Object?> get props => [
        id,
        hostUserId,
        gameStarted,
        currentSquadId,
        characters,
        specialCharacters,
        merlinKilled,
      ];

  factory Room.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data();
    return Room(
      id: doc.id,
      hostUserId: data?['host_user_id'],
      gameStarted: data?['game_started'],
      currentSquadId: data?['current_squad_id'],
      characters: data?['characters'] is Iterable
          ? List.from(data?['characters'])
          : List.empty(),
      specialCharacters: data?['special_characters'] is Iterable
          ? List.from(data?['special_characters'])
          : List.empty(),
      merlinKilled: data?['merlin_killed'],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'host_user_id': hostUserId,
      'game_started': gameStarted,
      'current_squad_id': currentSquadId,
      'characters': characters,
      'special_characters': specialCharacters,
      'merlin_killed': merlinKilled,
    };
  }
}
