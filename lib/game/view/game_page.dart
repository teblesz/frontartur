import 'package:fluttartur/game/view/game_form.dart';
import 'package:flutter/material.dart';
import 'package:fluttartur/pages_old/view/mission_page.dart';

class GamePage extends StatelessWidget {
  const GamePage({super.key});

  static Page<void> page() => const MaterialPage<void>(child: GamePage());

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Positioned.fill(
          child: Image.asset(
            "images/startpagebg.jpg",
            alignment: AlignmentDirectional.center,
            fit: BoxFit.cover,
          ),
        ),
        Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            title: const Text('Game'),
            //actions: <Widget>[_LogOutButton()], //TODO 3 dots menu with this
          ),
          // TODO cubit here
          body: GameForm(),
        ),
      ],
    );
  }
}
