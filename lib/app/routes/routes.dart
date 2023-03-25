import 'package:fluttartur/app/app.dart';
import 'package:fluttartur/home/home.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttartur/login/login.dart';

List<Page<dynamic>> onGenerateAppViewPages(
  AppStatus status,
  List<Page<dynamic>> pages,
) {
  switch (status) {
    case AppStatus.authenticated:
      return [Home.page()];
    case AppStatus.unauthenticated:
      return [LoginPage.page()];
  }
}
