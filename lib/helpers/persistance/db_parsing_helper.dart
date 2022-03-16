import 'db_helper.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

// Helps to retrieve album contents that are already stored locally
// Goal is to alleviate server bandwith and feztching only necessary files
class DbParsingHelper {
  // Takes a content id and fetches its local path if exists
  // Returns it unchanged if not
  static Future<String> fetchLocalPath(String contentId) async {
    List<Map<String, dynamic>> fetchResult =
        await DbHelper().fetch(dotenv.env['DB_TABLE_NAME']!, contentId);

    if (fetchResult.length <= 0) {
      print(contentId + ' not found in the db');
      return contentId;
      // EXCEPTION ??
      // ADD IT ?
    }

    if (fetchResult.length > 1) {
      print(contentId + ' collision in database');
      // COLLISION EXCEPTION
    }

    Map<String, dynamic> dbRow = fetchResult[0];

    if (dbRow['storedLocal'] == 1) return dbRow['localPath'];

    return contentId;
  }

  static Future<void> addLocalPath(String contentId, String localPath) async {
    // ADD A PATH TO ROW OR CREATE IT IF NOT EXIST
  }

  static Future<void> removeLocalPath(String contentId) async {
    // REMOVE LOCAL PATH FROM DB AND TOGGLE BOOL TO 0
  }

  static Future<void> removeContentEntry(String contentId) async {
    // REMOVE ENTRY FROM DB
    // WHEN CONTENT IS DELETED
  }
}
