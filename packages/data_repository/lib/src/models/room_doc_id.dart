import 'package:equatable/equatable.dart';

/// for caching roomid
class RoomDocId extends Equatable {
  const RoomDocId(this.value);

  /// The current roomDocId's room id.
  final String value;

  static const RoomDocId empty = RoomDocId("");

  bool get isEmpty => this == RoomDocId.empty;

  bool get isNotEmpty => this != RoomDocId.empty;

  @override
  List<Object?> get props => [value];
}
