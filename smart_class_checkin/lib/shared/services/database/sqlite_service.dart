import 'package:sqflite/sqflite.dart';
import 'db_helper.dart';
import '../../../core/error/exceptions.dart';

/// Generic CRUD wrapper around [DbHelper].
/// Feature-specific datasources use this service instead of touching sqflite directly.
class SqliteService {
  final DbHelper _helper;

  SqliteService({DbHelper? helper}) : _helper = helper ?? DbHelper.instance;

  // ── Insert ───────────────────────────────────────────────
  /// Returns the new row ID.
  Future<int> insert(String table, Map<String, dynamic> row) async {
    try {
      final db = await _helper.database;
      return await db.insert(
        table,
        row,
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    } catch (e) {
      throw LocalStorageException('Insert failed: $e');
    }
  }

  // ── Query ────────────────────────────────────────────────
  Future<List<Map<String, dynamic>>> queryAll(String table) async {
    try {
      final db = await _helper.database;
      return await db.query(table);
    } catch (e) {
      throw LocalStorageException('QueryAll failed: $e');
    }
  }

  Future<List<Map<String, dynamic>>> queryWhere(
    String table, {
    required String where,
    required List<dynamic> whereArgs,
    String? orderBy,
    int? limit,
  }) async {
    try {
      final db = await _helper.database;
      return await db.query(
        table,
        where: where,
        whereArgs: whereArgs,
        orderBy: orderBy,
        limit: limit,
      );
    } catch (e) {
      throw LocalStorageException('Query failed: $e');
    }
  }

  // ── Update ───────────────────────────────────────────────
  /// Returns the number of rows affected.
  Future<int> update(
    String table,
    Map<String, dynamic> values, {
    required String where,
    required List<dynamic> whereArgs,
  }) async {
    try {
      final db = await _helper.database;
      return await db.update(table, values, where: where, whereArgs: whereArgs);
    } catch (e) {
      throw LocalStorageException('Update failed: $e');
    }
  }

  // ── Delete ───────────────────────────────────────────────
  Future<int> delete(
    String table, {
    required String where,
    required List<dynamic> whereArgs,
  }) async {
    try {
      final db = await _helper.database;
      return await db.delete(table, where: where, whereArgs: whereArgs);
    } catch (e) {
      throw LocalStorageException('Delete failed: $e');
    }
  }
}
