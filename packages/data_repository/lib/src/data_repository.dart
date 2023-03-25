import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:data_repository/models/models.dart';
import 'package:cache/cache.dart';

part 'data_failures.dart';
// TODO unique room name (kahoot-like) https://stackoverflow.com/questions/47543251/firestore-unique-index-or-unique-constraint

class DataRepository {
  DataRepository({
    CacheClient? cache,
    FirebaseFirestore? firestore,
  })  : _cache = cache ?? CacheClient(),
        _firestore = firestore ?? FirebaseFirestore.instance;

  final CacheClient _cache;
  final FirebaseFirestore _firestore;

  static const roomCacheKey = '__room__id_cache_key__';

  Room get currentRoom {
    return _cache.read<Room>(key: roomCacheKey) ?? Room.empty;
  }

  /// room stream getter
  Stream<Room> streamRoom() {
    if (currentRoom.isEmpty) {
      throw const StreamingRoomFailure(
          "Current Room is Room.empty (has no ID)");
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

  /// player list stream getter
  Stream<List<Player>> streamPlayersList() {
    return _firestore
        .collection('rooms')
        .doc(currentRoom.id)
        .collection('players')
        .snapshots()
        .map((list) =>
            list.docs.map((snap) => Player.fromFiresore(snap)).toList());
  }

  // TODO add players number limitation on room creation
  Future<void> createRoom({required Player player}) async {
    final roomRef =
        await _firestore.collection('rooms').add(Room.empty.toFirestore());

    final snap = await roomRef.get();
    _cache.write(key: roomCacheKey, value: Room.fromFirestore(snap));

    //join created room
    roomRef.collection('players').add(player.toFirestore());
  }

  Future<void> joinRoom({
    required String roomId,
    required Player player,
  }) async {
    final roomRef = _firestore.collection('rooms').doc(roomId);
    var roomSnap = await roomRef.get();

    if (!roomSnap.exists) throw GetRoomByIdFailure();

    // TODO !!! first check if users player was already present (accidental leave etc)
    roomRef.collection('players').add(player.toFirestore());

    final snap = await roomRef.get();
    _cache.write(key: roomCacheKey, value: Room.fromFirestore(snap));
  }

  void leaveRoom() {
    //dont change database
    _cache.write(key: roomCacheKey, value: Room.empty);
  }
}
