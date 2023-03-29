import 'package:fluttartur/app/app.dart';
import 'package:fluttartur/home/home.dart';
import 'package:fluttartur/matchup/matchup.dart';
import 'package:flutter/material.dart';
import 'package:formz/formz.dart';
import 'package:provider/provider.dart';
import 'package:data_repository/data_repository.dart';

// TODO zmiana kolejnosci graczy -> ma byc tak jak przy stole
class MatchupForm extends StatelessWidget {
  const MatchupForm({super.key});

  @override
  Widget build(BuildContext context) {
    Future.delayed(Duration.zero, () => _showNickDialog(context));
    return Column(
      children: [
        StreamBuilder<Room>(
          stream: context.read<DataRepository>().streamRoom(),
          builder: (context, snapshot) {
            var data = snapshot.data;
            return data == null ? const Text('Room is empty') : Text(data.id);
          },
        ),
        Expanded(
          child: _PlayerListView(),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _RolesDefButton(),
            _StartGameButton(),
          ],
        ),
        const SizedBox(height: 16)
      ],
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
    super.key,
    required this.player,
  });

  final Player player;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(player.nick),
        trailing: PopupMenuButton(
          itemBuilder: (context) => [
            PopupMenuItem(
              child: const Text("Remove"),
              onTap: () => context.read<MatchupCubit>().removePlayer(player),
              // TODO !! farward the info about removal to the removed user's UI
            )
          ],
        ),
      ),
    );
  }
}

class _StartGameButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FilledButton(
      onPressed: () {
        context.read<RoomCubit>().enterGame();
        // TODO available only if host
      },
      child: const Text('Rozpocznij grę', style: TextStyle(fontSize: 20)),
    );
  }
}

class _RolesDefButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FilledButton.tonal(
      onPressed: () {}, // TODO role def !!!
      child: const Text('Zdefiniuj role'),
    );
  }
}

Future<void> _showNickDialog(BuildContext context) {
  return showDialog<void>(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text("Enter your nick for this play"),
          content: TextField(
            onChanged: (nick) => context.read<MatchupCubit>().nickChanged(nick),
            decoration: const InputDecoration(
              labelText: 'Nick',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                //simple validation TODO make validation more complex
                if (!context.read<MatchupCubit>().state.status.isValidated)
                  return;
                final user = context.read<AppBloc>().state.user;
                context.read<MatchupCubit>().writeinPlayerWithUserId(user.id);
                Navigator.of(dialogContext).pop();
              },
              child: const Text("Confirm"),
            )
          ],
        );
      });
}
