import 'package:flutter/material.dart';
import 'package:fluttartur/login/login.dart';
import 'package:fluttartur/matchup/matchup.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttartur/app/app.dart';

// tutaj zostały stracone 3 godziny na dojście co jest nie tak z Hero.
// nie działał zupełnie bo w app.dart nie było observera
// teraz nie działa na dole stacka, bo https://github.com/flutter/flutter/issues/17627
//    :(
class MatchupHostPage extends StatelessWidget {
  const MatchupHostPage({super.key});

  static Page<void> page() =>
      const MaterialPage<void>(child: MatchupHostPage());

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
          appBar: AppBar(
            title: const Text('Matchup'),
            actions: <Widget>[_LeaveRoomButton()],
          ),
          body: const MatchupHostForm(),
        ),
      ],
    );
  }
}

class _LeaveRoomButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
        context.read<AppBloc>().add(const AppLeaveRoomRequested());
      },
      child: const Text("Leave Room"),
    );
  }
}
