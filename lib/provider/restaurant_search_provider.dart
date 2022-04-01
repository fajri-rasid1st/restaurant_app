import 'package:flutter/foundation.dart';
import 'package:restaurant_app/data/api/restaurant_api.dart';
import 'package:restaurant_app/data/models/restaurant.dart';

class RestaurantSearchProvider extends ChangeNotifier {
  late List<Restaurant> _restaurants;
  late String _message;

  bool _isSearching = false;
  String _query = '';

  List<Restaurant> get restaurants => _restaurants;
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
      final result = await RestaurantApi.getRestaurants(query);

      _query = query;
      notifyListeners();

      return _restaurants = result;
    } catch (error) {
      notifyListeners();

      _message = 'Gagal memuat detail restoran. Silahkan coba lagi.';
      return _message;
    }
  }
}
