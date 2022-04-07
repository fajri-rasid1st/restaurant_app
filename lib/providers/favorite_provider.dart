import 'package:flutter/material.dart';
import 'package:restaurant_app/data/db/favorite_database.dart';
import 'package:restaurant_app/ui/themes/color_scheme.dart';

class FavoriteProvider extends ChangeNotifier {
  final FavoriteDatabase favoriteDatabase;

  FavoriteProvider({required this.favoriteDatabase});

  late Icon _icon;
  late bool _isFavorite;

  Icon get icon => _icon;
  bool get isFavorite => _isFavorite;

  set icon(Icon value) {
    _icon = value;
    notifyListeners();
  }

  set isFavorite(bool value) {
    _isFavorite = value;
    notifyListeners();
  }

  /// Menyetel jenis icon yang akan muncul pada halaman detail
  Future<void> setFavoriteIconButton(String restaurantId) async {
    final isExist = await favoriteDatabase.isFavoriteAlreadyExist(restaurantId);

    if (isExist) {
      _icon = Icon(Icons.favorite, color: Colors.red[400]);
      _isFavorite = true;
    } else {
      _icon = Icon(Icons.favorite_outline, color: backGroundColor);
      _isFavorite = false;
    }
  }
}
