// To be used in a single album settings screen
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

  factory AlbumDetail.fromJson(Map<String, dynamic> json) => AlbumDetail(
      albumId: json['_id'],
      title: json['title'],
      thumbnail: json['thumbnail'] ?? '',
      users: json['users']);
}
