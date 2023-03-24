import 'package:fluttartur/lobby/cubit/lobby_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttartur/app/app.dart';
import 'package:fluttartur/lobby/lobby.dart';
import 'package:data_repository/data_repository.dart';

// TODO internalizacja
// TODO anonimowe logowanie, nicki
// TODO animacje
// TODO dołączanie do lobby przez kod QR

// TODO !!! nicki

class LobbyPage extends StatelessWidget {
  const LobbyPage({super.key});

  static Page<void> page() => const MaterialPage<void>(child: LobbyPage());

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
            title: const Text('Lobby'),
            actions: <Widget>[_LogOutButton()],
          ),
          body: BlocProvider(
            create: (_) => LobbyCubit(context.read<DataRepository>()),
            child: const LobbyForm(),
          ),
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
