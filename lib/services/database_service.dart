import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/user_model.dart';

class DatabaseService {
  static final DatabaseService instance = DatabaseService._init();
  DatabaseService._init();

  static Database? _database;
  static const int maxRetries = 3;
  static const Duration timeoutDuration = Duration(seconds: 15);
  static const String _databaseName = "UserDB.db";
  static const int _databaseVersion = 1;

  // Table constants
  static const String table = 'users';
  static const String columnId = 'id';
  static const String columnName = 'name';
  static const String columnEmail = 'email';
  static const String columnPassword = 'password';

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    int retryCount = 0;
    while (retryCount < maxRetries) {
      try {
        if (kIsWeb) {
          // Pastikan databaseFactory sudah diinisialisasi untuk web
          if (databaseFactory == null) {
            throw DatabaseException('Database factory not initialized for web');
          }
          return await databaseFactory
              .openDatabase(
                inMemoryDatabasePath,
                options: OpenDatabaseOptions(
                  version: _databaseVersion,
                  onCreate: _onCreate,
                ),
              )
              .timeout(timeoutDuration);
        } else {
          final String path = join(await getDatabasesPath(), _databaseName);
          return await openDatabase(
            path,
            version: _databaseVersion,
            onCreate: _onCreate,
          ).timeout(timeoutDuration);
        }
      } on TimeoutException catch (e) {
        retryCount++;
        if (retryCount >= maxRetries) {
          throw DatabaseException(
              'Database initialization failed after $maxRetries attempts: ${e.toString()}');
        }
        await Future.delayed(Duration(seconds: 1));
      } catch (e) {
        // Improve error logging
        print('Database initialization error: ${e.toString()}');
        throw DatabaseException(
            'Failed to initialize database: ${e.toString()}');
      }
    }
    throw DatabaseException('Database initialization failed');
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $table (
        $columnId INTEGER PRIMARY KEY AUTOINCREMENT,
        $columnName TEXT NOT NULL,
        $columnEmail TEXT NOT NULL UNIQUE,
        $columnPassword TEXT NOT NULL
      )
    ''');
    await db.execute('CREATE INDEX email_index ON $table ($columnEmail)');
  }

  Future<void> closeDatabase() async {
    final db = _database;
    if (db != null && db.isOpen) {
      await db.close();
      _database = null;
    }
  }

  // CRUD Operations
  Future<int> insertUser(User user) async {
    try {
      Database db = await database;
      final result = await db.insert(table, user.toMap());
      return result;
    } catch (e) {
      throw DatabaseException('Failed to insert user: ${e.toString()}');
    }
  }

  Future<User?> getUserByEmail(String email) async {
    try {
      Database db = await database;
      final List<Map<String, dynamic>> results = await db.query(
        table,
        where: '$columnEmail = ?',
        whereArgs: [email],
      ).timeout(timeoutDuration);

      return results.isNotEmpty ? User.fromMap(results.first) : null;
    } catch (e) {
      throw DatabaseException('Error getting user by email: ${e.toString()}');
    }
  }

  Future<List<User>> getAllUsers() async {
    try {
      Database db = await database;
      List<Map<String, dynamic>> maps = await db.query(table);
      return List.generate(maps.length, (i) => User.fromMap(maps[i]));
    } catch (e) {
      throw DatabaseException('Error getting all users: ${e.toString()}');
    }
  }

  // Tambahkan method untuk validasi email
  Future<bool> isEmailExists(String email) async {
    try {
      final user = await getUserByEmail(email);
      return user != null;
    } catch (e) {
      throw DatabaseException('Error checking email: ${e.toString()}');
    }
  }
}

class DatabaseException implements Exception {
  final String message;
  DatabaseException(this.message);

  @override
  String toString() => message;
}
