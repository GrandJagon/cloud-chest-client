// To be used in a single album settings screen
import 'package:cloud_chest/models/user.dart';

class AlbumDetail {
  final String albumId;
  final String title;
  final String thumbnail;
  final List<dynamic> users;

  AlbumDetail(
      {required this.albumId,
      required this.title,
      required this.users,
      this.thumbnail = ''});

  Map<String, dynamic> toJson() => {
        'albumId': albumId,
        'title': title,
        'thumbnail': thumbnail,
        'users': users
      };

  factory AlbumDetail.fromJson(Map<String, dynamic> json) {
    List<User> users = [];

    for (Map<String, dynamic> u in json['users']) {
      users.add(User.fromJson(u));
    }

    return AlbumDetail(
        albumId: json['_id'],
        title: json['title'],
        thumbnail: json['thumbnail'] ?? '',
        users: users);
  }
}
