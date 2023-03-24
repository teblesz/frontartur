import 'package:data_repository/data_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'room_state.dart';

class RoomCubit extends Cubit<RoomState> {
  RoomCubit(this._dataRepository) : super(const RoomState());

  final DataRepository _dataRepository;

  void enterGame() {
    print("enterGame");
    emit(state.copyWith(status: RoomStatus.inGame));
  }

  void enterRoom() {
    print("enterRoom");
    emit(state.copyWith(status: RoomStatus.inMathup));
  }

  void leaveRoom() {
    print("leaveRoom");
    _dataRepository.leaveRoom();
    emit(state.copyWith(status: RoomStatus.inLobby));
  }
}
