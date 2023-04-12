part of 'data_repository.dart';

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

class StreamingRoomFailure implements Exception {
  const StreamingRoomFailure([this.message = 'An unknown exception occurred.']);

  final String message;
}

class StreamingPlayerFailure implements Exception {
  const StreamingPlayerFailure(
      [this.message = 'An unknown exception occurred.']);

  final String message;
}

class JoiningStartedGameFailure implements Exception {
  const JoiningStartedGameFailure(
      [this.message = 'trying to join room which has started game']);

  final String message;
}

class CharacterAndPlayersCountsDoNotMatchFailure implements Exception {
  const CharacterAndPlayersCountsDoNotMatchFailure(
      [this.message = 'lengths of list do not match']);

  final String message;
}
