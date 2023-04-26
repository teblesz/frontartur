part of 'game_form.dart';

class _QuestTiles extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: const Color.fromARGB(172, 63, 63, 63),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: BlocBuilder<GameCubit, GameState>(
            buildWhen: (previous, current) =>
                previous.questStatuses != current.questStatuses,
            builder: (context, state) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  _QuestTile(questNumber: 1, gameState: state),
                  _QuestTile(questNumber: 2, gameState: state),
                  _QuestTile(questNumber: 3, gameState: state),
                  _QuestTile(questNumber: 4, gameState: state),
                  _QuestTile(questNumber: 5, gameState: state),
                ],
              );
            }),
      ),
    );
  }
}

class _QuestTile extends StatelessWidget {
  const _QuestTile({
    required this.questNumber,
    required this.gameState,
  });

  final int questNumber;
  final GameState gameState;

  Color _questTileColor(QuestStatus? questStatus) {
    switch (questStatus) {
      case QuestStatus.success:
        return Colors.green.shade700;
      case QuestStatus.fail:
        return Colors.red.shade700;
      case QuestStatus.ongoing:
        return const Color.fromARGB(255, 64, 134, 169);
      case QuestStatus.upcoming:
        return const Color.fromARGB(255, 13, 66, 110);
      case QuestStatus.error:
      case null:
        return const Color.fromARGB(255, 35, 35, 35);
    }
  }

  IconData _questTileIconData(QuestStatus? questStatus) {
    switch (questStatus) {
      case QuestStatus.success:
        return Icons.done;
      case QuestStatus.fail:
        return Icons.close;
      case QuestStatus.ongoing:
      case QuestStatus.upcoming:
        return Icons.location_on;
      case QuestStatus.error:
      case null:
        return Icons.error_outline;
    }
  }

  @override
  Widget build(BuildContext context) {
    final questStatus = gameState.questStatuses[questNumber - 1];
    return CircleAvatar(
      radius: 30,
      backgroundColor: _questTileColor(questStatus),
      child: IconButton(
        iconSize: 40,
        color: Colors.white,
        icon: Icon(_questTileIconData(questStatus)),
        onPressed: () {
          // TODO !! quest info
        },
      ),
    );
  }
}
