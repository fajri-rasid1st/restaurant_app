// Package imports:
import 'package:path/path.dart' as path;
import 'package:sqflite/sqflite.dart';

// Project imports:
import 'package:restaurant_app/data/models/restaurant_favorite.dart';

final class RestaurantDatabase {
  // Singleton pattern
  static final RestaurantDatabase _instance = RestaurantDatabase._internal();

  RestaurantDatabase._internal();

  factory RestaurantDatabase() => _instance;

  Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;

    return _initDb();
  }

  static const String _dbName = 'restaurant_database.db';
  static const int _dbVersion = 1;

  /// Inisialisasi, membuat, dan membuka database.
  Future<Database> _initDb() async {
    final dir = await getDatabasesPath();
    final file = path.join(dir, _dbName);
    final db = await openDatabase(
      file,
      version: _dbVersion,
      onCreate: _createDB,
    );

    _database = db;

    return db;
  }

  /// Buat tabel pada database
  Future<void> _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE IF NOT EXISTS $favoriteTable (
        ${FavoriteFields.id} INTEGER PRIMARY KEY AUTOINCREMENT,
        ${FavoriteFields.restaurantId} TEXT NOT NULL,
        ${FavoriteFields.name} TEXT NOT NULL,
        ${FavoriteFields.description} TEXT NOT NULL,
        ${FavoriteFields.pictureId} TEXT NOT NULL,
        ${FavoriteFields.city} TEXT NOT NULL,
        ${FavoriteFields.rating} REAL NOT NULL,
        ${FavoriteFields.createdAt} TEXT NOT NULL)
    ''');
  }

  /// Mengambil seluruh daftar restoran favorite dari database
  Future<List<RestaurantFavorite>> all() async {
    final db = await database;

    final result = await db.query(
      favoriteTable,
      orderBy: '${FavoriteFields.createdAt} DESC',
    );

    return List<RestaurantFavorite>.from(result.map((e) => RestaurantFavorite.fromMap(e)));
  }

  /// Menambahkan restoran favorite ke database
  Future<int> insert(RestaurantFavorite favorite) async {
    final db = await database;

    return await db.insert(favoriteTable, favorite.toMap());
  }

  /// Memeriksa apakah restoran dengan [restaurantId] sudah ada di database
  Future<bool> isExist(String restaurantId) async {
    final db = await database;

    final result = await db.query(
      favoriteTable,
      columns: [FavoriteFields.restaurantId],
      where: '${FavoriteFields.restaurantId} = ?',
      whereArgs: [restaurantId],
    );

    return result.isNotEmpty;
  }

  /// Menghapus restoran favorite dari database sesuai parameter [restaurantId]
  Future<int> delete(String restaurantId) async {
    final db = await database;

    final count = await db.delete(
      favoriteTable,
      where: '${FavoriteFields.restaurantId} = ?',
      whereArgs: [restaurantId],
    );

    return count;
  }
}
