import 'package:authentication_repository/authentication_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttartur/app_layer/login/login.dart';
import 'package:fluttartur/lobby_layer/matchup/matchup.dart';

// tutaj zostały stracone 3 godziny na dojście co jest nie tak z Hero.
// nie działał zupełnie bo w app.dart nie było observera
// teraz nie działa na dole stacka, bo https://github.com/flutter/flutter/issues/17627
//    :(
class MatchupHostPage extends StatelessWidget {
  const MatchupHostPage({super.key});

  static Page<void> page() => const MaterialPage<void>(child: LoginPage());

  static Route<void> route() {
    return MaterialPageRoute<void>(builder: (_) => const MatchupHostPage());
  } //TODO remove those routes

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Positioned.fill(
          child: Image.asset(
            "images/startpagebg.jpg",
            alignment: AlignmentDirectional.centerEnd,
            fit: BoxFit.cover,
          ),
        ),
        Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(title: const Text('Matchup')),
          body: const MatchupHostForm(),
        ),
      ],
    );
  }
}
