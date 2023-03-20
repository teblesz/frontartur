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

/// for caching roomid
class RoomDocId {
  const RoomDocId(this.value);
  final String value;

  static RoomDocId empty = const RoomDocId("");
}

class DataRepository {
  DataRepository({
    CacheClient? cache,
    FirebaseFirestore? firestore,
  })  : _cache = cache ?? CacheClient(),
        _firestore = firestore ?? FirebaseFirestore.instance;

  final CacheClient _cache;
  final FirebaseFirestore _firestore;

  static const roomDocIdCacheKey = '__room__id_cache_key__';

  RoomDocId get currentRoomDocId {
    // TODO change Room to something smaller (RoomId..?)
    return _cache.read<RoomDocId>(key: roomDocIdCacheKey) ?? RoomDocId.empty;
  }

  Stream<Room> streamRoom() {
    return _firestore
        .collection('rooms')
        .doc(currentRoomDocId.value)
        .snapshots()
        .map((snap) {
      _cache.write(key: roomDocIdCacheKey, value: RoomDocId(snap.id));
      return Room.fromFirestore(snap);
    });
  }

  Stream<List<Player>> streamPlayersList() {
    return _firestore
        .collection('rooms')
        .doc(currentRoomDocId.value)
        .collection('players')
        .snapshots()
        .map((list) =>
            list.docs.map((snap) => Player.fromFiresore(snap)).toList());
  }

  // TODO add players number limitation on room creation
  Future<void> createRoom({required Player player}) async {
    final roomRef =
        await _firestore.collection('rooms').add(Room.empty.toFirestore());
    // can get room id directly from documentReference
    _cache.write(key: roomDocIdCacheKey, value: RoomDocId(roomRef.id));

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

    roomRef.collection('players').add(player.toFirestore());

    _cache.write(key: roomDocIdCacheKey, value: RoomDocId(roomRef.id));
  }
}
