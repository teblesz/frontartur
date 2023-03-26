import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:form_inputs/form_inputs.dart';
import 'package:formz/formz.dart';
import 'package:data_repository/data_repository.dart';

part 'lobby_state.dart';

// TODO maybe change into full bloc, so it reacts on room changes
// then problem with room stream in dataRepository needs to be resolved

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
      await Future.delayed(Duration(seconds: 1)); //TODO remove
      await _dataRepository.joinRoom(roomId: state.roomId.value);
      emit(state.copyWith(statusOfJoin: FormzStatus.submissionSuccess));
    } catch (_) {
      emit(state.copyWith(statusOfJoin: FormzStatus.submissionFailure));
    }
  }

  Future<void> createRoom() async {
    emit(state.copyWith(statusOfCreate: FormzStatus.submissionInProgress));
    try {
      await Future.delayed(Duration(seconds: 1)); //TODO remove
      await _dataRepository.createRoom();
      emit(state.copyWith(statusOfCreate: FormzStatus.submissionSuccess));
    } catch (_) {
      emit(state.copyWith(statusOfCreate: FormzStatus.submissionFailure));
    }
  }
}
