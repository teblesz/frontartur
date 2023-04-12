import 'package:data_repository/data_repository.dart';
import 'package:data_repository/models/member.dart';
import 'package:fluttartur/game/cubit/game_cubit.dart';
import 'package:flutter/material.dart';
import 'package:fluttartur/pages_old/view/mission_page.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class GameForm extends StatelessWidget {
  const GameForm({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        _QuestTiles(),
        Expanded(
          child: _TeamWrap(),
        ),
        _TeamChoiceButtons(),
      ],
    );
  }
}

class _QuestTiles extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: const Color.fromARGB(172, 63, 63, 63),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: const <Widget>[
            _QuestTile(questNumber: 1),
            _QuestTile(questNumber: 2),
            _QuestTile(questNumber: 3),
            _QuestTile(questNumber: 4),
            _QuestTile(questNumber: 5),
          ],
        ),
      ),
    );
  }
}

class _QuestTile extends StatelessWidget {
  const _QuestTile({required this.questNumber});

  final int questNumber;

  Color questTileColor(QuestStatus? result) {
    switch (result) {
      case QuestStatus.success:
        return Colors.green.shade700;
      case QuestStatus.defeat:
        return Colors.red.shade700;
      case QuestStatus.ongoing:
        return const Color.fromARGB(255, 64, 134, 169);
      case QuestStatus.upcoming:
        return const Color.fromARGB(255, 13, 66, 110);
      case null:
        return const Color.fromARGB(255, 35, 35, 35);
    }
  }

  IconData questTileIconData(QuestStatus? result) {
    switch (result) {
      case QuestStatus.success:
        return Icons.done;
      case QuestStatus.defeat:
        return Icons.close;
      case QuestStatus.ongoing:
      case QuestStatus.upcoming:
        return Icons.location_on;
      case null:
        return Icons.error_outline;
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuestStatus>(
      stream:
          context.read<GameCubit>().streamQuestResult(questNumber: questNumber),
      builder: (context, snapshot) {
        var result = snapshot.data;
        return CircleAvatar(
          radius: 30,
          backgroundColor: questTileColor(result),
          child: IconButton(
            iconSize: 40,
            color: Colors.white,
            icon: Icon(questTileIconData(result)),
            onPressed: () {
              // TODO quest info
            },
          ),
        );
      },
    );
  }
}

class _TeamWrap extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Center(
        child: Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("Court:", style: TextStyle(fontSize: 30)),
                Expanded(
                  child: SingleChildScrollView(
                    child: _PlayerListView(),
                  ),
                ),
              ],
            ),
            const Spacer(),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                const Text("Squad:", style: TextStyle(fontSize: 30)),
                Expanded(
                  child: SingleChildScrollView(
                    child: _SquadListView(),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _PlayerListView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Player>>(
      stream: context.read<GameCubit>().streamPlayersList(),
      builder: (context, snapshot) {
        var players = snapshot.data;
        return players == null
            ? const Text("<court is empty>")
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
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
  // TODO ! make it a hero widget between two lists
  const _PlayerCard({
    required this.player,
  });

  final Player player;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.read<DataRepository>().currentPlayer.isLeader
          ? context.read<GameCubit>().addMember(player: player)
          : null,
      child: Card(
        margin: const EdgeInsets.all(1.0),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              player.isLeader
                  ? const Icon(Icons.star)
                  : const SizedBox.shrink(),
              Text(
                player.nick,
                style: TextStyle(
                  fontSize: 23,
                  fontWeight: player.id ==
                          context.read<DataRepository>().currentPlayer.id
                      ? FontWeight.bold
                      : null,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SquadListView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Member>>(
      stream: context.read<GameCubit>().streamMembersList(),
      builder: (context, snapshot) {
        var members = snapshot.data;
        return members == null
            ? const Text('<squad is empty>')
            : Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  ...members.map(
                    (member) => _MemberCard(member: member),
                  ),
                ],
              );
      },
    );
  }
}

class _MemberCard extends StatelessWidget {
  // TODO ! make it a hero widget between two lists
  const _MemberCard({
    required this.member,
  });

  final Member member;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.read<DataRepository>().currentPlayer.isLeader
          ? context.read<GameCubit>().removeMember(member: member)
          : null,
      child: Card(
        margin: const EdgeInsets.all(1.0),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            member.nick,
            style: TextStyle(
              fontSize: 23,
              fontWeight: member.playerId ==
                      context.read<DataRepository>().currentPlayer.id
                  ? FontWeight.bold
                  : null,
            ),
          ),
        ),
      ),
    );
  }
}

class _TeamChoiceButtons extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // streamBuilder is here to start streaming player for bussiness logic
    return StreamBuilder<Player>(
        stream: context.read<DataRepository>().streamPlayer(),
        builder: (context, snapshot) {
          return context.read<DataRepository>().currentPlayer.isLeader
              ? _SubmitTeamButton()
              : _VotingButtons();
        });
  }
}

class _SubmitTeamButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FilledButton(
      onPressed: () {
        // TODO do firestore messaging or have state in room/squad in db
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const MissionPage()),
        );
      },
      child: const Text(
        "Submit Team",
        style: TextStyle(
          fontSize: 23,
        ),
      ),
    );
  }
}

class _VotingButtons extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: const Color.fromARGB(172, 63, 63, 63),
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            CircleAvatar(
              radius: 40,
              backgroundColor: Colors.red,
              child: IconButton(
                iconSize: 60,
                color: Colors.white,
                icon: const Icon(Icons.close),
                onPressed: () {},
              ),
            ),
            CircleAvatar(
              radius: 40,
              backgroundColor: Colors.green,
              child: IconButton(
                iconSize: 60,
                color: Colors.white,
                icon: const Icon(Icons.check),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const MissionPage()),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
