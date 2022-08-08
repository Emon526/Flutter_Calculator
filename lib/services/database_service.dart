import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../models/history_model.dart';

class DatabaseService {
  // Singleton pattern
  static final DatabaseService _databaseService = DatabaseService._internal();
  factory DatabaseService() => _databaseService;
  DatabaseService._internal();

  static Database? _database;
  Future<Database> get database async {
    if (_database != null) return _database!;
    // Initialize the DB first time it is accessed
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final databasePath = await getDatabasesPath();

    // Set the path to the database. Note: Using the `join` function from the
    // `path` package is best practice to ensure the path is correctly
    // constructed for each platform.
    final path = join(databasePath, 'database.db');

    // Set the version. This executes the onCreate function and provides a
    // path to perform database upgrades and downgrades.
    return await openDatabase(
      path,
      onCreate: _onCreate,
      version: 1,
      onConfigure: (db) async => await db.execute('PRAGMA foreign_keys = ON'),
    );
  }

  // When the database is first created, create a table to store history

  Future<void> _onCreate(Database db, int version) async {
    // Run the CREATE {historys} TABLE statement on the database.
    await db.execute(
      'CREATE TABLE history(id INTEGER PRIMARY KEY, userinput TEXT, answer TEXT)',
    );
  }

  // Define a function that inserts history into the database
  Future<void> insertHistory(HistoryModel history) async {
    // Get a reference to the database.
    final db = await _databaseService.database;

    // Insert the history into the correct table. You might also specify the
    // `conflictAlgorithm` to use in case the same history is inserted twice.
    //
    // In this case, replace any previous data.
    await db.insert(
      'history',
      history.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // A method that retrieves all the history from the history table.
  Future<List<HistoryModel>> histories() async {
    // Get a reference to the database.
    final db = await _databaseService.database;

    // Query the table for all the history.
    final List<Map<String, dynamic>> maps = await db.query('history');

    return List.generate(
        maps.length, (index) => HistoryModel.fromMap(maps[index]));
  }

  Future<HistoryModel> history(int id) async {
    final db = await _databaseService.database;
    final List<Map<String, dynamic>> maps =
        await db.query('history', where: 'id = ?', whereArgs: [id]);
    return HistoryModel.fromMap(maps[0]);
  }

  // A method that deletes a history data from the history table.
  Future<void> deleteHistory(int id) async {
    // Get a reference to the database.
    final db = await _databaseService.database;

    // Remove the history from the database.
    await db.delete(
      'history',
      // Use a `where` clause to delete a specific history.
      where: 'id = ?',
      // Pass the history's id as a whereArg to prevent SQL injection.
      whereArgs: [id],
    );
  }

  // A method that deletes a history data from the history table.
  Future<void> clearHistory() async {
    // Get a reference to the database.
    final db = await _databaseService.database;

    // Remove the history from the database.
    await db.delete(
      'history',
      // Use a `where` clause to delete a specific history.

      // Pass the history's id as a whereArg to prevent SQL injection.
    );
  }
}
