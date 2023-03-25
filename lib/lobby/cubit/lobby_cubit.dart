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
    final roomIdInput = RoomId.dirty(value);
    emit(
      state.copyWith(
        roomIdInput: roomIdInput,
        statusOfJoin: Formz.validate([roomIdInput]),
      ),
    );
  }

  Future<void> joinRoom() async {
    if (!state.statusOfJoin.isValidated) return;
    emit(state.copyWith(statusOfJoin: FormzStatus.submissionInProgress));
    try {
      await Future.delayed(Duration(seconds: 1)); //TODO remove
      await _dataRepository.joinRoom(
        roomId: state.roomIdInput.value,
        player: const Player(
          id: '33333333',
          userUid: "4444",
          nick: "Testingowy",
        ),
      );
      emit(state.copyWith(statusOfJoin: FormzStatus.submissionSuccess));
    } catch (_) {
      emit(state.copyWith(statusOfJoin: FormzStatus.submissionFailure));
    }
  }

  Future<void> createRoom() async {
    emit(state.copyWith(statusOfCreate: FormzStatus.submissionInProgress));
    try {
      await Future.delayed(Duration(seconds: 10)); //TODO remove
      await _dataRepository.createRoom(
        player: const Player(
          id: '000000000',
          userUid: "host_id00000000",
          nick: "Hostujacy",
        ),
      );
      emit(state.copyWith(statusOfCreate: FormzStatus.submissionSuccess));
    } catch (_) {
      emit(state.copyWith(statusOfCreate: FormzStatus.submissionFailure));
    }
  }
}
