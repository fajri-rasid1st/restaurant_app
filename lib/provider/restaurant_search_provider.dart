import 'package:flutter/foundation.dart';
import 'package:restaurant_app/common/result_state.dart';
import 'package:restaurant_app/data/api/restaurant_api.dart';
import 'package:restaurant_app/data/models/restaurant.dart';

class RestaurantSearchProvider extends ChangeNotifier {
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

  /// Melukan pencarian data restaurant sesuai query yang dimasukkan
  Future<dynamic> searchRestaurants(String query) async {
    try {
      _state = ResultState.loading;
      notifyListeners();

      final result = await RestaurantApi.getRestaurants(query);

      _query = query;
      _restaurants = result;
      _state = ResultState.hasData;
      notifyListeners();

      return result;
    } catch (_) {
      _message = 'Gagal mencari restoran. Silahkan coba lagi.';

      return _message;
    }
  }
}
