import 'package:flutter/foundation.dart';
import 'package:restaurant_app/common/result_state.dart';
import 'package:restaurant_app/data/db/favorite_database.dart';
import 'package:restaurant_app/data/models/favorite.dart';

class DatabaseProvider extends ChangeNotifier {
  final FavoriteDatabase favoriteDatabase;

  DatabaseProvider({required this.favoriteDatabase}) {
    _readFavorites();
  }

  late ResultState _state;
  List<Favorite> _favorites = <Favorite>[];

  ResultState get state => _state;
  List<Favorite> get favorites => _favorites;

  Future<void> _readFavorites() async {
    _state = ResultState.loading;

    _favorites = await favoriteDatabase.readFavorites();

    _state = ResultState.hasData;
    notifyListeners();
  }

  /// Menambahkan restaurant [favorite]
  Future<void> createFavorite(Favorite favorite) async {
    await favoriteDatabase.createFavorite(favorite);
    _readFavorites();
  }

  /// Menghapus restaurant sesuai [restaurantId]
  Future<void> deleteFavoriteByRestaurantId(String restaurantId) async {
    await favoriteDatabase.deleteFavoriteByRestaurantId(restaurantId);
    _readFavorites();
  }

  /// Menghapus restaurant sesuai [id]
  Future<void> deleteFavoriteById(int id) async {
    await favoriteDatabase.deleteFavoriteById(id);
    _readFavorites();
  }

  /// Mengecek apakah favorite dengan id [restaurantId] terdapat di database
  Future<bool> isFavoriteAlreadyExist(String restaurantId) async {
    return await favoriteDatabase.isFavoriteAlreadyExist(restaurantId);
  }
}
