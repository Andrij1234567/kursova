import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  DatabaseHelper._internal();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'contacts_app.db');

    return openDatabase(
      path,
      version: 2,
      onCreate: (db, version) async {

        await db.execute('''
          CREATE TABLE users (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            username TEXT NOT NULL,
            password TEXT NOT NULL
          )
        ''');
        await db.execute('''
          CREATE TABLE contacts (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            userId INTEGER NOT NULL,
            firstName TEXT NOT NULL,
            lastName TEXT NOT NULL,
            phoneNumber TEXT NOT NULL,
            email TEXT NOT NULL,
            socialMedia TEXT NOT NULL,
            FOREIGN KEY (userId) REFERENCES users (id) ON DELETE CASCADE
          )
        ''');
      },
      onUpgrade: (db, oldVersion, newVersion) async {
        if (oldVersion < 2) {
          await db.execute('ALTER TABLE contacts ADD COLUMN socialMedia TEXT NOT NULL DEFAULT ""');
        }
      },
    );
  }

  // --- Методи для таблиці користувачів ---
  Future<int> insertUser(String username, String password) async {
    final db = await database;
    return await db.insert('users', {
      'username': username,
      'password': password,
    });
  }

  Future<Map<String, dynamic>?> getUser(String username, String password) async {
    final db = await database;
    final result = await db.query(
      'users',
      where: 'username = ? AND password = ?',
      whereArgs: [username, password],
    );
    return result.isNotEmpty ? result.first : null;
  }

  Future<int> insertContact({
    required int userId,
    required String firstName,
    required String lastName,
    required String phoneNumber,
    required String email,
    required String socialMedia,
  }) async {
    final db = await database;
    return await db.insert('contacts', {
      'userId': userId,
      'firstName': firstName,
      'lastName': lastName,
      'phoneNumber': phoneNumber,
      'email': email,
      'socialMedia': socialMedia,
    });
  }

  Future<List<Map<String, dynamic>>> getContactsByUser(int userId) async {
    final db = await database;
    return await db.query(
      'contacts',
      where: 'userId = ?',
      whereArgs: [userId],
    );
  }

  Future<int> updateContact({
    required int id,
    required String firstName,
    required String lastName,
    required String phoneNumber,
    required String email,
    required String socialMedia,
  }) async {
    final db = await database;
    return await db.update(
      'contacts',
      {
        'firstName': firstName,
        'lastName': lastName,
        'phoneNumber': phoneNumber,
        'email': email,
        'socialMedia': socialMedia,
      },
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<int> deleteContact(int id) async {
    final db = await database;
    return await db.delete(
      'contacts',
      where: 'id = ?',
      whereArgs: [id],
    );
  }


  // --- Метод для видалення користувача ---
  Future<int> deleteAccount(String username, String password) async {
    final db = await database;

    return await db.delete(
      'users',
      where: 'username = ? AND password = ?',
      whereArgs: [username, password],
    );
  }


}
