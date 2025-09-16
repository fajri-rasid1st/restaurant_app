import 'package:flutter/foundation.dart';
import 'package:restaurant_app/common/enum/restaurant_category.dart';

/// Provider untuk mengatur state kategori restoran yang dipilih
class SelectedCategoryProvider extends ChangeNotifier {
  RestaurantCategory _value = RestaurantCategory.all;

  RestaurantCategory get value => _value;

  set value(RestaurantCategory newValue) {
    if (_value == newValue) return;

    _value = newValue;
    notifyListeners();
  }
}
