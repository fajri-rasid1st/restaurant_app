// Flutter imports:
import 'package:flutter/foundation.dart';

// Project imports:
import 'package:restaurant_app/common/enum/result_state.dart';
import 'package:restaurant_app/data/db/restaurant_database.dart';
import 'package:restaurant_app/data/models/restaurant_favorite.dart';

class RestaurantDatabaseProvider extends ChangeNotifier {
  final RestaurantDatabase database;

  RestaurantDatabaseProvider(this.database);

  List<RestaurantFavorite> _favorites = [];
  ResultState _state = ResultState.initial;
  String _message = '';

  List<RestaurantFavorite> get favorites => _favorites;
  ResultState get state => _state;
  String get message => _message;

  /// Mengambil seluruh daftar restoran favorite
  Future<void> getAllFavorites() async {
    final result = await database.all();

    _favorites = result;

    _state = ResultState.data;
    notifyListeners();
  }

  /// Menambahkan restoran ke daftar favorite
  Future<void> addToFavorites(RestaurantFavorite favorite) async {
    await database.insert(favorite);

    _message = 'Restoran ditambahkan ke favorit';

    getAllFavorites();
  }

  /// Menghapus restoran dari daftar favorit
  Future<void> removeFromFavorites(String restaurantId) async {
    await database.delete(restaurantId);

    _message = 'Restoran dihapus dari favorit';

    getAllFavorites();
  }

  /// Mengecek apakah restoran sudah ada di daftar favorite
  Future<bool> isFavoriteAlreadyExist(String restaurantId) async {
    return await database.isExist(restaurantId);
  }
}
