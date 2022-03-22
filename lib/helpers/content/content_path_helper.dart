import 'dart:io' as io;
import '../../models/content/content.dart';
import '../persistance/db_parsing_helper.dart';

// Helps the currentAlbumViewModel to check if current content is stored in db
// Adds it if not and toggles the locally stored status or not if need
// Takes content objects and returns content object
class ContentPathHelper {
  // Takes a content list and for each of them check if path is stored locally or not
  // If it is the case then update the content object
  // If there is no entry corresponding to the content then add it with storedLocal set to false
  static Future<List<Content>> updateList(List<Content> contentList) async {
    for (Content content in contentList) {
      var localPath = await DbParsingHelper.fetchLocalPath(content.id);

      if (localPath == 0) continue;
      if (localPath == null) {
        await DbParsingHelper.addEntry(content.id);
        continue;
      }

      final bool fileExists = await _fileExists(localPath);

      if (!fileExists) {
        await DbParsingHelper.toggleStoredLocal(content.id);
        continue;
      }

      content.localPath = localPath;
      content.setLocal(true);
      print('just set ' + content.isLocal().toString());
    }
    print(contentList);
    return contentList;
  }

  // Adds a list of content stored locally to the db
  // Used when user upload pictures on the server
  static Future<void> addList(List<Content> contentList) async {
    for (Content content in contentList) {
      await DbParsingHelper.addEntry(content.id);
    }
  }

  // Removes an entire content list from the db
  static Future<void> removeList(List<Content> contentList) async {
    for (Content content in contentList) {
      await DbParsingHelper.removeEntry(content.id);
    }
  }

  // Sets local path to a list, used when user downloads content from server
  static Future<void> addLocalPathToList(List<Content> contentList) async {
    for (Content content in contentList) {
      await DbParsingHelper.toggleStoredLocal(content.id, content.localPath)
          .then((value) => content.setLocal(true));
    }
  }

  // Checks if file exists locally given local path
  // In case user deleted picture directly from gallery
  static Future<bool> _fileExists(String localPath) async {
    final bool fileExists = await io.File(localPath).exists();

    return fileExists;
  }
}
