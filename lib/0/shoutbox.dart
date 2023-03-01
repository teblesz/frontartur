import 'package:flutter/material.dart';
import 'package:fluttartur/data/room.dart';
import 'package:fluttartur/data/shoutbox_data_source.dart';

class Shoutbox with ChangeNotifier {
  Shoutbox({required ShoutboxDataSource shoutboxDataSource})
      : _shoutboxDataSource = shoutboxDataSource;

  final ShoutboxDataSource _shoutboxDataSource;
  List<Room> rooms = [];

  Future<void> refresh() async {
    rooms = await _shoutboxDataSource.getRooms();
    notifyListeners();
  }
}
