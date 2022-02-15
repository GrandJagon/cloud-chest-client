// To be used in the home page with small info about each album to display in a grid
class Album {
  final String albumId;
  final String title;
  final String thumbnail;
  final List<dynamic> rights;

  Album(
      {required this.albumId,
      required this.title,
      required this.rights,
      this.thumbnail = ''});

  Map<String, dynamic> toJson() => {
        'albumId': albumId,
        'title': title,
        'thumbnail': thumbnail,
        'rights': rights
      };

  factory Album.fromJson(Map<String, dynamic> json) => Album(
      albumId: json['albumId'],
      title: json['title'],
      thumbnail: json['thumbnail'] ?? '',
      rights: json['rights']);
}
