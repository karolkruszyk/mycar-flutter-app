import 'package:mycar/pages/calendar/event.dart';
import 'package:mycar/pages/documentation/file.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DbHelper {
  static const int _version = 1;
  static const String _dbEventName = "Events.db";
  static const String _dbFileName = "Files.db";

  static Future<Database> _getEventDb() async {
    return openDatabase(join(await getDatabasesPath(), _dbEventName),
        onCreate: (db, version) async => await db.execute(
            "CREATE TABLE Event(id INTEGER PRIMARY KEY, category TEXT NOT NULL, title TEXT NOT NULL, date TEXT NOT NULL);"),
        version: _version);
  }

  static Future<int> addEvent(Event event) async {
    final db = await _getEventDb();
    return await db.insert("Event", event.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  static Future<int> updateEvent(Event event) async {
    final db = await _getEventDb();
    return await db.update("Event", event.toJson(),
        where: 'id = ?',
        whereArgs: [event.id],
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  static Future<int> deleteEvent(Event event) async {
    final db = await _getEventDb();
    return await db.delete(
      "Event",
      where: 'id = ?',
      whereArgs: [event.id],
    );
  }

  static Future<List<Event>?> getAllEvents() async {
    final db = await _getEventDb();

    final List<Map<String, dynamic>> maps = await db.query("Event");
    if (maps.isEmpty) {
      return null;
    }

    return List.generate((maps.length), (index) => Event.fromJson(maps[index]));
  }

  static Future<Database> _getFileDb() async {
    return openDatabase(join(await getDatabasesPath(), _dbFileName),
        onCreate: (db, version) async => await db.execute(
            "CREATE TABLE File(id INTEGER PRIMARY KEY, category TEXT NOT NULL, title TEXT NOT NULL, date TEXT NOT NULL, price INTEGER, picture BLOB);"),
        version: _version);
  }

  static Future<int> addFile(File file) async {
    final db = await _getFileDb();
    return await db.insert("File", file.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  static Future<int> updateFile(File file) async {
    final db = await _getFileDb();
    return await db.update("File", file.toMap(),
        where: 'id = ?',
        whereArgs: [file.id],
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  static Future<int> deleteFile(File file) async {
    final db = await _getFileDb();
    return await db.delete(
      "File",
      where: 'id = ?',
      whereArgs: [file.id],
    );
  }

  static Future<List<File>?> getAllFiles() async {
    final db = await _getFileDb();

    final List<Map<String, dynamic>> maps = await db.query("File");
    if (maps.isEmpty) {
      return null;
    }

    return List.generate((maps.length), (index) => File.fromMap(maps[index]));
  }
}
