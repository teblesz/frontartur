import 'package:data_repository/data_repository.dart';
import 'package:fluttartur/game/cubit/game_cubit.dart';
import 'package:fluttartur/game/view/quest_page.dart';
import 'package:fluttartur/home/home.dart';
import 'package:flutter/foundation.dart';
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
        const Duration(seconds: 1), () => showCharacterInfoDialog(context));
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
          _CurrentStatus(),
          _GameButtons(),
        ],
      ),
    );
  }
}

class _CurrentStatus extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return !kDebugMode
        ? const SizedBox.shrink()
        : BlocBuilder<GameCubit, GameState>(
            buildWhen: (previous, current) => previous.status != current.status,
            builder: (context, state) {
              return Text(state.status.name);
            });
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

Future<void> showCharacterInfoDialog(BuildContext context) {
  return showDialog<void>(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title:
              const Text("Your character is:", style: TextStyle(fontSize: 20)),
          content: _CharacterInfo(),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
              },
              child: const Text("Close info", style: TextStyle(fontSize: 20)),
            ),
          ],
        );
      });
}

class _CharacterInfo extends StatefulWidget {
  @override
  State<_CharacterInfo> createState() => _CharacterInfoState();
}

class _CharacterInfoState extends State<_CharacterInfo> {
  bool _characterHidden = true;
  void showHideCharacter() {
    setState(() {
      _characterHidden = !_characterHidden;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Builder(builder: (context) {
          return _characterHidden
              ? const SizedBox.shrink()
              : Text(
                  context.read<DataRepository>().currentPlayer.character ??
                      "error",
                  style: const TextStyle(
                    fontSize: 25,
                  ),
                );
        }),
        const SizedBox(height: 10),
        ElevatedButton(
          onPressed: () => setState(() {
            _characterHidden = !_characterHidden;
          }),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              _characterHidden ? "Show" : "Hide",
              style: const TextStyle(fontSize: 30),
            ),
          ),
        )
      ],
    );
  }
}

Future<void> _pushQuestResultsDialog(BuildContext context) {
  return showDialog<void>(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext dialogContext) {
        final outcome = context.read<GameCubit>().state.lastQuestOutcome;
        return AlertDialog(
          title:
              const Text("Quest results", style: const TextStyle(fontSize: 20)),
          content: Card(
            color: outcome ? Colors.green.shade900 : Colors.red.shade900,
            child: Center(
              heightFactor: 1,
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Text(
                  outcome ? "Success!" : "Fail",
                  style: const TextStyle(fontSize: 50),
                ),
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
                context.read<GameCubit>().closeQuestResults();
              },
              child: const Text("Close result", style: TextStyle(fontSize: 20)),
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
        final outcome = context.read<GameCubit>().state.lastQuestOutcome;
        return AlertDialog(
          title: const Text("Game results"),
          content: Card(
            color: outcome ? Colors.green.shade900 : Colors.red.shade900,
            child: Center(
              heightFactor: 1,
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Text(
                  outcome
                      ? "Game won by Good team!\nKingdom is saved."
                      : "Game won by Evil team!\nKigdom is lost.",
                  style: const TextStyle(fontSize: 30),
                ),
              ),
            ),
          ),
          // TODO add more info here who is bad who is good
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
                context.read<RoomCubit>().leaveRoom();
              },
              child: const Text("Exit Game", style: TextStyle(fontSize: 20)),
            ),
          ],
        );
      });
}
