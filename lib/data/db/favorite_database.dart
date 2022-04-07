import 'package:restaurant_app/data/models/favorite.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class FavoriteDatabase {
  static FavoriteDatabase? _favoriteDatabase;

  FavoriteDatabase._internal() {
    _favoriteDatabase = this;
  }

  factory FavoriteDatabase() {
    return _favoriteDatabase ?? FavoriteDatabase._internal();
  }

  static late Database _database;

  Future<Database> get database async {
    _database = await _initializeDb('favorite_database.db');

    return _database;
  }

  /// Inisialisasi, membuat, dan membuka database
  Future<Database> _initializeDb(String file) async {
    final databasesPath = await getDatabasesPath();
    final path = join(databasesPath, file);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  /// Buat tabel database
  Future<void> _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $favoriteTable (
        ${FavoriteFields.id} INTEGER PRIMARY KEY AUTOINCREMENT,
        ${FavoriteFields.restaurantId} TEXT NOT NULL,
        ${FavoriteFields.name} TEXT NOT NULL,
        ${FavoriteFields.pictureId} TEXT NOT NULL,
        ${FavoriteFields.city} TEXT NOT NULL,
        ${FavoriteFields.rating} REAL NOT NULL,
        ${FavoriteFields.createdAt} TEXT NOT NULL)
    ''');
  }

  /// Menampilkan seluruh favorite list yang disimpan dalam database
  Future<List<Favorite>> readFavorites() async {
    final db = await database;

    final maps = await db.query(
      favoriteTable,
      orderBy: '${FavoriteFields.createdAt} DESC',
    );

    if (maps.isNotEmpty) {
      final favorites = List<Favorite>.from(
        maps.map((favorite) => Favorite.fromMap(favorite)),
      );

      return favorites;
    }

    return <Favorite>[];
  }

  /// Membuat record favorite dan memasukkannya ke database
  Future<Favorite> createFavorite(Favorite favorite) async {
    final db = await database;

    final id = await db.insert(favoriteTable, favorite.toMap());

    return favorite.copyWith(id: id);
  }

  /// Mengecek baris pada table database yang sesuai dengan [restaurantId]
  Future<bool> isFavoriteAlreadyExist(String restaurantId) async {
    final db = await database;

    final maps = await db.query(
      favoriteTable,
      columns: [FavoriteFields.restaurantId],
      where: '${FavoriteFields.restaurantId} = ?',
      whereArgs: [restaurantId],
    );

    if (maps.isNotEmpty) return Future.value(true);

    return Future.value(false);
  }

  /// Menghapus baris pada table database sesuai parameter [restaurantId]
  Future<int> deleteFavoriteByRestaurantId(String restaurantId) async {
    final db = await database;

    final count = await db.delete(
      favoriteTable,
      where: '${FavoriteFields.restaurantId} = ?',
      whereArgs: [restaurantId],
    );

    return count;
  }

  /// Menghapus baris pada table database sesuai parameter [id]
  Future<int> deleteFavoriteById(int id) async {
    final db = await database;

    final count = await db.delete(
      favoriteTable,
      where: '${FavoriteFields.id} = ?',
      whereArgs: [id],
    );

    return count;
  }
}
