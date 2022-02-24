import 'package:cloud_chest/data/api_response.dart';
import 'package:cloud_chest/models/user.dart';
import 'package:flutter/material.dart';

// Holds the state of album details and allows user to update it
class AlbumDetailViewModel extends ChangeNotifier {
  late String albumId;
  late String albumTitle;
  late DateTime creationDate;
  late double size;
  late int totalItems;
  List<User> usersList = [];

  String get id => albumId;

  String get title => title;

  DateTime get creation => creationDate;

  List<User> get users => [...usersList];

  void fetchAlbumDetail(String albumId) async {
    // Fetches album detail from the server
  }

  void removeUser(String userId) {
    // Removes user from the list
  }

  void addUser(String userId, List<String> rights) {
    // Adds new user with rights chosen by user
  }

  void updateAlbumDetail() async {
    // Makes a call to the server for album detail detail with current infos
  }
}
