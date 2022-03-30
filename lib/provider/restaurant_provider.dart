import 'package:flutter/foundation.dart';
import 'package:restaurant_app/data/api/restaurant_api.dart';
import 'package:restaurant_app/data/models/restaurant.dart';

enum ResultState { loading, error, hasData }

class RestaurantProvider extends ChangeNotifier {
  // Inisialisisi restaurant API service
  final RestaurantApi restaurantApi;

  RestaurantProvider({required this.restaurantApi}) {
    fetchAllRestaurants();
  }

  late ResultState _state;
  late List<Restaurant> _restaurants;

  bool _isSearching = false;
  String _query = '';
  bool _isPageReload = false;

  ResultState get state => _state;
  List<Restaurant> get restaurants => _restaurants;
  bool get isSearching => _isSearching;
  String get query => _query;
  bool get isPageReload => _isPageReload;

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

  set isPageReload(bool value) {
    _isPageReload = value;
    notifyListeners();
  }

  /// Melukan pengambilan semua data restaurant
  Future<List<Restaurant>> fetchAllRestaurants() async {
    try {
      _state = ResultState.loading;
      notifyListeners();

      final result = await RestaurantApi.getRestaurants();

      _state = ResultState.hasData;
      notifyListeners();

      return _restaurants = result;
    } catch (e) {
      _state = ResultState.error;
      notifyListeners();

      throw Exception(e.toString());
    }
  }

  /// Melukan pencarian data restaurant sesuai query yang dimasukkan
  Future<List<Restaurant>> searchRestaurants(String query) async {
    try {
      _state = ResultState.loading;
      notifyListeners();

      final result = await RestaurantApi.getRestaurants(query);

      _query = query;

      _state = ResultState.hasData;
      notifyListeners();

      return _restaurants = result;
    } catch (e) {
      _state = ResultState.error;
      notifyListeners();

      throw Exception(e);
    }
  }
}
