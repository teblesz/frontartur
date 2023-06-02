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

Future<void> pushCharacterInfoDialog(BuildContext gameContext) {
  return showDialog<void>(
      barrierDismissible: false,
      context: gameContext,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Text(AppLocalizations.of(gameContext).yourCharacterIs,
              style: const TextStyle(fontSize: 20)),
          content: _CharacterInfo(gameContext: gameContext),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
              },
              child: Text(AppLocalizations.of(gameContext).closeInfo,
                  style: const TextStyle(fontSize: 20)),
            ),
          ],
        );
      });
}

class _CharacterInfo extends StatefulWidget {
  const _CharacterInfo({required this.gameContext});
  final BuildContext gameContext;

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
    final player = context.read<DataRepository>().currentPlayer;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Builder(builder: (context) {
          return _characterHidden
              ? const SizedBox.shrink()
              : Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          (player.character ?? "error") == 'good'
                              ? AppLocalizations.of(context).good
                              : AppLocalizations.of(context).evil,
                          style: const TextStyle(fontSize: 30),
                        ),
                        player.specialCharacter == null
                            ? const SizedBox.shrink()
                            : const Text(" - ",
                                style: const TextStyle(fontSize: 30)),
                        player.specialCharacter == null
                            ? const SizedBox.shrink()
                            : Text(
                                specialCharacterToText(
                                    player.specialCharacter!, context),
                                style: const TextStyle(fontSize: 30),
                              ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    !(player.character == "evil" ||
                            player.specialCharacter == 'good_merlin')
                        ? const SizedBox.shrink()
                        : Text(
                            AppLocalizations.of(widget.gameContext)
                                .evilCourtiers,
                            style: const TextStyle(fontSize: 15)),
                    !(player.character == "evil" ||
                            player.specialCharacter == 'good_merlin')
                        ? const SizedBox.shrink()
                        : FutureBuilder<List<Player>>(
                            future: widget.gameContext
                                .read<GameCubit>()
                                .listOfEvilPlayers(),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return const CircularProgressIndicator();
                              }
                              if (snapshot.hasError) {
                                return Text('Error: ${snapshot.error}');
                              }
                              List<Player> evilPlayers =
                                  snapshot.data ?? List.empty();
                              return Wrap(
                                children: <Widget>[
                                  ...evilPlayers.map(
                                    (player) => Text("${player.nick}, ",
                                        style: const TextStyle(fontSize: 13)),
                                  ),
                                ],
                              );
                            },
                          ),
                  ],
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

// TODO replace this with value class for character and enum
String specialCharacterToText(String specialCharacter, BuildContext context) {
  switch (specialCharacter) {
    case 'good_merlin':
      return AppLocalizations.of(context).merlin;
    case 'evil_assassin':
      return AppLocalizations.of(context).assassin;
    case 'good_percival':
      return AppLocalizations.of(context).percival;
    case 'evil_morgana':
      return AppLocalizations.of(context).morgana;
    default:
      return 'error';
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

Future<void> _pushGameResultsDialog(BuildContext gameContext) {
  return showDialog<void>(
      barrierDismissible: false,
      context: gameContext,
      builder: (BuildContext dialogContext) {
        final outcome = gameContext.read<GameCubit>().state.winningTeam;
        final assassinPresent = gameContext.read<GameCubit>().assassinPresent();
        return AlertDialog(
          //title: Text(AppLocalizations.of(gameContext).gameResults),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                  outcome
                      ? FluttarturIcons.crown
                      : FluttarturIcons.crossed_swords,
                  size: 80),
              Card(
                color: outcome ? Colors.green.shade900 : Colors.red.shade900,
                child: Center(
                  heightFactor: 1,
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Text(
                      outcome
                          ? AppLocalizations.of(gameContext).goodTeamWon
                          : AppLocalizations.of(gameContext).evilTeamWon,
                      style: const TextStyle(fontSize: 30),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Text(AppLocalizations.of(gameContext).evilCourtiers,
                  style: const TextStyle(fontSize: 25)),
              FutureBuilder<List<Player>>(
                future: gameContext.read<GameCubit>().listOfEvilPlayers(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  }
                  if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  }
                  List<Player> evilPlayers = snapshot.data ?? List.empty();
                  return Wrap(
                    children: <Widget>[
                      ...evilPlayers.map(
                        (player) => Text("${player.nick}, ",
                            style: const TextStyle(fontSize: 18)),
                      ),
                    ],
                  );
                },
              ),
              !(assassinPresent && outcome)
                  ? const SizedBox.shrink()
                  : _AssassinBox(gameContext: gameContext),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
                gameContext.read<RoomCubit>().leaveRoom();
              },
              child: Text(AppLocalizations.of(gameContext).exitGame,
                  style: const TextStyle(fontSize: 20)),
            ),
          ],
        );
      });
}

class _AssassinBox extends StatelessWidget {
  const _AssassinBox({
    super.key,
    required this.gameContext,
  });

  final BuildContext gameContext;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<bool?>(
        stream: gameContext.read<GameCubit>().streamMerlinKilled(),
        builder: (context, snapshot) {
          final merlinKilled = snapshot.data;
          return Column(
            children: [
              const SizedBox(height: 10),
              merlinKilled == null
                  ? _KillingMerlinBox(gameContext: gameContext)
                  : _MerlinKilledResult(merlinKilled: merlinKilled),
            ],
          );
        });
  }
}

class _KillingMerlinBox extends StatelessWidget {
  const _KillingMerlinBox({
    super.key,
    required this.gameContext,
  });

  final BuildContext gameContext;

  @override
  Widget build(BuildContext context) {
    final isAssassin = gameContext.read<GameCubit>().isAssassin();
    return Card(
      color: const Color.fromARGB(118, 0, 0, 0),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: !isAssassin
            ? Column(
                children: [
                  Text(AppLocalizations.of(context).assassinChooses,
                      style: const TextStyle(fontSize: 20)),
                  const Padding(
                    padding: EdgeInsets.all(15.0),
                    child: CircularProgressIndicator(),
                  ),
                ],
              )
            : Column(
                children: [
                  Text(AppLocalizations.of(context).killMerlin,
                      style: const TextStyle(fontSize: 20)),
                  const SizedBox(height: 10),
                  FutureBuilder<List<Player>>(
                    future: gameContext.read<GameCubit>().listOfGoodPlayers(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const CircularProgressIndicator();
                      }
                      if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}');
                      }
                      final goodPlayers = snapshot.data ?? <Player>[];
                      return Wrap(
                        children: [
                          ...goodPlayers.map(
                            (player) => _KillingPlayerButton(
                              player: player,
                              gameContext: gameContext,
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ],
              ),
      ),
    );
  }
}

class _KillingPlayerButton extends StatelessWidget {
  const _KillingPlayerButton({
    super.key,
    required this.player,
    required this.gameContext,
  });

  final Player player;
  final BuildContext gameContext;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(2.0),
      child: FilledButton.tonal(
        onPressed: () =>
            gameContext.read<GameCubit>().killPlayer(player: player),
        child: Text(player.nick),
      ),
    );
  }
}

class _MerlinKilledResult extends StatelessWidget {
  const _MerlinKilledResult({required this.merlinKilled});

  final bool merlinKilled;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: !merlinKilled ? Colors.green.shade900 : Colors.red.shade900,
      child: Center(
        heightFactor: 1,
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Text(
            !merlinKilled
                ? AppLocalizations.of(context).merlinSafe
                : AppLocalizations.of(context).merlinDead,
            style: const TextStyle(fontSize: 30),
          ),
        ),
      ),
    );
  }
}
