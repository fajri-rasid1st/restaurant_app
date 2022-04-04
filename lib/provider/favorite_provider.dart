import 'package:flutter/material.dart';
import 'package:restaurant_app/common/result_state.dart';

class FavoriteProvider extends ChangeNotifier {
  ResultState _state = ResultState.loading;
  late Icon _icon;
  late bool _isFavorite;

  ResultState get state => _state;
  Icon get icon => _icon;
  bool get isFavorite => _isFavorite;

  set state(ResultState value) {
    _state = value;
    notifyListeners();
  }

  set icon(Icon value) {
    _icon = value;
    notifyListeners();
  }

  set isFavorite(bool value) {
    _isFavorite = value;
    notifyListeners();
  }
}
