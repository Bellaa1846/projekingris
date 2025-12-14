import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDB("app.db");
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE profile (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        birthDate TEXT NOT NULL,
        photoPath TEXT
      )
    ''');

    // insert default sample profile
    await db.insert("profile", {
      "name": "Mysterious User",
      "birthDate": "2000-01-01",
      "photoPath": "",
    });

    //Buat tabel achivment
    await db.execute('''
      CREATE TABLE achievements (
        id INTEGER PRIMARY KEY,
        unlocked INTEGER
      )
    ''');

    // // uji coba achivment
    // await db.insert("achievements", {
    //   "id": 4,
    //   "unlocked": 1,
    // });
  }

  Future<Map<String, dynamic>?> getProfile() async {
    final db = await database;
    final res = await db.query("profile", limit: 1);
    return res.isNotEmpty ? res.first : null;
  }

  Future<void> updateProfile(
    String name,
    String birthDate,
    String photoPath,
  ) async {
    final db = await database;
    await db.update(
      "profile",
      {"name": name, "birthDate": birthDate, "photoPath": photoPath},
      where: "id = ?",
      whereArgs: [1],
    );
  }
}
