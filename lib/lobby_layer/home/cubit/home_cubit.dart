import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:form_inputs/form_inputs.dart';
import 'package:formz/formz.dart';
import 'package:data_repository/data_repository.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit(this._dataRepository) : super(const HomeState());

  final DataRepository _dataRepository;

  void roomIdChanged(String value) {
    final roomIdInput = RoomId.dirty(value);
    emit(
      state.copyWith(
        roomIdInput: roomIdInput,
        status: Formz.validate([roomIdInput]),
      ),
    );
  }

  Future<void> joinRoom() async {
    if (!state.status.isValidated) return;
    emit(state.copyWith(status: FormzStatus.submissionInProgress));
    try {
      await _dataRepository.joinRoom(
        roomId: state.roomIdInput.value, //TODO datarep.current etc
        player: const Player(
          id: '33333333',
          userUid: "4444",
          nick: "Testingowy",
        ),
      );
      emit(state.copyWith(status: FormzStatus.submissionSuccess));
    } catch (_) {
      emit(state.copyWith(status: FormzStatus.submissionFailure));
    }
  }

  Future<void> createRoom() async {
    emit(state.copyWith(status: FormzStatus.submissionInProgress));
    try {
      await _dataRepository.createRoom(
        player: const Player(
          id: '000000000',
          userUid: "host_id00000000",
          nick: "Hostujacy",
        ),
      );
      emit(state.copyWith(status: FormzStatus.submissionSuccess));
    } catch (_) {
      emit(state.copyWith(status: FormzStatus.submissionFailure));
    }
  }
}
