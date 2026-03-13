import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi_web/sqflite_ffi_web.dart';
import 'package:path/path.dart';

/// Manages the SQLite database lifecycle.
/// Use [DbHelper.instance] to get the singleton throughout the app.
class DbHelper {
  DbHelper._();
  static final DbHelper instance = DbHelper._();

  static Database? _db;

  // ── Schema ──────────────────────────────────────────────
  static const String dbName = 'smart_checkin.db';
  static const int dbVersion = 2;

  static const String tableAttendance = 'attendance';

  // Column names – mirrors PRD Section 5 data fields
  static const String colId = 'id';
  static const String colStudentId = 'student_id';
  static const String colCheckInTime = 'check_in_time';
  static const String colCheckOutTime = 'check_out_time';
  static const String colCheckInLat = 'check_in_lat';
  static const String colCheckInLng = 'check_in_lng';
  static const String colCheckOutLat = 'check_out_lat';
  static const String colCheckOutLng = 'check_out_lng';
  static const String colPreviousTopic = 'previous_topic';
  static const String colExpectedTopic = 'expected_topic';
  static const String colMood = 'mood';
  static const String colLearnedToday = 'learned_today';
  static const String colFeedback = 'feedback';
  static const String colQrCheckIn = 'qr_check_in';
  static const String colQrCheckOut = 'qr_check_out';
  static const String colPostClassMood = 'post_class_mood';

  // ── Accessor ────────────────────────────────────────────
  Future<Database> get database async {
    _db ??= await _initDb();
    return _db!;
  }

  Future<Database> _initDb() async {
    if (kIsWeb) {
      // Web: use IndexedDB-backed factory; getDatabasesPath() is unavailable
      databaseFactory = databaseFactoryFfiWeb;
      return openDatabase(
        dbName,
        version: dbVersion,
        onCreate: _onCreate,
        onUpgrade: _onUpgrade,
      );
    }

    final dbPath = await getDatabasesPath();
    return openDatabase(
      join(dbPath, dbName),
      version: dbVersion,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  // ── DDL ──────────────────────────────────────────────────
  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $tableAttendance (
        $colId           INTEGER PRIMARY KEY AUTOINCREMENT,
        $colStudentId    TEXT    NOT NULL,
        $colCheckInTime  TEXT    NOT NULL,
        $colCheckOutTime TEXT,
        $colCheckInLat   REAL    NOT NULL,
        $colCheckInLng   REAL    NOT NULL,
        $colCheckOutLat  REAL,
        $colCheckOutLng  REAL,
        $colPreviousTopic TEXT   NOT NULL,
        $colExpectedTopic TEXT   NOT NULL,
        $colMood          INTEGER NOT NULL CHECK($colMood BETWEEN 1 AND 5),
        $colLearnedToday  TEXT,
        $colFeedback      TEXT,
        $colQrCheckIn     TEXT   NOT NULL,
        $colQrCheckOut    TEXT,
        $colPostClassMood INTEGER
      )
    ''');
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      await db.execute(
        'ALTER TABLE $tableAttendance ADD COLUMN $colPostClassMood INTEGER',
      );
    }
  }

  /// Close DB (call only when app terminates or in tests)
  Future<void> close() async => _db?.close();
}
