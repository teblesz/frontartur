import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:data_repository/src/models/models.dart';

import 'package:cache/cache.dart';

// TODO unique room name (kahoot-like) https://stackoverflow.com/questions/47543251/firestore-unique-index-or-unique-constraint

class GetRoomByIdFailure implements Exception {
  // const GetRoomByIdFailure([this.message = 'An unknown exception occurred.']);

  // factory GetRoomByIdFailure.fromCode(String code) {
  //   switch (code) {
  //     case 'invalid-id':
  //       return const GetRoomByIdFailure(
  //         'Room ID is invalid',
  //       );
  //     case 'no-doc-with-id':
  //       return const GetRoomByIdFailure(
  //         'No active room with this ID',
  //       );
  //     default:
  //       return const GetRoomByIdFailure();
  //   }
  // }

  // /// The associated error message.
  // final String message;
}

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
    // TODO maybe change Room to something smaller (RoomId..?)
    return _cache.read<Room>(key: roomCacheKey) ?? Room.empty;
  }

  Stream<Room> streamRoom() {
    return _firestore
        .collection('rooms')
        .doc(currentRoom.id)
        .snapshots()
        .map((snap) {
      _cache.write(key: roomCacheKey, value: Room.fromFirestore(snap));
      return Room.fromFirestore(snap);
    });
  }

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
