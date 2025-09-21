// Flutter imports:
import 'package:flutter/foundation.dart';

// Project imports:
import 'package:restaurant_app/common/enum/result_state.dart';
import 'package:restaurant_app/data/models/restaurant.dart';
import 'package:restaurant_app/data/api/restaurant_api.dart';

class RestaurantsProvider extends ChangeNotifier {
  final RestaurantApi service;

  RestaurantsProvider(this.service);

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
      _message = 'Gagal memuat daftar restoran. Silahkan coba lagi.';

      _state = ResultState.error;
    }

    notifyListeners();
  }
}
