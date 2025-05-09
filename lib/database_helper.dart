import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:flutter/foundation.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  static Database? _database;

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'goats.db');
    return await openDatabase(
      path,
      version: 3, // Increment version to trigger onUpgrade
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      await db.execute('''
        CREATE TABLE Finance (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          category TEXT,
          amount REAL,
          type TEXT,
          date INTEGER
        )
      ''');
    }
    if (oldVersion < 3) {
      await db.execute('''
        CREATE TABLE Users (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          email TEXT UNIQUE,
          password TEXT,
          fullName TEXT
        )
      ''');
    }
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE Boers (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        goatType TEXT,
        breed TEXT,
        goatTag TEXT UNIQUE,
        weight TEXT,
        dateOfBirth TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE SickBoers (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        goatType TEXT,
        breed TEXT,
        goatTag TEXT UNIQUE,
        weight TEXT,
        dateOfBirth TEXT
      )
    ''');
    await db.execute('''
      CREATE TABLE SoldBoers (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        goatType TEXT,
        goatTag TEXT UNIQUE,
        weight TEXT,
        price TEXT
      )
    ''');
    await db.execute('''
      CREATE TABLE BoersonSale (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        goatType TEXT,
        goatTag TEXT UNIQUE,
        weight TEXT,
        price TEXT
      )
    ''');
    await db.execute('''
      CREATE TABLE BoerBreeds (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        doeId TEXT,
        buckId TEXT,
        expectedDOB TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE Finance (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        category TEXT,
        amount REAL,
        type TEXT,
        date INTEGER
      )
    ''');

    await db.execute('''
      CREATE TABLE Users (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        email TEXT UNIQUE,
        password TEXT,
        fullName TEXT
      )
    ''');
  }

  // User Table Operations

  Future<int> insertUser(Map<String, dynamic> user) async {
    Database db = await database;
    return await db.insert('Users', user);
  }

  Future<Map<String, dynamic>?> getUserByEmail(String email) async {
    Database db = await database;
    List<Map<String, dynamic>> users = await db.query(
      'Users',
      where: 'email = ?',
      whereArgs: [email],
    );
    if (users.isNotEmpty) {
      return users.first;
    }
    return null;
  }

  // Finance Table Operations
  Future<int> insertTransaction(Map<String, dynamic> transaction) async {
    Database db = await database;
    return await db.insert('Finance', transaction);
  }

  Future<List<Map<String, dynamic>>> getTransactions({
    String? type,
    String? category,
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    Database db = await database;
    String whereClause = '';
    List<dynamic> whereArgs = [];

    if (type != null && type != 'All') {
      whereClause += 'type = ?';
      whereArgs.add(type);
    }

    if (category != null && category != 'All Categories') {
      if (whereClause.isNotEmpty) whereClause += ' AND ';
      whereClause += 'category = ?';
      whereArgs.add(category);
    }

    if (startDate != null && endDate != null) {
      if (whereClause.isNotEmpty) whereClause += ' AND ';
      whereClause += 'date >= ? AND date <= ?';
      whereArgs.addAll([
        startDate.millisecondsSinceEpoch,
        endDate.millisecondsSinceEpoch,
      ]);
    } else if (startDate != null) {
      if (whereClause.isNotEmpty) whereClause += ' AND ';
      whereClause += 'date >= ?';
      whereArgs.add(startDate.millisecondsSinceEpoch);
    } else if (endDate != null) {
      if (whereClause.isNotEmpty) whereClause += ' AND ';
      whereClause += 'date <= ?';
      whereArgs.add(endDate.millisecondsSinceEpoch);
    }

    return await db.query(
      'Finance',
      where: whereClause.isNotEmpty ? whereClause : null,
      whereArgs: whereArgs.isNotEmpty ? whereArgs : null,
      orderBy: 'date DESC',
    );
  }

  // Boer Table Operations
  Future<int> insertGoat(Map<String, dynamic> goat) async {
    Database db = await database;
    return await db.insert('Boers', goat);
  }

  Future<List<Map<String, dynamic>>> getGoats() async {
    Database db = await database;
    return await db.query('Boers');
  }

  Future<List<Map<String, dynamic>>> searchGoat(
    String breed,
    String type,
    String tag,
  ) async {
    Database db = await database;
    return await db.query(
      'Boers',
      where: 'breed = ? AND goatType = ? AND goatTag = ?',
      whereArgs: [breed, type, tag],
    );
  }

  Future<int> updateGoat(String goatTag, Map<String, dynamic> goat) async {
    Database db = await database;
    return await db.update(
      'Boers',
      goat,
      where: 'goatTag = ?',
      whereArgs: [goatTag],
    );
  }

  Future<int> deleteGoat(String goatTag) async {
    Database db = await database;
    return await db.delete('Boers', where: 'goatTag = ?', whereArgs: [goatTag]);
  }

  // SickBoers Table Operations
  Future<int> insertSickGoat(Map<String, dynamic> goat) async {
    Database db = await database;
    return await db.insert('SickBoers', goat);
  }

  Future<List<Map<String, dynamic>>> getSickGoats() async {
    Database db = await database;
    return await db.query('SickBoers');
  }

  // SoldBoers Table Operations
  Future<int> insertSoldGoat(Map<String, dynamic> goat) async {
    Database db = await database;
    return await db.insert('SoldBoers', goat);
  }

  Future<int> deleteSoldGoat(String goatTag) async {
    Database db = await database;
    return await db.delete(
      'SoldBoers',
      where: 'goatTag = ?',
      whereArgs: [goatTag],
    );
  }

  Future<bool> checkSoldGoatExists(String goatTag) async {
    final db = await database;
    final result = await db.query(
      'SoldBoers',
      where: 'goatTag = ?',
      whereArgs: [goatTag],
    );
    return result.isNotEmpty;
  }

  Future<List<Map<String, dynamic>>> getSoldGoats() async {
    Database db = await database;
    return await db.query('SoldBoers');
  }

  // BoersonSale Table Operations
  Future<int> insertBoersonSale(Map<String, dynamic> goat) async {
    Database db = await database;
    return await db.insert('BoersonSale', goat);
  }

  // BoerBreeds Table Operations
  Future<int> insertBoerBreeds(Map<String, dynamic> row) async {
    final db = await database;
    try {
      int result = await db.insert('BoerBreeds', row);
      if (result == 0) {
        throw Exception('Failed to insert breeding record');
      }
      return result;
    } catch (e) {
      throw Exception('Failed to insert breeding record: $e');
    }
  }

  Future<List<Map<String, dynamic>>> getBreedingRecords() async {
    Database db = await database;
    return await db.query('BoerBreeds');
  }

  Future<List<Map<String, dynamic>>> searchGoats({
    String? breed,
    String? goatType,
    String? goatTag,
  }) async {
    final db = await database;
    final tables = ['Boers', 'SickBoers', 'BoersonSale', 'SoldBoers'];
    final results = <Map<String, dynamic>>[];

    for (final table in tables) {
      try {
        var query = 'SELECT * FROM $table';
        final whereClauses = <String>[];
        final whereArgs = <dynamic>[];

        if (breed != null && breed.isNotEmpty) {
          whereClauses.add('breed = ?');
          whereArgs.add(breed);
        }

        if (goatType != null && goatType.isNotEmpty) {
          whereClauses.add('goatType = ?');
          whereArgs.add(goatType);
        }

        if (goatTag != null && goatTag.isNotEmpty) {
          whereClauses.add('goatTag = ?');
          whereArgs.add(goatTag);
        }

        if (whereClauses.isNotEmpty) {
          query += ' WHERE ${whereClauses.join(' AND ')}';
        }

        final tableResults = await db.rawQuery(query, whereArgs);

        for (final goat in tableResults) {
          goat['status'] = _getStatusFromTable(table);
          results.add(goat);
        }
      } catch (e) {
        debugPrint('Error searching table $table: $e');
      }
    }

    return results;
  }

  Future<List<Map<String, dynamic>>> getAllGoats() async {
    final db = await database;
    final tables = ['Boers', 'SickBoers', 'BoersonSale', 'SoldBoers'];
    final results = <Map<String, dynamic>>[];

    for (final table in tables) {
      try {
        final tableResults = await db.query(table);
        for (final goat in tableResults) {
          goat['status'] = _getStatusFromTable(table);
          results.add(goat);
        }
      } catch (e) {
        debugPrint('Error fetching from table $table: $e');
      }
    }

    return results;
  }

  String _getStatusFromTable(String tableName) {
    switch (tableName) {
      case 'SickBoers':
        return 'Sick';
      case 'BoersonSale':
        return 'On Sale';
      case 'SoldBoers':
        return 'Sold';
      case 'Boers':
      default:
        return 'Healthy';
    }
  }

  Future<bool> checkGoatExists(String goatTag) async {
    final db = await database;
    final tables = ['Boers', 'SickBoers', 'BoersonSale', 'SoldBoers'];

    for (final table in tables) {
      final result = await db.query(
        table,
        where: 'goatTag = ?',
        whereArgs: [goatTag],
      );
      if (result.isNotEmpty) return true;
    }
    return false;
  }

  Future<List<Map<String, dynamic>>> getGoatHistory(String goatTag) async {
    final db = await database;
    final tables = ['Boers', 'SickBoers', 'BoersonSale', 'SoldBoers'];
    final history = <Map<String, dynamic>>[];

    for (final table in tables) {
      final result = await db.query(
        table,
        where: 'goatTag = ?',
        whereArgs: [goatTag],
      );
      if (result.isNotEmpty) {
        for (var record in result) {
          record['tableSource'] = table;
          history.add(record);
        }
      }
    }

    return history;
  }
}
