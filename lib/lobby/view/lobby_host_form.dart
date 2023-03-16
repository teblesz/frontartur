import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';
import 'package:fluttartur/pages_old/view/court_page.dart';

// TODO zmiana kolejnosci graczy -> ma byc tak jak przy stole
// TODO przewijanie tła na pierwszym planie w typie pojawia sie i zanika?
class LobbyHostForm extends StatelessWidget {
  const LobbyHostForm({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
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
      onPressed: () {},
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
    return ListView(
      scrollDirection: Axis.vertical,
      children: const <Widget>[
        Card(
          child: ListTile(
            title: Text('player1'),
            trailing: Icon(Icons.more_vert),
          ),
        ),
        Card(
          child: ListTile(
            title: Text('player2'),
            trailing: Icon(Icons.more_vert),
          ),
        ),
        Card(
          child: ListTile(
            title: Text('player3'),
            trailing: Icon(Icons.more_vert),
          ),
        ),
      ],
    );
  }
}
