class Player {
  const Player({
    required this.id,
    required this.userId,
    required this.nick,
    this.character,
  });

  final String id;
  final String userId;
  final String nick;
  final String? character;
}
