import 'content.dart';

class Video extends Content {
  Video({required path, required size, required mimetype, metadata})
      : super(path: path, size: size, mimetype: mimetype, metadata: metadata);

  factory Video.fromJson(Map<String, dynamic> json) => Video(
      path: json['path'],
      size: json['size'],
      mimetype: json['mimetype'],
      metadata: json['metada'] ?? null);

  void play() {}
}
