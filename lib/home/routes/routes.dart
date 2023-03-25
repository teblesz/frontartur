import 'package:fluttartur/home/home.dart';
import 'package:fluttartur/lobby/view/view.dart';
import 'package:fluttartur/matchup/matchup.dart';
import 'package:fluttartur/game/game.dart';
import 'package:flutter/widgets.dart';

List<Page<dynamic>> onGenerateRoomViewPages(
  RoomStatus status,
  List<Page<dynamic>> pages,
) {
  switch (status) {
    case RoomStatus.inLobby:
      return [LobbyPage.page()];
    case RoomStatus.inMathup:
      return [MatchupHostPage.page()];
    case RoomStatus.inGame:
      return [GamePage.page()];
  }
}
