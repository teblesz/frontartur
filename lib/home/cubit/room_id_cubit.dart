import 'package:bloc/bloc.dart';
import 'package:data_repository/data_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:form_inputs/form_inputs.dart';
import 'package:formz/formz.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

part 'room_id_state.dart';

class RoomIdCubit extends Cubit<RoomIdState> {
  RoomIdCubit(this._firestore) : super(const RoomIdState());

  final FirebaseFirestore _firestore;

  void roomIdChanged(String value) {
    final roomId = RoomId.dirty(value);
    emit(
      state.copyWith(
        roomId: roomId,
        status: Formz.validate([roomId]),
      ),
    );
  }

  Future<void> joinRoomWithRoomId() async {
    if (!state.status.isValidated) return;
    emit(state.copyWith(status: FormzStatus.submissionInProgress));
    try {
      print(state.roomId.value);
      final snap =
          await _firestore.collection('rooms').doc(state.roomId.value).get();
      Room room = Room.fromFirestore(snap);
      print(room.id);
      print(room.characters);
      emit(state.copyWith(status: FormzStatus.submissionSuccess));
    } catch (_) {
      emit(state.copyWith(status: FormzStatus.submissionFailure));
    }
  }
}
