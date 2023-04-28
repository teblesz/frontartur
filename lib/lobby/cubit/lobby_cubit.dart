import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:form_inputs/form_inputs.dart';
import 'package:formz/formz.dart';
import 'package:data_repository/data_repository.dart';

part 'lobby_state.dart';

class LobbyCubit extends Cubit<LobbyState> {
  LobbyCubit(this._dataRepository) : super(const LobbyState());

  final DataRepository _dataRepository;

  void roomIdChanged(String value) {
    final roomId = RoomId.dirty(value);
    emit(
      state.copyWith(
        roomId: roomId,
        statusOfJoin: Formz.validate([roomId]),
      ),
    );
  }

  Future<void> joinRoom() async {
    if (!state.statusOfJoin.isValidated) return;
    emit(state.copyWith(statusOfJoin: FormzStatus.submissionInProgress));
    try {
      await _dataRepository.joinRoom(roomId: state.roomId.value);
      emit(state.copyWith(statusOfJoin: FormzStatus.submissionSuccess));
    }
    // TODO better handling of possible errors !!!
    on JoiningStartedGameFailure catch (e) {
      print(e.message);
      rethrow;
      //emit(state.copyWith(statusOfJoin: FormzStatus.submissionFailure));
    } catch (_) {
      emit(state.copyWith(statusOfJoin: FormzStatus.submissionFailure));
    }
  }

  Future<void> createRoom({required String userId}) async {
    emit(state.copyWith(statusOfCreate: FormzStatus.submissionInProgress));
    try {
      await _dataRepository.createRoom(userId: userId);
      emit(state.copyWith(statusOfCreate: FormzStatus.submissionSuccess));
    } catch (_) {
      emit(state.copyWith(statusOfCreate: FormzStatus.submissionFailure));
    }
  }
}
