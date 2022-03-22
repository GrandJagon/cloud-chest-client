import 'dart:io';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart' as pathProvider;
import 'package:http/http.dart' as http;
import '../../models/content/content.dart';

// Provides methods to download files and store them locally
class DownloadHelper {
  static DownloadHelper _singleton = new DownloadHelper._internal();

  factory DownloadHelper() {
    return _singleton;
  }

  DownloadHelper._internal();

  // Downloads files from a list of urls and store them in the gallery
  // Updates the content with the new path
  // Returns the updated it in order for parent to update path in db
  Future<List<Content>> downloadToGallery(List<Content> contents) async {
    try {
      Directory? dir;

      if (Platform.isIOS) {
        dir = await pathProvider.getApplicationDocumentsDirectory();
      } else {
        dir = await pathProvider.getExternalStorageDirectory();
      }

      String documentsPath = dir!.path;

      for (Content content in contents) {
        // Content already downloaded
        if (content.isLocal()) {
          content.setSelected(false);
          continue;
        }
        // Toggles content state so display is updated accordingly
        content.toggleDownloading();

        final String url = content.path;
        final response = await http.get(Uri.parse(url));
        final name = path.basename(url);
        final tempPath = path.join(documentsPath, name);

        final file = File(tempPath);
        await file.writeAsBytes(response.bodyBytes);

        print('FILE DOWNLOADED WITH PATH ' + tempPath);

        content.localPath = tempPath;
        content.setLocal(true);

        // Reset state to false before path changing so image does not reload
        content.clearState();
      }

      return contents;
    } on Exception catch (e, s) {
      print(s);
      print(e);
      throw e;
    }
  }

  // Calls the proper method to store in gallery given a type
  Future<void> _storeInGallery(String filepath) async {
    switch (path.extension(filepath)) {
      case 'jpg':
      case 'jpeg':
      case 'png':
        //await GalleryHelper().savePicture(filepath);
        break;
      case 'mp4':
      case 'mkv':
      case 'm4v':
      case 'wmw':
      case 'avi':
        //await GalleryHelper().saveVideo(filepath);
        break;
      default:
        //await GalleryHelper().savePicture(filepath);
        break;
    }
  }
}
