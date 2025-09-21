import 'package:flutter/foundation.dart';
import 'package:restaurant_app/common/enum/result_state.dart';
import 'package:restaurant_app/data/db/restaurant_database.dart';
import 'package:restaurant_app/data/models/restaurant_favorite.dart';

class RestaurantDatabaseProvider extends ChangeNotifier {
  final RestaurantDatabase database;

  RestaurantDatabaseProvider(this.database);

  List<RestaurantFavorite> _restaurants = [];
  ResultState _state = ResultState.initial;

  List<RestaurantFavorite> get restaurants => _restaurants;
  ResultState get state => _state;

  /// Mengambil seluruh daftar restoran favorite
  Future<void> getAllFavorites() async {
    _restaurants = await database.all();

    _state = ResultState.data;
    notifyListeners();
  }

  /// Menambahkan restoran ke daftar favorite
  Future<void> addToFavorites(RestaurantFavorite favorite) async {
    await database.insert(favorite);

    getAllFavorites();
  }

  /// Menghapus restoran dari daftar favorit
  Future<void> removeFromFavorites(String restaurantId) async {
    await database.delete(restaurantId);

    getAllFavorites();
  }

  /// Mengecek apakah restoran sudah ada di daftar favorite
  Future<bool> isFavoriteAlreadyExist(String restaurantId) async {
    return await database.isExist(restaurantId);
  }
}
