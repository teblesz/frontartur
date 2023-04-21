import 'package:data_repository/data_repository.dart';
import 'package:fluttartur/game/cubit/game_cubit.dart';
import 'package:flutter/material.dart';
import 'package:fluttartur/pages_old/view/mission_page.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'quest_tiles.dart';
part 'team_wrap.dart';
part 'game_buttons.dart';

class GameForm extends StatelessWidget {
  const GameForm({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<GameCubit, GameState>(
      listener: (context, state) => listenGameCubit(context, state),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          _QuestTiles(),
          Expanded(
            child: _TeamWrap(),
          ),
          _GameButtons(),
          BlocBuilder<GameCubit, GameState>(
              // TODO remove this
              buildWhen: (previous, current) =>
                  previous.status != current.status,
              builder: (context, state) {
                return Text(state.status.name);
              }),
        ],
      ),
    );
  }
}

void listenGameCubit(context, state) {
  switch (state.status) {
    case GameStatus.squadChoice:
      break;
    case GameStatus.squadVoting:
      break;
    case GameStatus.questVoting:
      break;
    case GameStatus.questResults:
      break;
    case GameStatus.gameResults:
      break;
  }
}
