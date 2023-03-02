import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttartur/data/room.dart';

class RoomsDataSource {
  const RoomsDataSource({required FirebaseFirestore firestore})
      : _firestore = firestore;

  final FirebaseFirestore _firestore;

  Future<List<Room>> getRooms() async {
    final rooms = await _firestore.collection('rooms').get();
    return rooms.docs.map(Room.fromSnapshot).toList();
  }

  Future<void> sendRoom(Room room) =>
      _firestore.collection('rooms').add(room.toMap());

  Stream<List<Room>> get roomStream => _firestore
      .collection('rooms')
      .snapshots()
      .map((m) => m.docs.map(Room.fromSnapshot).toList());
}
