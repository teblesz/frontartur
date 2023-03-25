import 'package:fluttartur/home/home.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fluttartur/pages_old/view/court_page.dart';
import 'package:data_repository/data_repository.dart';

// TODO zmiana kolejnosci graczy -> ma byc tak jak przy stole
// TODO przewijanie tła na pierwszym planie w typie pojawia sie i zanika?
class MatchupHostForm extends StatelessWidget {
  const MatchupHostForm({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        StreamBuilder<Room>(
          //TODO lepiej to?
          stream: context.read<DataRepository>().room,
          builder: (context, snapshot) {
            var data = snapshot.data;
            return data == null
                ? const CircularProgressIndicator()
                : Text(data.id);
          },
        ),
        Expanded(
          child: _PlayerListView(),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _RolesDefButton(),
              _StartGameButton(),
            ],
          ),
        ),
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