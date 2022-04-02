import 'package:flutter/foundation.dart';
import 'package:restaurant_app/data/db/favorite_database.dart';
import 'package:restaurant_app/data/models/favorite.dart';

class DatabaseProvider extends ChangeNotifier {
  late FavoriteDatabase _favoriteDatabase;

  List<Favorite> _favorites = <Favorite>[];

  List<Favorite> get favorites => _favorites;

  DatabaseProvider() {
    _favoriteDatabase = FavoriteDatabase();
    _readFavorites();
  }

  void _readFavorites() async {
    _favorites = await _favoriteDatabase.readFavorites();
    notifyListeners();
  }
}
