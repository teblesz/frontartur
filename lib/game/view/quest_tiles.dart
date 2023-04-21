part of 'game_form.dart';

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
