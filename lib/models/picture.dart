import 'content.dart';

class Picture extends Content {
  Picture({required path, required size, required mimetype, metadata})
      : super(path: path, size: size, mimetype: mimetype, metadata: metadata);

  factory Picture.fromJson(Map<String, dynamic> json) => Picture(
      path: Uri.parse(json['path']),
      size: json['size'],
      mimetype: json['mimetype'],
      metadata: json['metadata'] ?? null);
}
