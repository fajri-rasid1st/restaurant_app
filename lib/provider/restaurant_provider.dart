import 'package:flutter/foundation.dart';
import 'package:restaurant_app/common/result_state.dart';
import 'package:restaurant_app/data/api/restaurant_api.dart';
import 'package:restaurant_app/data/models/restaurant.dart';

class RestaurantProvider extends ChangeNotifier {
  RestaurantProvider() {
    fetchAllRestaurants();
  }

  List<Restaurant> _restaurants = <Restaurant>[];
  late ResultState _state;
  String _message = '';

  List<Restaurant> get restaurants => _restaurants;
  ResultState get state => _state;
  String get message => _message;

  set restaurants(List<Restaurant> value) {
    _restaurants = value;
    notifyListeners();
  }

  set state(ResultState value) {
    _state = value;
    notifyListeners();
  }

  /// Melukan pengambilan semua daftar restaurant
  Future<dynamic> fetchAllRestaurants() async {
    try {
      _state = ResultState.loading;

      final result = await RestaurantApi.getRestaurants();

      _restaurants = result;

      _state = ResultState.hasData;
      notifyListeners();

      return _restaurants;
    } catch (_) {
      _message = 'Gagal memuat daftar restoran. Silahkan coba lagi.';

      _state = ResultState.error;
      notifyListeners();

      return _message;
    }
  }
}
