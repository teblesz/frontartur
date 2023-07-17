import 'package:data_repository/data_repository.dart';
import 'package:fluttartur/fluttartur_icons_icons.dart';
import 'package:fluttartur/game/cubit/game_cubit.dart';
import 'package:fluttartur/home/home.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

Future<void> pushGameResultsDialog(BuildContext gameContext) {
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
