import 'package:data_repository/data_repository.dart';
import 'package:fluttartur/fluttartur_icons_icons.dart';
import 'package:fluttartur/game/cubit/game_cubit.dart';
import 'package:fluttartur/game/view/quest_page.dart';
import 'package:fluttartur/home/home.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

part 'quest_tiles.dart';
part 'team_wrap.dart';
part 'game_buttons.dart';

class GameForm extends StatelessWidget {
  const GameForm({super.key});

  @override
  Widget build(BuildContext context) {
    // TODO change this to duration.zero (must get fresh player, cache gives old)
    Future.delayed(
        const Duration(seconds: 1), () => pushCharacterInfoDialog(context));
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

Future<void> pushCharacterInfoDialog(BuildContext context) {
  return showDialog<void>(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Text(AppLocalizations.of(context).yourCharacterIs,
              style: const TextStyle(fontSize: 20)),
          content: _CharacterInfo(),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
              },
              child: Text(AppLocalizations.of(context).closeInfo,
                  style: const TextStyle(fontSize: 20)),
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
                  (context.read<DataRepository>().currentPlayer.character ??
                              "error") ==
                          'good'
                      ? AppLocalizations.of(context).good
                      : AppLocalizations.of(context).evil,
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
              _characterHidden
                  ? AppLocalizations.of(context).show
                  : AppLocalizations.of(context).hide,
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
          title: Text(AppLocalizations.of(context).questResults,
              style: const TextStyle(fontSize: 20)),
          content: Card(
            color: outcome ? Colors.green.shade900 : Colors.red.shade900,
            child: Center(
              heightFactor: 1,
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Text(
                  outcome
                      ? AppLocalizations.of(context).success
                      : AppLocalizations.of(context).fail,
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
              child: Text(AppLocalizations.of(context).closeResult,
                  style: const TextStyle(fontSize: 20)),
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
          title: Text(AppLocalizations.of(context).gameResults),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                  outcome
                      ? FluttarturIcons.crown
                      : FluttarturIcons.crossed_swords,
                  size: 120),
              Card(
                color: outcome ? Colors.green.shade900 : Colors.red.shade900,
                child: Center(
                  heightFactor: 1,
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Text(
                      outcome
                          ? AppLocalizations.of(context).goodTeamWon
                          : AppLocalizations.of(context).evilTeamWon,
                      style: const TextStyle(fontSize: 30),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Text(AppLocalizations.of(context).evilCourtiers,
                  style: const TextStyle(fontSize: 25)),
              FutureBuilder<List<Player>>(
                future: context.read<GameCubit>().listOfEvilPlayers(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  }
                  if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  }
                  List<Player> evilPlayers = snapshot.data ?? List.empty();
                  return Column(
                    children: <Widget>[
                      ...evilPlayers.map(
                        (player) => Text(player.nick,
                            style: const TextStyle(fontSize: 20)),
                      ),
                    ],
                  );
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
                context.read<RoomCubit>().leaveRoom();
              },
              child: Text(AppLocalizations.of(context).exitGame,
                  style: const TextStyle(fontSize: 20)),
            ),
          ],
        );
      });
}
