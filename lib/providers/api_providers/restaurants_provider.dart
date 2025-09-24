// Flutter imports:
import 'package:flutter/foundation.dart';

// Project imports:
import 'package:restaurant_app/common/enum/result_state.dart';
import 'package:restaurant_app/data/api/restaurant_api.dart';
import 'package:restaurant_app/data/db/restaurant_database.dart';
import 'package:restaurant_app/data/models/restaurant.dart';

class RestaurantsProvider extends ChangeNotifier {
  final RestaurantApi apiService;
  final RestaurantDatabase databaseService;

  RestaurantsProvider({
    required this.apiService,
    required this.databaseService,
  });

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
      final result = await apiService.getRestaurants(query);

      for (var i = 0; i < result.length; i++) {
        final isFavorited = await databaseService.isExist(result[i].id);

        result[i] = result[i].copyWith(isFavorited: isFavorited);
      }

      _restaurants = result;

      _state = ResultState.data;
    } catch (e) {
      _message = 'Gagal memuat daftar restoran. Silahkan coba lagi.';

      _state = ResultState.error;
    }

    notifyListeners();
  }
}
