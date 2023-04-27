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
        .add(Squad.init(1).toFirestore());

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

  /// player list stream getter
  Future<List<Player>> playersList() async {
    final playersSnap = await _firestore
        .collection('rooms')
        .doc(currentRoom.id)
        .collection('players')
        .get();
    return playersSnap.docs.map((doc) => Player.fromFirestore(doc)).toList();
  }

// TODO change this to a field in Room
  Future<int> get playersCount async {
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
    await playersSnap.docs[leaderIndex].reference.update({'is_leader': true});
  }

  Future<void> nextLeader() async {
    //find leader id, set false, find next id, set true, circling
    final playersSnap = await _firestore
        .collection('rooms')
        .doc(currentRoom.id)
        .collection('players')
        .get();

    int leaderIndex = playersSnap.docs.indexWhere(
      (playerSnap) => Player.fromFirestore(playerSnap).isLeader,
    );
    await playersSnap.docs[leaderIndex].reference.update({'is_leader': false});

    final playersCount = await this.playersCount;
    leaderIndex = (leaderIndex + 1) % playersCount;
    await playersSnap.docs[leaderIndex].reference.update({'is_leader': true});
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
  Stream<List<Member>> streamMembersList({required squadId}) {
    return _firestore
        .collection('rooms')
        .doc(currentRoom.id)
        .collection('squads')
        .doc(squadId)
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

  Future<void> submitSquad() async {
    final squadSnap = await _firestore
        .collection('rooms')
        .doc(currentRoom.id)
        .collection('squads')
        .doc(currentRoom.currentSquadId)
        .get();
    squadSnap.reference.update({'is_submitted': true});
  }

  Future<void> updateSquadIsApproved({bool isApproved = true}) async {
    final squadSnap = await _firestore
        .collection('rooms')
        .doc(currentRoom.id)
        .collection('squads')
        .doc(currentRoom.currentSquadId)
        .get();
    squadSnap.reference.update({'is_approved': isApproved});
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

  void subscribeSquadIsSubmittedWith({
    String squadId = '',
    required void Function(Squad) doLogic,
  }) async {
    await refreshRoomCache();
    if (squadId == '') {
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

  String currentSquadId = ''; // TODO remove this (?)

  void subscribeCurrentSquadIdWith({
    required void Function(String) doLogic,
  }) {
    _currentSquadIdSubscription = _firestore
        .collection('rooms')
        .doc(currentRoom.id)
        .snapshots()
        .listen((snap) {
      final newCurrentSquadId = Room.fromFirestore(snap).currentSquadId;
      if (newCurrentSquadId == currentSquadId) return;
      currentSquadId = newCurrentSquadId;
      doLogic(newCurrentSquadId);
    });
  }

  void unsubscribeCurrentSquadId() => _currentSquadIdSubscription?.cancel();

  Stream<String> streamCurrentSquadId() {
    return _firestore
        .collection('rooms')
        .doc(currentRoom.id)
        .snapshots()
        .map((roomSnap) => Room.fromFirestore(roomSnap).currentSquadId);
  }

  //--------------------------------squad voting-------------------------------------

  voteSquad(bool vote) {
    _firestore
        .collection('rooms')
        .doc(currentRoom.id)
        .collection('squads')
        .doc(currentRoom.currentSquadId)
        .update({'votes.${currentPlayer.id}': vote});
  }

  StreamSubscription? _squadVotesSubscription;

  void subscribeSquadVotesWith({
    required void Function(Map<String, bool>) doLogic,
  }) {
    _squadVotesSubscription = _firestore
        .collection('rooms')
        .doc(currentRoom.id)
        .collection('squads')
        .doc(currentRoom.currentSquadId)
        .snapshots()
        .listen((snap) {
      doLogic(Map<String, bool>.from(snap['votes']));
    });
  }

  void unsubscribeSquadVotes() => _squadVotesSubscription?.cancel();

  Future<String?> _getMemberIdWith({required Player player}) async {
    final memberQuerySnap = await _firestore
        .collection('rooms')
        .doc(currentRoom.id)
        .collection('squads')
        .doc(currentRoom.currentSquadId)
        .collection('members')
        .where('player_id', isEqualTo: player.id)
        .limit(1)
        .get();
    return memberQuerySnap.docs.isNotEmpty
        ? memberQuerySnap.docs.first.id
        : null;
  }

  //--------------------------------quest voting-------------------------------------

  Future<bool> isCurrentPlayerAMember() async {
    final memberId = await _getMemberIdWith(player: currentPlayer);
    return memberId != null;
  }

  Future<void> voteQuest(bool vote) async {
    final memberId = await _getMemberIdWith(player: currentPlayer);
    _firestore
        .collection('rooms')
        .doc(currentRoom.id)
        .collection('squads')
        .doc(currentRoom.currentSquadId)
        .collection('members')
        .doc(memberId)
        .update({'vote': vote});
  }

  StreamSubscription? _questVotesSubscription;

  void subscribeQuestVotesWith({
    required void Function(List<bool?>) doLogic,
  }) {
    _questVotesSubscription = _firestore
        .collection('rooms')
        .doc(currentRoom.id)
        .collection('squads')
        .doc(currentRoom.currentSquadId)
        .collection('members')
        .snapshots()
        .listen((snap) {
      final votes = snap.docs.map((doc) => doc.data()['vote']);
      doLogic(List<bool?>.from(votes));
    });
  }

  void unsubscribeQuestVotes() => _questVotesSubscription?.cancel();

  Future<void> updateSquadIsSuccessfull({bool isSuccessfull = true}) async {
    final squadSnap = await _firestore
        .collection('rooms')
        .doc(currentRoom.id)
        .collection('squads')
        .doc(currentRoom.currentSquadId)
        .get();
    squadSnap.reference.update({'is_successfull': isSuccessfull});
  }

//TODO add simillar stream for questTiles
  Future<List<Squad>> getApprovedSquads() async {
    final squadsSnap = await _firestore
        .collection('rooms')
        .doc(currentRoom.id)
        .collection('squads')
        .where('is_approved', isEqualTo: true)
        .get();
    return List<Squad>.from(
        squadsSnap.docs.map((snap) => Squad.fromFirestore(snap)));
  }

// TODO change this to a field in squad
  Future<int> get membersCount async {
    final membersSnap = await _firestore
        .collection('rooms')
        .doc(currentRoom.id)
        .collection('squads')
        .doc(currentRoom.currentSquadId)
        .collection('members')
        .get();
    return membersSnap.size;
  }

  // DataRepository
}
