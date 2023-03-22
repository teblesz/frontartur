import 'package:fluttartur/lobby_layer/home/home.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttartur/app_layer/app/app.dart';
import 'package:fluttartur/app_layer/login/login.dart';

List<Page<dynamic>> onGenerateAppViewPages(
  AppStatus state,
  List<Page<dynamic>> pages,
) {
  switch (state) {
    case AppStatus.authenticated:
      return [HomePage.page()];
    case AppStatus.unauthenticated:
      return [LoginPage.page()];
  }
}
