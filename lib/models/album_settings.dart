// To be used in a single album settings screen
import 'dart:convert';

import 'package:cloud_chest/models/user.dart';

class AlbumSettings {
  String albumId;
  String title;
  String thumbnail;
  List<User> users;

  AlbumSettings(
      {required this.albumId,
      required this.title,
      required this.users,
      this.thumbnail = ''});

  Map<String, String> toJson() {
    final jsonUsers = [];

    users.forEach(
      (user) {
        jsonUsers.add({
          'userId': user.userId,
          'email': user.email,
          'username': user.username ?? '',
          'rights': user.rights
        });
      },
    );

    return {
      'albumId': albumId,
      'title': title,
      'thumbnail': thumbnail,
      'users': json.encode(jsonUsers)
    };
  }

  factory AlbumSettings.fromJson(Map<String, dynamic> json) {
    List<User> users = [];

    for (Map<String, dynamic> u in json['users']) {
      users.add(User.fromJson(u));
    }

    return AlbumSettings(
        albumId: json['_id'],
        title: json['title'],
        thumbnail: json['thumbnail'] ?? '',
        users: users);
  }
}
