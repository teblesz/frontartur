import 'package:fluttartur/game/cubit/game_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

Future<void> pushQuestResultsDialog(BuildContext context) {
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
