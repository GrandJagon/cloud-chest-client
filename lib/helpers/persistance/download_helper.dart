import 'package:cloud_chest/helpers/gallery_helper.dart';
import 'dart:io';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart' as pathProvider;
import 'package:http/http.dart' as http;

// Provides methods to download files and store them locally
class DownloadHelper {
  static DownloadHelper _singleton = new DownloadHelper._internal();

  factory DownloadHelper() {
    return _singleton;
  }

  DownloadHelper._internal();

  // Downloads files from a list of urls and store them in the gallery
  Future<void> downloadToGallery(List<String> urls) async {
    Directory directory = await pathProvider.getApplicationDocumentsDirectory();
    print(directory);
    for (final url in urls) {
      final response = await http.get(Uri.parse(url));
      print(response);
      final name = path.basename(url);
      final tempPath = path.join(directory.path, name);

      final file = File(tempPath);
      await file.writeAsBytes(response.bodyBytes);
      await _storeInGallery(tempPath).then(
        (value) => file.delete(),
      );
    }
  }

  // Calls the proper method to store in gallery given a type
  Future<void> _storeInGallery(String filepath) async {
    switch (path.extension(filepath)) {
      case 'jpg':
      case 'jpeg':
      case 'png':
        await GalleryHelper().savePicture(filepath);
        break;
      case 'mp4':
      case 'mkv':
      case 'm4v':
      case 'wmw':
      case 'avi':
        await GalleryHelper().saveVideo(filepath);
        break;
      default:
        await GalleryHelper().savePicture(filepath);
        break;
    }
  }
}
