import 'package:flow_builder/flow_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttartur/lobby_layer/lobby/lobby.dart';
import 'package:fluttartur/theme.dart';
import 'package:provider/provider.dart';

class LobbyView extends StatelessWidget {
  const LobbyView({super.key});

  static Page<void> page() => const MaterialPage<void>(child: LobbyView());

  @override
  Widget build(BuildContext context) {
    return FlowBuilder<LobbyStatus>(
      state: context.select((LobbyBloc bloc) => bloc.state.status),
      onGeneratePages: onGenerateLobbyViewPages,
      observers: [HeroController()],
    );
  }
}
