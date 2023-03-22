import 'package:flutter/widgets.dart';
import 'package:fluttartur/app_layer/app/app.dart';
import 'package:fluttartur/lobby_layer/lobby/lobby.dart';
import 'package:fluttartur/app_layer/login/login.dart';

List<Page<dynamic>> onGenerateAppViewPages(
  AppStatus state,
  List<Page<dynamic>> pages,
) {
  switch (state) {
    case AppStatus.authenticated:
      return [LobbyView.page()];
    case AppStatus.unauthenticated:
      return [LoginPage.page()];
  }
}
