import 'package:cloud_chest/models/picture.dart';
import 'package:cloud_chest/models/video.dart';
import '../content.dart';

// Factory class to handle content creation according to the extension (picture/video)
// More types to be added later
class ContentFactory {
  static Content createFromJson(Map<String, dynamic> json) {
    switch (json['mimetype']) {
      case 'jpg':
      case 'jpeg':
      case 'png':
        return Picture.fromJson(json);
      case 'mp4':
      case 'mkv':
      case 'm4v':
      case 'wmw':
      case 'avi':
        return Video.fromJson(json);
      default:
        return Picture.fromJson(json);
    }
  }
}
