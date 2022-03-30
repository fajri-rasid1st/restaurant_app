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
  late ResultState _searchState;

  late List<Restaurant> _restaurants;
  List<Restaurant> _restaurantFromSearch = <Restaurant>[];

  String _message = '';

  bool _isSearching = false;
  String _query = '';

  bool _isPageReload = false;

  ResultState get state => _state;
  ResultState get searchState => _searchState;

  List<Restaurant> get restaurants => _restaurants;
  List<Restaurant> get restaurantFromSearch => _restaurantFromSearch;

  String get message => _message;

  bool get isSearching => _isSearching;
  String get query => _query;

  bool get isPageReload => _isPageReload;

  set restaurants(List<Restaurant> value) {
    _restaurants = value;
    notifyListeners();
  }

  set isSearching(bool value) {
    _restaurantFromSearch = _restaurants;

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
  Future<dynamic> fetchAllRestaurants() async {
    try {
      _state = ResultState.loading;
      notifyListeners();

      final result = await RestaurantApi.getRestaurants();

      _state = ResultState.hasData;
      notifyListeners();

      return _restaurants = result;
    } catch (error) {
      _state = ResultState.error;
      notifyListeners();

      return _message = 'Error: $error';
    }
  }

  /// Melukan pencarian data restaurant sesuai query yang dimasukkan
  Future<dynamic> searchRestaurants(String query) async {
    try {
      _searchState = ResultState.loading;
      notifyListeners();

      final result = await RestaurantApi.getRestaurants(query);

      _query = query;
      notifyListeners();

      _searchState = ResultState.hasData;
      notifyListeners();

      return _restaurantFromSearch = result;
    } catch (error) {
      _searchState = ResultState.error;
      notifyListeners();

      return _message = 'Error: $error';
    }
  }
}
