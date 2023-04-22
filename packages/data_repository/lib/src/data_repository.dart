import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:data_repository/models/member.dart';
import 'package:data_repository/models/models.dart';
import 'package:cache/cache.dart';

part 'data_failures.dart';
// TODO unique room name (kahoot-like) https://stackoverflow.com/questions/47543251/firestore-unique-index-or-unique-constraint
// TODO divide this moloch (mixins?, extension methods?) separate classes?
// TODO limit number of players in room

class DataRepository {
  DataRepository({
    CacheClient? cache,
    FirebaseFirestore? firestore,
  })  : _cache = cache ?? CacheClient(),
        _firestore = firestore ?? FirebaseFirestore.instance;

  final CacheClient _cache;
  final FirebaseFirestore _firestore;

  //------------------------room------------------------
  static const roomCacheKey = '__room_cache_key__';

  Room get currentRoom {
    return _cache.read<Room>(key: roomCacheKey) ?? Room.empty;
  }

  /// room stream getter
  Future<void> refreshRoomCache() async {
    final roomSnap =
        await _firestore.collection('rooms').doc(currentRoom.id).get();
    _cache.write(key: roomCacheKey, value: Room.fromFirestore(roomSnap));
  }

  /// room stream getter
  Stream<Room> streamRoom() {
    if (currentRoom.isEmpty) {
      throw const StreamingRoomFailure(
          "Current room is Room.empty (has no ID)");
    }
    return _firestore
        .collection('rooms')
        .doc(currentRoom.id)
        .snapshots()
        .map((snap) {
      _cache.write(key: roomCacheKey, value: Room.fromFirestore(snap));
      return Room.fromFirestore(snap);
    });
  }

  // TODO add players number limitation on room creation or in firebase rules
  Future<void> createRoom({required String userId}) async {
    final roomRef = await _firestore
        .collection('rooms')
        .add(Room.init(hostUserId: userId).toFirestore());

    final snap = await roomRef.get();
    _cache.write(key: roomCacheKey, value: Room.fromFirestore(snap));
  }

  Future<void> joinRoom({required String roomId}) async {
    final roomSnap = await _firestore.collection('rooms').doc(roomId).get();
    if (!roomSnap.exists) throw GetRoomByIdFailure();

    if (Room.fromFirestore(roomSnap).gameStarted) {
      throw const JoiningStartedGameFailure();
    }

    _cache.write(key: roomCacheKey, value: Room.fromFirestore(roomSnap));
  }

  Future<void> updateRoomCharacters(List<String> characters) async {
    //TODO this feature
  }

  /// sets game_started and current_squad_id fields in room document
  Future<void> startGame() async {
    final firstSquadRef = await _firestore
        .collection('rooms')
        .doc(currentRoom.id)
        .collection('squads')
        .add(const Squad.init(1).toFirestore());

    final roomSnap =
        await _firestore.collection('rooms').doc(currentRoom.id).get();

    await roomSnap.reference.update({'current_squad_id': firstSquadRef.id});
    await roomSnap.reference.update({'game_started': true});
  }

  StreamSubscription? _gameStartedSubscription;

  void subscribeGameStartedWith({required void Function(bool) doLogic}) {
    _gameStartedSubscription = _firestore
        .collection('rooms')
        .doc(currentRoom.id)
        .snapshots()
        .listen((snap) {
      doLogic(Room.fromFirestore(snap).gameStarted);
    });
  }

  void unsubscribeGameStarted() => _gameStartedSubscription?.cancel();

  //-----------------------------user's player----------------------------------
  static const playerCacheKey = '__player_cache_key__';

  Player get currentPlayer {
    return _cache.read<Player>(key: playerCacheKey) ?? Player.empty;
  }

  /// player stream getter
  Stream<Player> streamPlayer() {
    if (currentPlayer.isEmpty) {
      throw const StreamingPlayerFailure(
          "Current player is Player.empty (has no ID)");
    }
    return _firestore
        .collection('rooms')
        .doc(currentRoom.id)
        .collection('players')
        .doc(currentPlayer.id)
        .snapshots()
        .map((snap) {
      _cache.write(key: playerCacheKey, value: Player.fromFirestore(snap));
      return Player.fromFirestore(snap);
    });
  }

  Future<void> addPlayer({
    required String userId,
    required String nick,
    bool isLeader = false,
  }) async {
    var player = Player(userId: userId, nick: nick, isLeader: isLeader);

    final playerRef = await _firestore
        .collection('rooms')
        .doc(currentRoom.id)
        .collection('players')
        .add(player.toFirestore());

    final snap = await playerRef.get();
    _cache.write(key: playerCacheKey, value: Player.fromFirestore(snap));
  }

  Future<void> leaveRoom() async {
    await removePlayer(playerId: currentPlayer.id);
    _cache.write(key: playerCacheKey, value: Player.empty);
    _cache.write(key: roomCacheKey, value: Room.empty);
  }

  //-----------------------------players------------------------------------
  /// player list stream getter
  Stream<List<Player>> streamPlayersList() {
    return _firestore
        .collection('rooms')
        .doc(currentRoom.id)
        .collection('players')
        .snapshots()
        .map((list) =>
            list.docs.map((snap) => Player.fromFirestore(snap)).toList());
  }

  Future<int> get numberOfPlayers async {
    final playersSnap = await _firestore
        .collection('rooms')
        .doc(currentRoom.id)
        .collection('players')
        .get();
    return playersSnap.size;
  }

  Future<void> assignCharacters(List<String> characters) async {
    final batch = FirebaseFirestore.instance.batch();
    final playersSnap = await _firestore
        .collection('rooms')
        .doc(currentRoom.id)
        .collection('players')
        .get();

    final players = playersSnap.docs;
    if (players.length != characters.length) {
      throw const CharacterAndPlayersCountsDoNotMatchFailure();
    }

    for (int i = 0; i < players.length; i++) {
      batch.update(players[i].reference, {'character': characters[i]});
    }
    await batch.commit();
  }

  Future<void> assignLeader(leaderIndex) async {
    final playersSnap = await _firestore
        .collection('rooms')
        .doc(currentRoom.id)
        .collection('players')
        .get();

    playersSnap.docs[leaderIndex].reference.update({'is_leader': true});
  }

  Future<void> removePlayer({required String playerId}) async {
    if (currentPlayer.isEmpty) {
      throw const StreamingPlayerFailure(
          "Current player is Player.empty (has no ID)");
    }
    await _firestore
        .collection('rooms')
        .doc(currentRoom.id)
        .collection('players')
        .doc(playerId)
        .delete();
  }

  //--------------------------------squad members-------------------------------------
  Stream<List<Member>> streamMembersList({required int questNumber}) {
    return _firestore
        .collection('rooms')
        .doc(currentRoom.id)
        .collection('squads')
        .doc(currentRoom.currentSquadId)
        .collection('members')
        .snapshots()
        .map((list) =>
            list.docs.map((snap) => Member.fromFirestore(snap)).toList());
  }

  /// add player to squad
  Future<void> addMember({
    required int questNumber,
    required String playerId,
    required String nick,
  }) async {
    await _firestore
        .collection('rooms')
        .doc(currentRoom.id)
        .collection('squads')
        .doc(currentRoom.currentSquadId)
        .collection('members')
        .add(Member(playerId: playerId, nick: nick).toFirestore());
  }

  /// remove player from squad
  Future<void> removeMember({
    required int questNumber,
    required String memberId,
  }) async {
    await _firestore
        .collection('rooms')
        .doc(currentRoom.id)
        .collection('squads')
        .doc(currentRoom.currentSquadId)
        .collection('members')
        .doc(memberId)
        .delete();
  }

  //--------------------------------squads-------------------------------------
  Future<void> nextLeader() async {
    // TODO
    //find leader id, set false, find next id, set true, circling
  }

  Future<void> submitSquad() async {
    final squadSnap = await _firestore
        .collection('rooms')
        .doc(currentRoom.id)
        .collection('squads')
        .doc(currentRoom.currentSquadId)
        .get();
    squadSnap.reference.update({'is_submitted': true});
  }

  /// creates new squad and sets new value for current_squad_id
  Future<void> nextSquad({required int questNumber}) async {
    final newSquadRef = await _firestore
        .collection('rooms')
        .doc(currentRoom.id)
        .collection('squads')
        .add(Squad.init(questNumber).toFirestore());

    final roomSnap =
        await _firestore.collection('rooms').doc(currentRoom.id).get();

    roomSnap.reference.update({'current_squad_id': newSquadRef.id});
  }

  StreamSubscription? _squadIsSubmittedSubscription;

  void subscribeSquadWith({
    String squadId = '',
    required void Function(Squad) doLogic,
  }) async {
    if (squadId == '') {
      await refreshRoomCache();
      squadId = currentRoom.currentSquadId;
    }

    _squadIsSubmittedSubscription = _firestore
        .collection('rooms')
        .doc(currentRoom.id)
        .collection('squads')
        .doc(squadId)
        .snapshots()
        .listen(
          (snap) => doLogic(Squad.fromFirestore(snap)),
        );
  }

  void unsubscribeSquadIsSubmitted() => _squadIsSubmittedSubscription?.cancel();

  StreamSubscription? _currentSquadIdSubscription;

  String _oldCurrentSquadId = ''; // TODO remove this (?)

  void subscribeCurrentSquadIdWith({
    required void Function(String) doLogic,
  }) {
    _currentSquadIdSubscription = _firestore
        .collection('rooms')
        .doc(currentRoom.id)
        .snapshots()
        .listen((snap) {
      final currentSquadId = Room.fromFirestore(snap).currentSquadId;
      if (currentSquadId == _oldCurrentSquadId) return;
      _oldCurrentSquadId = currentSquadId;
      doLogic(currentSquadId);
    });
  }

  void unsubscribeCurrentSquadId() => _currentSquadIdSubscription?.cancel();

  //--------------------------------votings-------------------------------------

  voteSquad(bool vote) {
    // TODO
  }
}
