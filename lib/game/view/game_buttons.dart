part of 'game_form.dart';

class _GameButtons extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // streamBuilder is here to start streaming player for bussiness logic (?)
    // TODO this /\ is stupid
    return StreamBuilder<Player>(
        stream: context.read<DataRepository>().streamPlayer(),
        builder: (context, snapshot) {
          var player = snapshot.data ?? Player.empty;
          return BlocBuilder<GameCubit, GameState>(
              // TODO remove this
              buildWhen: (previous, current) =>
                  previous.status != current.status,
              builder: (context, state) {
                if (state.status == GameStatus.squadChoice && player.isLeader) {
                  return _SubmitSquadButton();
                } else if (state.status == GameStatus.squadVoting) {
                  return _VoteSquadPanel();
                } else if (state.status == GameStatus.questVoting) {
                  return _EmbarkmentCardIfMember();
                } else {
                  return const SizedBox.shrink();
                }
              });
        });
  }
}

class _SubmitSquadButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: FilledButton(
        onPressed: context.read<GameCubit>().submitSquad,
        child: Text(AppLocalizations.of(context).submitSquad,
            style: const TextStyle(fontSize: 25)),
      ),
    );
  }
}

class _VoteSquadPanel extends StatefulWidget {
  @override
  State<_VoteSquadPanel> createState() => _VoteSquadPanelState();
}

class _VoteSquadPanelState extends State<_VoteSquadPanel> {
  bool _isDisabled = false;

  void _updateIsDisabled(bool newState) {
    setState(() {
      _isDisabled = newState;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.zero,
      child: Column(
        children: [
          const SizedBox(height: 10),
          Text(AppLocalizations.of(context).voteForThisSquad,
              style: const TextStyle(fontSize: 30)),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _VoteSquadButton(
                isPositive: true,
                isDisabled: _isDisabled,
                updateisDisabled: _updateIsDisabled,
              ),
              _VoteSquadButton(
                isPositive: false,
                isDisabled: _isDisabled,
                updateisDisabled: _updateIsDisabled,
              ),
            ],
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }
}

class _VoteSquadButton extends StatelessWidget {
  const _VoteSquadButton({
    required this.isDisabled,
    required this.updateisDisabled,
    required this.isPositive,
  });

  final bool isDisabled;
  final Function(bool) updateisDisabled;

  final bool isPositive;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        onPressed: isDisabled
            ? null
            : () {
                context.read<GameCubit>().voteSquad(isPositive);
                updateisDisabled(!isDisabled);
              },
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all<Color>(
              isPositive ? Colors.green.shade700 : Colors.red.shade700),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
              isPositive
                  ? AppLocalizations.of(context).accept
                  : AppLocalizations.of(context).reject,
              style: const TextStyle(fontSize: 25)),
        ));
  }
}

class _EmbarkmentCardIfMember extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: context.read<GameCubit>().isCurrentPlayerAMember(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        }
        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }
        bool isMember = snapshot.data ?? false;
        return isMember ? _EmbarkmentCard() : const SizedBox.shrink();
      },
    );
  }
}

class _EmbarkmentCard extends StatefulWidget {
  @override
  State<_EmbarkmentCard> createState() => _EmbarkmentCardState();
}

class _EmbarkmentCardState extends State<_EmbarkmentCard> {
  bool _isDisabled = false;

  void _updateIsDisabled(bool newState) {
    // TODO move this to context?
    setState(() {
      _isDisabled = newState;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.zero,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(AppLocalizations.of(context).thisSquadWasApproved,
                    style: const TextStyle(fontSize: 25)),
              ),
              FilledButton(
                onPressed: _isDisabled
                    ? null
                    : () => Navigator.push(
                        // of context?
                        context,
                        QuestPage.route(() => _updateIsDisabled(true))),
                child: Text(AppLocalizations.of(context).embark,
                    style: const TextStyle(fontSize: 30)),
              ),
              const SizedBox(height: 10),
            ],
          ),
        ],
      ),
    );
  }
}
