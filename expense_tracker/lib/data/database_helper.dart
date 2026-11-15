import 'package:path/path.dart' as p;
import 'package:sqflite/sqflite.dart';

import '../models/expense.dart';
import '../models/expense_category.dart';

/// Single gateway to the on-device SQLite database.
///
/// One instance is shared app-wide (`DatabaseHelper.instance`) so the database
/// connection and its path are only ever created once.
class DatabaseHelper {
  DatabaseHelper._();

  static final DatabaseHelper instance = DatabaseHelper._();

  static const _fileName = 'expense_tracker.db';
  static const _version = 1;
  static const _table = 'expenses';

  Database? _db;

  Future<Database> get database async => _db ??= await _open();

  Future<Database> _open() async {
    final dbPath = p.join(await getDatabasesPath(), _fileName);
    return openDatabase(dbPath, version: _version, onCreate: _createSchema);
  }

  Future<void> _createSchema(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $_table (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT NOT NULL,
        amount REAL NOT NULL CHECK (amount > 0),
        category TEXT NOT NULL,
        date TEXT NOT NULL,
        note TEXT NOT NULL DEFAULT '',
        created_at TEXT NOT NULL
      )
    ''');
    await db.execute('CREATE INDEX idx_expenses_date ON $_table(date)');
  }

  // ---------------------------------------------------------------------------
  // CRUD
  // ---------------------------------------------------------------------------

  Future<int> insertExpense(Expense expense) async {
    final db = await database;
    return db.insert(_table, expense.toMap());
  }

  Future<List<Expense>> getAllExpenses() async {
    final db = await database;
    final rows = await db.query(
      _table,
      orderBy: 'date DESC, id DESC',
    );
    return rows.map(Expense.fromMap).toList();
  }

  Future<Expense?> getExpenseById(int id) async {
    final db = await database;
    final rows = await db.query(
      _table,
      where: 'id = ?',
      whereArgs: [id],
      limit: 1,
    );
    if (rows.isEmpty) return null;
    return Expense.fromMap(rows.first);
  }

  Future<int> updateExpense(Expense expense) async {
    final id = expense.id;
    if (id == null) {
      throw ArgumentError('Cannot update an expense that has no id.');
    }
    final db = await database;
    return db.update(
      _table,
      expense.toMap(),
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<int> deleteExpense(int id) async {
    final db = await database;
    return db.delete(_table, where: 'id = ?', whereArgs: [id]);
  }

  // ---------------------------------------------------------------------------
  // Derived queries used by Home
  // ---------------------------------------------------------------------------

  /// First instant of [month] and of the following month, used as a
  /// half-open range: `date >= start AND date < end`.
  static ({DateTime start, DateTime end}) monthRange(DateTime month) {
    return (
      start: DateTime(month.year, month.month, 1),
      end: DateTime(month.year, month.month + 1, 1),
    );
  }

  Future<double> totalForMonth(DateTime month) async {
    final db = await database;
    final range = monthRange(month);
    final result = await db.rawQuery(
      'SELECT SUM(amount) AS total FROM $_table WHERE date >= ? AND date < ?',
      [range.start.toIso8601String(), range.end.toIso8601String()],
    );
    return (result.first['total'] as num?)?.toDouble() ?? 0;
  }

  Future<int> countForMonth(DateTime month) async {
    final db = await database;
    final range = monthRange(month);
    final result = await db.rawQuery(
      'SELECT COUNT(*) AS total FROM $_table WHERE date >= ? AND date < ?',
      [range.start.toIso8601String(), range.end.toIso8601String()],
    );
    return (result.first['total'] as num?)?.toInt() ?? 0;
  }

  /// Category totals for [month], biggest first. Empty categories are omitted.
  Future<Map<ExpenseCategory, double>> categoryTotalsForMonth(
    DateTime month,
  ) async {
    final db = await database;
    final range = monthRange(month);
    final rows = await db.rawQuery(
      '''
      SELECT category, SUM(amount) AS total
      FROM $_table
      WHERE date >= ? AND date < ?
      GROUP BY category
      ORDER BY total DESC
      ''',
      [range.start.toIso8601String(), range.end.toIso8601String()],
    );
    return {
      for (final row in rows)
        ExpenseCategory.fromDb(row['category'] as String?):
            (row['total'] as num?)?.toDouble() ?? 0,
    };
  }

  Future<List<Expense>> getRecentExpenses({int limit = 5}) async {
    final db = await database;
    final rows = await db.query(
      _table,
      orderBy: 'date DESC, id DESC',
      limit: limit,
    );
    return rows.map(Expense.fromMap).toList();
  }

  /// Only used by tests and the "clear all data" action.
  Future<int> deleteAllExpenses() async {
    final db = await database;
    return db.delete(_table);
  }

  Future<void> close() async {
    await _db?.close();
    _db = null;
  }
}
