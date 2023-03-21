import 'package:authentication_repository/authentication_repository.dart';
import 'package:flow_builder/flow_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttartur/lobby_layer/lobby/lobby.dart';
import 'package:fluttartur/theme.dart';
import 'package:data_repository/data_repository.dart';
import 'package:provider/provider.dart';

class Lobby extends StatelessWidget {
  const Lobby({
    super.key,
    required DataRepository dataRepository,
  }) : _dataRepository = dataRepository;

  final DataRepository _dataRepository;

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider.value(
      value: _dataRepository,
      child: BlocProvider(
        create: (_) => LobbyBloc(
          dataRepository: _dataRepository,
        ),
        child: const LobbyView(),
      ),
    );
  }
}

class LobbyView extends StatelessWidget {
  const LobbyView({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: theme,
      home: FlowBuilder<LobbyStatus>(
        state: context.select((LobbyBloc bloc) => bloc.state.status),
        onGeneratePages: onGenerateLobbyViewPages,
        observers: [
          HeroController()
        ], // TODO not necessary now set it up in game layer
      ),
    );
  }
}
