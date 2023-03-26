import 'package:fluttartur/app/app.dart';
import 'package:fluttartur/home/home.dart';
import 'package:fluttartur/matchup/matchup.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:data_repository/data_repository.dart';

// TODO zmiana kolejnosci graczy -> ma byc tak jak przy stole
// TODO przewijanie tła na pierwszym planie w typie pojawia sie i zanika?
class MatchupForm extends StatelessWidget {
  const MatchupForm({super.key});

  @override
  Widget build(BuildContext context) {
    Future.delayed(Duration.zero, () => showNickDialog(context));
    return Column(
      children: [
        Expanded(
          child: _PlayerListView(),
        ),
        StreamBuilder<Room>(
          stream: context.read<DataRepository>().streamRoom(),
          builder: (context, snapshot) {
            var data = snapshot.data;
            return data == null
                ? const CircularProgressIndicator() //TODO kopiwanie
                : Text(data.id);
          },
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

class _StartGameButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FilledButton(
      onPressed: () {
        context.read<RoomCubit>().enterGame();
      },
      child: const Text('Rozpocznij grę', style: TextStyle(fontSize: 20)),
    );
  }
}

class _RolesDefButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FilledButton.tonal(
      onPressed: () {},
      child: const Text('Zdefiniuj role'),
    );
  }
}

class _PlayerListView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Player>>(
      //TODO lepiej to?
      stream: context.read<DataRepository>().streamPlayersList(),
      builder: (context, snapshot) {
        var players = snapshot.data;
        return players == null
            ? const CircularProgressIndicator()
            : ListView(
                scrollDirection: Axis.vertical,
                children: <Widget>[
                  ...players.map(
                    (player) => Card(
                      // TODO to separate widget and add rmeoving players
                      child: ListTile(
                        title: Text(player.nick),
                        trailing: const Icon(Icons.more_vert),
                      ),
                    ),
                  ),
                ],
              );
      },
    );
  }
}

Future<void> showNickDialog(BuildContext context) {
  return showDialog<void>(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text("Enter your nick"),
          content: const TextField(
            decoration: InputDecoration(
              hintText: "Nick for this game",
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                final user = context.select((AppBloc bloc) => bloc.state.user);
                context.read<MatchupCubit>().writeinPlayerWithUserId(user.id);
                Navigator.of(dialogContext).pop();
              },
              child: const Text("Confirm"),
            )
          ],
        );
      });
}
