import 'package:cloud_chest/utils/network.dart';

import 'content.dart';

class Video extends Content {
  Video(
      {required id, required path, required size, required mimetype, metadata})
      : super(
            id: id,
            path: path,
            size: size,
            mimetype: mimetype,
            metadata: metadata);

  factory Video.fromJson(Map<String, dynamic> json) => Video(
      id: json['_id'],
      path: NetworkUtils.createContentPath(json['path']),
      size: json['size'],
      mimetype: json['mimetype'],
      metadata: json['metada'] ?? null);

  void play() {}
}
