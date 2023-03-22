import 'package:authentication_repository/authentication_repository.dart';
import 'package:flow_builder/flow_builder.dart';
import 'package:fluttartur/lobby_layer/lobby/bloc/lobby_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttartur/app_layer/app/app.dart';
import 'package:fluttartur/theme.dart';
import 'package:data_repository/data_repository.dart';

class App extends StatelessWidget {
  const App({
    super.key,
    required AuthenticationRepository authenticationRepository,
    required DataRepository dataRepository,
  })  : _authenticationRepository = authenticationRepository,
        _dataRepository = dataRepository;

  final AuthenticationRepository _authenticationRepository;
  final DataRepository _dataRepository;

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider.value(value: _authenticationRepository),
        RepositoryProvider.value(value: _dataRepository),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
              create: (_) =>
                  AppBloc(authenticationRepository: _authenticationRepository)),
          BlocProvider(
              create: (_) => LobbyBloc(dataRepository: _dataRepository)),
        ],
        child: const AppView(),
      ),
    );
  }
}

class AppView extends StatelessWidget {
  const AppView({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: theme,
      home: FlowBuilder<AppStatus>(
        state: context.select((AppBloc bloc) => bloc.state.status),
        onGeneratePages: onGenerateAppViewPages,
        observers: [HeroController()], // TODO not necessary now
      ),
    );
  }
}
