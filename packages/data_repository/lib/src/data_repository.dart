import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:data_repository/models/member.dart';
import 'package:data_repository/models/models.dart';
import 'package:cache/cache.dart';

part 'data_failures.dart';
// TODO unique room name (kahoot-like) https://stackoverflow.com/questions/47543251/firestore-unique-index-or-unique-constraint
// TODO divide this moloch (mixins?, extension methods?)

class DataRepository {
  DataRepository({
    CacheClient? cache,
    FirebaseFirestore? firestore,
  })  : _cache = cache ?? CacheClient(),
        _firestore = firestore ?? FirebaseFirestore.instance;

  final CacheClient _cache;
  final FirebaseFirestore _firestore;

  //------------------------room------------------------
  static const roomCacheKey = '__room_cache_key__';

  Room get currentRoom {
    return _cache.read<Room>(key: roomCacheKey) ?? Room.empty;
  }

  /// room stream getter
  Stream<Room> streamRoom() {
    if (currentRoom.isEmpty) {
      throw const StreamingRoomFailure(
          "Current room is Room.empty (has no ID)");
    }
    return _firestore
        .collection('rooms')
        .doc(currentRoom.id)
        .snapshots()
        .map((snap) {
      _cache.write(key: roomCacheKey, value: Room.fromFirestore(snap));
      return Room.fromFirestore(snap);
    });
  }

  // TODO add players number limitation on room creation or in firebase rules
  Future<void> createRoom() async {
    final roomRef =
        await _firestore.collection('rooms').add(Room.empty.toFirestore());

    final snap = await roomRef.get();
    _cache.write(key: roomCacheKey, value: Room.fromFirestore(snap));
  } // TODO should create 1 2 3 4 5 squads

  Future<void> joinRoom({required String roomId}) async {
    final roomRef = _firestore.collection('rooms').doc(roomId);
    var roomSnap = await roomRef.get();

    if (!roomSnap.exists) throw GetRoomByIdFailure();

    final snap = await roomRef.get();
    _cache.write(key: roomCacheKey, value: Room.fromFirestore(snap));
  }

  //-----------------------------player------------------------------------
  static const playerCacheKey = '__player_cache_key__';

  Player get currentPlayer {
    return _cache.read<Player>(key: playerCacheKey) ?? Player.empty;
  }

  /// player stream getter
  Stream<Player> streamPlayer() {
    if (currentPlayer.isEmpty) {
      throw const StreamingPlayerFailure(
          "Current player is Player.empty (has no ID)");
    }
    return _firestore
        .collection('rooms')
        .doc(currentRoom.id)
        .collection('players')
        .doc(currentPlayer.id)
        .snapshots()
        .map((snap) {
      _cache.write(key: playerCacheKey, value: Player.fromFirestore(snap));
      return Player.fromFirestore(snap);
    });
  }

  Future<void> writeinPlayer({
    required String userId,
    required String nick,
    bool isLeader = false,
  }) async {
    var player = Player(userId: userId, nick: nick, isLeader: isLeader);

    final playerRef = await _firestore
        .collection('rooms')
        .doc(currentRoom.id)
        .collection('players')
        .add(player.toFirestore());

    final snap = await playerRef.get();
    _cache.write(key: playerCacheKey, value: Player.fromFirestore(snap));
  }

  Future<void> leaveRoom() async {
    await removePlayer(playerId: currentPlayer.id);
    _cache.write(key: playerCacheKey, value: Player.empty);
    _cache.write(key: roomCacheKey, value: Room.empty);
  }

  //-----------------------------players------------------------------------
  /// player list stream getter
  Stream<List<Player>> streamPlayersList() {
    return _firestore
        .collection('rooms')
        .doc(currentRoom.id)
        .collection('players')
        .snapshots()
        .map((list) =>
            list.docs.map((snap) => Player.fromFirestore(snap)).toList());
  }

  Future<void> removePlayer({required String playerId}) async {
    if (currentPlayer.isEmpty) {
      throw const StreamingPlayerFailure(
          "Current player is Player.empty (has no ID)");
    }
    await _firestore
        .collection('rooms')
        .doc(currentRoom.id)
        .collection('players')
        .doc(playerId)
        .delete();
  }

  //--------------------------------squad-------------------------------------
  // TODO differenciate squad by voting, not quest

  Stream<List<Member>> streamSquadList({required int questNumber}) {
    return _firestore
        .collection('rooms')
        .doc(currentRoom.id)
        .collection('squads')
        .doc(questNumber.toString())
        .collection('members')
        .snapshots()
        .map((list) =>
            list.docs.map((snap) => Member.fromFirestore(snap)).toList());
  }

  /// add player to squad

  /// remove player from squad

  /// remove all players from squad
}
