import 'package:fluttartur/app/app.dart';
import 'package:fluttartur/home/home.dart';
import 'package:fluttartur/matchup/matchup.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:formz/formz.dart';
import 'package:provider/provider.dart';
import 'package:data_repository/data_repository.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

// TODO zmiana kolejnosci graczy -> ma byc tak jak przy stole
class MatchupForm extends StatelessWidget {
  const MatchupForm({super.key});

  @override
  Widget build(BuildContext context) {
    Future.delayed(Duration.zero, () => _showNickDialog(context));
    return Column(
      children: [
        _RoomID(),
        _Add5PlayerButton(),
        Expanded(
          child: _PlayerListView(),
        ),
        _HostButtons(),
        const SizedBox(height: 16)
      ],
    );
  }
}

class _RoomID extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return !kDebugMode
        ? const SizedBox.shrink()
        : StreamBuilder<Room>(
            stream: context.read<DataRepository>().streamRoom(),
            builder: (context, snapshot) {
              var data = snapshot.data;
              return data == null
                  ? const Text('<room is empty>')
                  : Text(data.id);
            },
          );
  }
}

class _Add5PlayerButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return !kDebugMode
        ? const SizedBox.shrink()
        : ElevatedButton(
            onPressed: () => context.read<MatchupCubit>().add_Players_debug(6),
            child: const Text('Add players'),
          );
  }
}

class _PlayerListView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Player>>(
      stream: context.read<DataRepository>().streamPlayersList(),
      builder: (context, snapshot) {
        var players = snapshot.data;
        return players == null
            ? const SizedBox.expand()
            : ListView(
                scrollDirection: Axis.vertical,
                children: <Widget>[
                  ...players.map(
                    (player) => _PlayerCard(player: player),
                  ),
                ],
              );
      },
    );
  }
}

class _PlayerCard extends StatelessWidget {
  const _PlayerCard({
    required this.player,
  });

  final Player player;

  @override
  Widget build(BuildContext context) {
    final hostUserId = context.read<DataRepository>().currentRoom.hostUserId;
    final userId = context.select((AppBloc bloc) => bloc.state.user.id);
    return Card(
      child: ListTile(
        title: Text(player.nick),
        trailing: userId != hostUserId
            ? null
            : PopupMenuButton(
                itemBuilder: (context) => [
                  PopupMenuItem(
                    child: Text(AppLocalizations.of(context).remove),
                    onTap: () =>
                        context.read<MatchupCubit>().removePlayer(player),
                    // TODO !!! give the info about removal to the removed user's UI
                  )
                ],
              ),
      ),
    );
  }
}

class _HostButtons extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final hostUserId = context.read<DataRepository>().currentRoom.hostUserId;
    final userId = context.select((AppBloc bloc) => bloc.state.user.id);
    return userId != hostUserId
        ? const SizedBox.shrink()
        : Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _RolesDefButton(),
              _StartGameButton(),
            ],
          );
  }
}

class _StartGameButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FilledButton(
      onPressed: () {
        context.read<MatchupCubit>().initGame();
      },
      child: Text(AppLocalizations.of(context).startGame,
          style: const TextStyle(fontSize: 20)),
    );
  }
}

class _RolesDefButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FilledButton.tonal(
      onPressed: () => Navigator.push(context, CharactersPage.route()),
      child: Text(AppLocalizations.of(context).defineRoles),
    );
  }
}

Future<void> _showNickDialog(BuildContext context) {
  return showDialog<void>(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Text(AppLocalizations.of(context).enterYourNick),
          content: TextField(
            onChanged: (nick) => context.read<MatchupCubit>().nickChanged(nick),
            decoration: InputDecoration(
              labelText: AppLocalizations.of(context).nick,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                //simple validation TODO ! make validation more complex
                if (!context.read<MatchupCubit>().state.status.isValidated) {
                  return;
                }
                final user = context.read<AppBloc>().state.user;
                context.read<MatchupCubit>().writeinPlayerWithUserId(user.id);
                Navigator.of(dialogContext).pop();
                context.read<RoomCubit>().subscribeToGameStarted();
              },
              child: Text(AppLocalizations.of(context).confirm),
            )
          ],
        );
      });
}

// TODO !! add roles config popup