part of 'game_form.dart';

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
                Text(AppLocalizations.of(context).court,
                    style: TextStyle(fontSize: 30)),
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
                Text(AppLocalizations.of(context).squad,
                    style: TextStyle(fontSize: 30)),
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
      onTap: () => context.read<GameCubit>().addMember(player: player),
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
    // TODO move curretnsqadid to cubit and make blocbuilder here instead
    return StreamBuilder<String>(
      stream: context.read<DataRepository>().streamCurrentSquadId(),
      builder: (context, snapshot) {
        var currentSquadId = snapshot.data;
        return currentSquadId == null
            ? const Text('<squad is empty>')
            : StreamBuilder<List<Member>>(
                stream: context
                    .read<GameCubit>()
                    .streamMembersList(squadId: currentSquadId),
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
      onTap: () => context.read<GameCubit>().removeMember(member: member),
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
