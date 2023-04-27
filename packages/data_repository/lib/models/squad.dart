import 'package:equatable/equatable.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Squad extends Equatable {
  final String id;
  final int questNumber;
  final bool isSubmitted;
  final bool? isApproved;
  final bool? isSuccessfull;
  final Map<String, bool> votes; // atributed by playerId

  const Squad({
    required this.id,
    required this.questNumber,
    required this.isSubmitted,
    this.isApproved,
    this.isSuccessfull,
    required this.votes,
  });

  Squad.init(this.questNumber)
      : id = '',
        isSubmitted = false,
        isApproved = null,
        isSuccessfull = null,
        votes = <String, bool>{};

  /// Empty Squad
  static const empty = Squad(
    id: '',
    questNumber: 0,
    isSubmitted: false,
    isApproved: null,
    isSuccessfull: null,
    votes: <String, bool>{},
  );

  /// Convenience getter to determine whether the current Squad is empty.
  bool get isEmpty => this == Squad.empty;

  /// Convenience getter to determine whether the current Squad is not empty.
  bool get isNotEmpty => this != Squad.empty;

  @override
  List<Object?> get props =>
      [id, questNumber, isSubmitted, isApproved, isSuccessfull, votes];

  factory Squad.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data();
    return Squad(
      id: doc.id,
      questNumber: data?['quest_number'],
      isSubmitted: data?['is_submitted'],
      isApproved: data?['is_approved'],
      isSuccessfull: data?['is_successfull'],
      votes: Map.from(data?['votes']),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'quest_number': questNumber,
      'is_submitted': isSubmitted,
      if (isApproved != null) 'is_approved': isApproved,
      if (isSuccessfull != null) 'is_successfull': isSuccessfull,
      'votes': votes,
    };
  }
}
