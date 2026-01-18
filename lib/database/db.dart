import "package:sqflite/sqflite.dart";
import "package:path/path.dart";

class DatabaseHelper {
  static final DatabaseHelper databaseHelper = DatabaseHelper._internal(
    delete: true,
  );
  static Database? _database;

  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    } else {
      _database = await _createDatabase();
      return _database!;
    }
  }

  DatabaseHelper._internal({bool delete = false});

  Future<int> createAlarm(
    int hour,
    int minute,
    bool isVibrate,
    int days,
    String tonePath,
    String? title,
  ) async {
    Database db = await database;
    return await db.insert("alarm", {
      "hour": hour,
      "minute": minute,
      "vibrate": isVibrate == true ? 1 : 0,
      "tone_path": tonePath,
      "days": days,
      "title": title,
      "enabled": 1,
    });
  }

  Future<void> delAlarm(int id) async {
    Database db = await database;
    await db.delete("alarm", where: "id = ?", whereArgs: [id]);
  }

  Future<void> updateAlarm(
    int id, {
    int? hour,
    int? minute,
    bool? isVibrate,
    String? tonePath,
    int? days,
    bool? enabled,
    String? title,
  }) async {
    final db = await database;
    final Map<String, dynamic> newData = {};

    if (hour != null) newData["hour"] = hour;
    if (minute != null) newData["minute"] = minute;
    if (isVibrate != null) newData["vibrate"] = isVibrate ? 1 : 0;
    if (tonePath != null) newData["tone_path"] = tonePath;
    if (enabled != null) newData["enabled"] = enabled ? 1 : 0;
    if (days != null) newData["days"] = days;
    if (title != null) newData["title"] = title;

    if (newData.isEmpty) return;

    await db.update("alarm", newData, where: "id = ?", whereArgs: [id]);
  }

  Future<Database> _createDatabase() async {
    // this method is called if the database don't exists
    String dbPath = await getDatabasesPath();
    String alarmDbPath = join(dbPath, "alarm.db");

    Database alarmDb = await openDatabase(
      alarmDbPath,
      version: 1,
      onCreate: _onCreate,
    );
    return alarmDb;
  }

  // Future<int?> getId(int hour, int minute, int day) async {
  //   Database db = await database;
  //   final result = await db.query(
  //     'alarm',
  //     columns: ['id'],
  //     where: 'hour = ? AND minute = ? AND day = ?',
  //     whereArgs: [tim, day],
  //   );

  //   if (result.isEmpty) return null;

  //   return result.first['id'] as int;
  // }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute("""
      CREATE TABLE alarm (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        hour INTEGER NOT NULL,
        minute INTEGER NOT NULL,
        vibrate INTEGER NOT NULL CHECK (vibrate IN (0, 1)),
        tone_path TEXT NOT NULL,
        enabled INTEGER NOT NULL CHECK (enabled IN (0, 1)),
        days INTEGER NOT NULL CHECK (days BETWEEN 0 AND 127),
        title TEXT,

        UNIQUE (hour, minute, days)
      );

    """);
  }

  Future<Map<String, dynamic>> getDataById(int id) async {
    Database db = await database;

    final result = await db.query('alarm', where: 'id = ?', whereArgs: [id]);

    // if (result.isEmpty) return null;

    return result.first;
  }

  Future<List<Map<String, Object?>>> getData() async {
    // get all the alarm data in the alarm table
    Database db = await database;

    return await db.query("alarm");
  }

  Future<void> delAllData() async {
    // delete the table alarm
    Database db = await database;
    await db.delete("alarm");
  }
}
