import 'package:flutter/foundation.dart';
import 'package:restaurant_app/common/result_state.dart';
import 'package:restaurant_app/data/api/restaurant_api.dart';
import 'package:restaurant_app/data/models/restaurant.dart';

class RestaurantSearchProvider extends ChangeNotifier {
  final RestaurantApi restaurantApi;

  RestaurantSearchProvider({required this.restaurantApi});

  List<Restaurant> _restaurants = <Restaurant>[];
  ResultState _state = ResultState.hasData;
  String _message = '';

  bool _isSearching = false;
  String _query = '';

  List<Restaurant> get restaurants => _restaurants;
  ResultState get state => _state;
  String get message => _message;

  bool get isSearching => _isSearching;
  String get query => _query;

  set restaurants(List<Restaurant> value) {
    _restaurants = value;
    notifyListeners();
  }

  set isSearching(bool value) {
    _isSearching = value;
    notifyListeners();
  }

  set query(String value) {
    _query = value;
    notifyListeners();
  }

  /// Melukan pencarian data restaurant sesuai query yang dimasukkan
  Future<dynamic> searchRestaurants(String query) async {
    try {
      _state = ResultState.loading;

      _query = query;

      final result = await restaurantApi.getRestaurants(query);

      _restaurants = result;

      _state = ResultState.hasData;
      notifyListeners();

      return _restaurants;
    } catch (_) {
      _message = 'Gagal mencari restoran. Silahkan coba lagi.';

      _state = ResultState.error;
      notifyListeners();

      return _message;
    }
  }
}
