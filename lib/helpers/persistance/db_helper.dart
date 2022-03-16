import 'package:sqflite/sqflite.dart' as sql;
import 'package:path/path.dart' as path;
import 'package:flutter_dotenv/flutter_dotenv.dart';

// Helper that will handle everything related to the sqlite database
// Used for the file index
// Simple database following the model : (
//  text primary key index,
//  integer storedLocal,
//  text localPath
// )

class DbHelper {
  static DbHelper _singleton = new DbHelper._internal();

  factory DbHelper() {
    return _singleton;
  }

  DbHelper._internal();

  // Returns the table in argument
  // creates them if first use
  Future<sql.Database> database(String table) async {
    final String dbpath = await sql.getDatabasesPath();

    return sql.openDatabase(path.join(dbpath, table), onCreate: (db, version) {
      db.execute(''' 
        CREATE TABLE content_index (
          id TEXT PRIMARY KEY,
          storedLocal INTEGER,
          localPath TEXT)
        ''');
    }, version: 1);
  }

  //Inserts some data into a table
  //JSON must have the same fields as database
  Future<void> insert(String table, Map<String, Object> data) async {
    final db = await database(table);

    await db.insert(table, data,
        conflictAlgorithm: sql.ConflictAlgorithm.replace);
  }

  //Returns data from a table
  //Map format
  Future<List<Map<String, dynamic>>> getData(String table) async {
    final db = await database(table);

    return db.query(table);
  }

  // Fetches a single entry
  Future<List<Map<String, dynamic>>> fetch(String table, String id) async {
    final db = await database(table);

    return db.query(table, where: 'id= ?', whereArgs: [id]);
  }

  //Deletes a given object in a given table
  //Object identified with ID
  Future<void> delete(String table, String id) async {
    final db = await database(table);

    final int count = await db.delete(table, where: 'id= ?', whereArgs: [id]);

    print(count.toString() + ' rows deleted');
  }

  // Updates an entry in a given table given an id
  Future<void> update(
      String table, String id, Map<String, Object> values) async {
    final db = await database(table);

    final int count =
        await db.update(table, values, where: 'id= ?', whereArgs: [id]);

    print(count.toString() + 'rows updated');
  }
}
