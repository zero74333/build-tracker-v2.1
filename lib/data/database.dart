import 'dart:convert';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

String dateKey(DateTime date) =>
    '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';

class TrackerDb {
  TrackerDb._();

  static Database? _db;
  static Future<Database>? _opening;

  static Future<Database> get _database {
    final existing = _db;
    if (existing != null) return Future<Database>.value(existing);
    return _opening ??= _openDatabase();
  }

  static Future<Database> _openDatabase() async {
    try {
      final dbPath = join(await getDatabasesPath(), 'tracker.db');
      final database = await openDatabase(
        dbPath,
        version: 1,
        onCreate: (db, _) async {
          await db.execute(
            'CREATE TABLE days(date TEXT PRIMARY KEY, data TEXT NOT NULL)',
          );
        },
      );
      _db = database;
      return database;
    } finally {
      _opening = null;
    }
  }

  static Future<Map<String, dynamic>> load(String date) async {
    final db = await _database;
    final rows = await db.query('days', where: 'date = ?', whereArgs: [date]);
    if (rows.isEmpty) return <String, dynamic>{};
    final decoded = jsonDecode(rows.first['data'] as String);
    if (decoded is! Map) return <String, dynamic>{};
    return Map<String, dynamic>.from(decoded);
  }

  static Future<void> save(String date, Map<String, dynamic> data) async {
    final db = await _database;
    await db.insert(
      'days',
      {'date': date, 'data': jsonEncode(data)},
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  static Future<Map<String, Map<String, dynamic>>> loadAll() async {
    final db = await _database;
    final rows = await db.query('days', orderBy: 'date ASC');
    final result = <String, Map<String, dynamic>>{};
    for (final row in rows) {
      final decoded = jsonDecode(row['data'] as String);
      if (decoded is Map) {
        result[row['date'] as String] = Map<String, dynamic>.from(decoded);
      }
    }
    return result;
  }

  /// Restores without deleting existing dates. Imported values override matching keys.
  static Future<int> mergeAll(Map<String, Map<String, dynamic>> imported) async {
    final db = await _database;
    final existing = await loadAll();
    final batch = db.batch();
    for (final entry in imported.entries) {
      final merged = <String, dynamic>{
        ...?existing[entry.key],
        ...entry.value,
      };
      batch.insert(
        'days',
        {'date': entry.key, 'data': jsonEncode(merged)},
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
    await batch.commit(noResult: true);
    return imported.length;
  }
}
