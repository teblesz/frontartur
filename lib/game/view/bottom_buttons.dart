part of 'game_form.dart';

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
      onPressed: context.read<GameCubit>().submitSquad,
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
