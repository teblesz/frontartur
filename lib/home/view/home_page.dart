import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttartur/app/app.dart';
import 'package:fluttartur/home/home.dart';

// TODO internalizacja, komunikacja z firestore, nawigacja
// TODO text theme, anonimowe logowanie, nicki
// TODO pozostałe page do glownego bloca i pododawac na appbarze przyciski zakoncz gre co daja blocowy event
// TODO animacja przesuwania tła przez pierwsze 3 ekrany
// TODO dołączanie do lobby przez kod QR
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  static Page<void> page() => const MaterialPage<void>(child: HomePage());

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Positioned.fill(
          child: Hero(
            tag: 'startpagebg',
            child: Image.asset(
              "images/startpagebg.jpg",
              alignment: AlignmentDirectional.center,
              fit: BoxFit.cover,
            ),
          ),
        ),
        Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            title: const Text('Home'),
            actions: <Widget>[_LogOutButton()],
          ),
          body: const HomeForm(),
        ),
      ],
    );
  }
}

class _LogOutButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
        context.read<AppBloc>().add(const AppLogoutRequested());
      },
      child: const Text("Log out"),
    );
  }
}
