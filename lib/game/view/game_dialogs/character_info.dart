import 'package:data_repository/data_repository.dart';
import 'package:fluttartur/game/cubit/game_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
                        : Column(
                            children: [
                              Text(
                                  AppLocalizations.of(widget.gameContext)
                                      .evilCourtiers,
                                  style: const TextStyle(fontSize: 15)),
                              FutureBuilder<List<Player>>(
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
                                            style:
                                                const TextStyle(fontSize: 13)),
                                      ),
                                    ],
                                  );
                                },
                              ),
                            ],
                          ),
                    !(player.specialCharacter == 'good_percival')
                        ? const SizedBox.shrink()
                        : Column(
                            children: [
                              Text(
                                  AppLocalizations.of(widget.gameContext)
                                      .merlinAndMorgana,
                                  style: const TextStyle(fontSize: 15)),
                              FutureBuilder<List<Player>>(
                                future: widget.gameContext
                                    .read<GameCubit>()
                                    .listOfMerlinMorganaPlayers(),
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
                                            style:
                                                const TextStyle(fontSize: 13)),
                                      ),
                                    ],
                                  );
                                },
                              ),
                            ],
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
