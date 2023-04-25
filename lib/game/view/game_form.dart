import 'package:data_repository/data_repository.dart';
import 'package:fluttartur/game/cubit/game_cubit.dart';
import 'package:fluttartur/game/view/quest_page.dart';
import 'package:flutter/material.dart';
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
          BlocBuilder<GameCubit, GameState>(
              // TODO !!! remove this
              buildWhen: (previous, current) =>
                  previous.status != current.status,
              builder: (context, state) {
                return Text(state.status.name);
              }),
          _GameButtons(),
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
      // popup with closeQuestResults()
      break;
    case GameStatus.gameResults:
      //present gaame results, give button to go back to lobby
      // show players characters
      //_winningTeamIs()
      break;
  }
}

Future<void> _pushSquadVotingDialog(BuildContext context) {
  return showDialog<void>(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text("Vote this squad"),
          content: null,
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
              },
              child: const Text("Approve"),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
              },
              child: const Text("Reject"),
            ),
          ],
        );
      });
}
