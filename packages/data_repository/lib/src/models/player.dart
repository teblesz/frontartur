class Player {
  const Player({
    required this.id,
    required this.userUid,
    required this.nick,
    this.character,
  });

  final String id;
  final String userUid;
  final String nick;
  final String? character;
}
