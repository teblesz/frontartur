import 'package:fluttartur/app/app.dart';
import 'package:fluttartur/app/lobby_bloc/lobby_bloc.dart';
import 'package:fluttartur/home/home.dart';
import 'package:fluttartur/matchup/matchup.dart';
import 'package:fluttartur/pages_old/view/court_page.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttartur/login/login.dart';

List<Page<dynamic>> onGenerateAppViewPages(
  AppStatus status,
  List<Page<dynamic>> pages,
) {
  switch (status) {
    case AppStatus.playingGame:
      return [CourtPage.page()];
    case AppStatus.inMatchup:
      return [MatchupHostPage.page()];
    case AppStatus.authenticated:
      return [HomePage.page()];
    case AppStatus.unauthenticated:
      return [LoginPage.page()];
  }
}
