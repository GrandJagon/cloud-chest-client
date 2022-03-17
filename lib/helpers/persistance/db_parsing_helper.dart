import 'package:cloud_chest/exceptions/cloud_chest_exceptions.dart';
import 'db_helper.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

// Helps to retrieve album contents that are already stored locally
// Goal is to alleviate server bandwith and feztching only necessary files
class DbParsingHelper {
  // Takes a content id and fetches its local path if exists
  // Returns 0 if there is no local path stored
  // Returns null if entry does not exist in db
  static Future<dynamic> fetchLocalPath(String contentId) async {
    List<Map<String, dynamic>> fetchResult =
        await DbHelper().fetch(dotenv.env['DB_TABLE_NAME']!, contentId);

    if (fetchResult.length <= 0) {
      print(contentId + ' not found in the db');
      return null;
    }

    if (fetchResult.length > 1) {
      print(contentId + ' collision in database');
      throw DbException('Collision while fetching ' + contentId);
    }

    Map<String, dynamic> dbRow = fetchResult[0];

    print(dbRow);

    if (dbRow['storedLocal'] == 1) return dbRow['localPath'];

    return 0;
  }

  // If path is null then add the entry and sets the storedLocal int to false (0)
  static Future<void> addEntry(String contentId, [String? localPath]) async {
    Map<String, Object> _data = {
      "id": contentId,
      "storedLocal": localPath != null ? 1 : 0,
      "localPath": localPath ?? ''
    };
    int result = await DbHelper().insert(dotenv.env['DB_TABLE_NAME']!, _data);

    if (result == 0) {
      throw DbException('Could not add entry into the database');
    }

    print('Entry added ' + _data.toString());
  }

  static Future<void> removeEntry(String contentId) async {
    int result =
        await DbHelper().delete(dotenv.env['DB_TABLE_NAME']!, contentId);

    if (result == 0) {
      throw DbException('Could not delete entry from the database');
    }

    print('Entry removed ' + contentId);
  }

  // If localPath is null then removes it and toggles storedLocal to 0
  // If localPath is not null then adds it and toggles storedLocal to 1
  static Future<void> toggleStoredLocal(String contentId,
      [String? localPath]) async {
    Map<String, Object> data = {
      'storedLocal': localPath != null ? 1 : 0,
      'localPath': localPath ?? ''
    };

    int result =
        await DbHelper().update(dotenv.env['DB_TABLE_NAME']!, contentId, data);

    if (result == 0) {
      throw DbException('Could not update entry in the database');
    }

    print('Entry ' +
        contentId +
        ' state toggled to ' +
        (localPath != null).toString());
  }
}
