import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:data_repository/src/models/models.dart';

// TODO unique room name (kahoot-like) https://stackoverflow.com/questions/47543251/firestore-unique-index-or-unique-constraint

class RoomsDataSource {
  const RoomsDataSource({required FirebaseFirestore firestore})
      : _firestore = firestore;

  final FirebaseFirestore _firestore;

  // Future<String> sendRoom(Room room) async {
  //   String roomId = "";
  //   _firestore.collection('rooms').add(room.toFirestore()).then(
  //     (documentSnapshot) {
  //       roomId = documentSnapshot.id;
  //     },
  //   );
  //   return roomId;
  // }

  Future<Room> getRoom(String id) async {
    var snap = await _firestore.collection('rooms').doc(id).get();

    return Room.fromFirestore(snap);
  }

  //Future<Room> createRoom(List<String> characters)
}
