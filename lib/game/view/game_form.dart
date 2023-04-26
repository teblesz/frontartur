import 'package:data_repository/data_repository.dart';
import 'package:fluttartur/game/cubit/game_cubit.dart';
import 'package:fluttartur/game/view/quest_page.dart';
import 'package:fluttartur/home/home.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'quest_tiles.dart';
part 'team_wrap.dart';
part 'game_buttons.dart';

class GameForm extends StatelessWidget {
  const GameForm({super.key});

  @override
  Widget build(BuildContext context) {
    // TODO change this to duration.zero (must get fresh player, cache gives old)
    Future.delayed(
        const Duration(seconds: 1), () => _showCharacterInfoDialog(context));
    return BlocListener<GameCubit, GameState>(
      listenWhen: (previous, current) => previous.status != current.status,
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
      _pushQuestResultsDialog(context);
      break;
    case GameStatus.gameResults:
      _pushGameResultsDialog(context);
      break;
  }
}

Future<void> _showCharacterInfoDialog(BuildContext context) {
  return showDialog<void>(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text("Your character is:"),
          content: // TODO add button to unveil,
              Text(
            context.read<DataRepository>().currentPlayer.character ?? "error",
            style: const TextStyle(
              fontSize: 25,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
              },
              child: const Text("Close info"),
            ),
          ],
        );
      });
}

Future<void> _pushQuestResultsDialog(BuildContext context) {
  return showDialog<void>(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text("Quest results"),
          content: context.read<GameCubit>().state.lastQuestOutcome
              ? Text(
                  "Quest Successfull!",
                  style: TextStyle(
                    color: Colors.green.shade900,
                    fontSize: 50,
                  ),
                )
              : Text(
                  "Quest Failed",
                  style: TextStyle(
                    color: Colors.red.shade900,
                    fontSize: 50,
                  ),
                ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
                context.read<GameCubit>().closeQuestResults();
              },
              child: const Text("Close result"),
            ),
          ],
        );
      });
}

//present gaame results, give button to go back to lobby
// show players characters
//_winningTeamIs()
Future<void> _pushGameResultsDialog(BuildContext context) {
  return showDialog<void>(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text("Game results"),
          content: context.read<GameCubit>().state.lastQuestOutcome
              ? Text(
                  "Game won by Good team!\nKingdom is saved.",
                  style: TextStyle(
                    color: Colors.green.shade900,
                    fontSize: 30,
                  ),
                )
              : Text(
                  "Game won by Evil team!\nKigdom is lost.",
                  style: TextStyle(
                    color: Colors.red.shade900,
                    fontSize: 30,
                  ),
                ),
          // TODO add more info here
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
                context.read<RoomCubit>().leaveRoom();
              },
              child: const Text("Exit Game"),
            ),
          ],
        );
      });
}
