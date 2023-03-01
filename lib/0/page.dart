import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:fluttartur/data/room.dart';
import 'package:fluttartur/data/shoutbox_data_source.dart';
import 'package:fluttartur/0/shoutbox.dart';

class ShoutboxPage0 extends StatelessWidget {
  const ShoutboxPage0({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Provider(
      create: (_) => ShoutboxDataSource(
        firestore: FirebaseFirestore.instance,
      ),
      child: ChangeNotifierProvider(
        create: (context) => Shoutbox(
          shoutboxDataSource: context.read(),
        ),
        child: MaterialApp(
          title: 'Shoutbox',
          theme: ThemeData(
            primarySwatch: Colors.blue,
          ),
          home: Scaffold(
            appBar: AppBar(
              title: const Text('Shoutbox'),
            ),
            body: const _List(),
          ),
        ),
      ),
    );
  }
}

class _List extends StatelessWidget {
  const _List({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final rooms = context.watch<Shoutbox>().rooms;

    return RefreshIndicator(
      onRefresh: context.watch<Shoutbox>().refresh,
      child: ListView.builder(
        itemCount: rooms.length,
        itemBuilder: (_, i) => _Room(
          room: rooms[i],
        ),
      ),
    );
  }
}

class _Room extends StatelessWidget {
  const _Room({
    Key? key,
    required this.room,
  }) : super(key: key);

  final Room room;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      margin: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: Colors.blueGrey.shade100,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 4,
          ),
        ],
      ),
      child: Text('[${room.id}]: ${room.name}'),
    );
  }
}
