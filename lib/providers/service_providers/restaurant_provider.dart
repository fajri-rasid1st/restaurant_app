import 'package:flutter/foundation.dart';
import 'package:restaurant_app/common/enum/result_state.dart';
import 'package:restaurant_app/data/services/restaurant_api_service.dart';
import 'package:restaurant_app/data/models/restaurant.dart';

class RestaurantProvider extends ChangeNotifier {
  final RestaurantApiService service;

  RestaurantProvider({required this.service});

  List<Restaurant> _restaurants = [];
  ResultState _state = ResultState.initial;
  String _message = '';

  List<Restaurant> get restaurants => _restaurants;
  ResultState get state => _state;
  String get message => _message;

  /// Mengambil daftar semua restoran
  Future<void> getRestaurants([String? query]) async {
    _state = ResultState.loading;
    notifyListeners();

    try {
      final result = await service.getRestaurants(query);

      _restaurants = result;

      _state = ResultState.data;
    } catch (e) {
      debugPrint('getRestaurants error: ${e.toString()}');

      _message = 'Gagal memuat daftar restoran. Silahkan coba lagi.';

      _state = ResultState.error;
    }

    notifyListeners();
  }
}
