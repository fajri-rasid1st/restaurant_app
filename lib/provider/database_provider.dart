import 'package:flutter/foundation.dart';
import 'package:restaurant_app/data/db/favorite_database.dart';
import 'package:restaurant_app/data/models/favorite.dart';

class DatabaseProvider extends ChangeNotifier {
  final FavoriteDatabase favoriteDatabase;

  DatabaseProvider({required this.favoriteDatabase}) {
    _readFavorites();
  }

  List<Favorite> _favorites = <Favorite>[];

  List<Favorite> get favorites => _favorites;

  Future<void> _readFavorites() async {
    _favorites = await favoriteDatabase.readFavorites();
    notifyListeners();
  }

  Future<void> createFavorite(Favorite favorite) async {
    await favoriteDatabase.createFavorite(favorite);
    _readFavorites();
  }

  Future<bool> isFavoriteAlreadyExist(String restaurantId) async {
    return await favoriteDatabase.isFavoriteAlreadyExist(restaurantId);
  }

  Future<void> deleteFavoriteByRestaurantId(String restaurantId) async {
    await favoriteDatabase.deleteFavoriteByRestaurantId(restaurantId);
    _readFavorites();
  }

  Future<void> deleteFavoriteById(int id) async {
    await favoriteDatabase.deleteFavoriteById(id);
    _readFavorites();
  }

  Future<void> closeDatabase() async {
    await favoriteDatabase.close();
  }
}
