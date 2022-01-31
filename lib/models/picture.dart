import 'package:cloud_chest/utils/network.dart';

import 'content.dart';

class Picture extends Content {
  Picture(
      {required id, required path, required size, required mimetype, metadata})
      : super(
            id: id,
            path: path,
            size: size,
            mimetype: mimetype,
            metadata: metadata);

  factory Picture.fromJson(Map<String, dynamic> json) => Picture(
      id: json['_id'],
      path: NetworkUtils.createContentPath(json['path']),
      size: json['size'],
      mimetype: json['mimetype'],
      metadata: json['metadata'] ?? null);
}
