import 'package:flutter/foundation.dart';
import 'package:restaurant_app/common/enum/result_state.dart';
import 'package:restaurant_app/data/services/restaurant_api_service.dart';
import 'package:restaurant_app/data/models/restaurant_detail.dart';

class RestaurantDetailProvider extends ChangeNotifier {
  final RestaurantApiService service;

  RestaurantDetailProvider(this.service);

  RestaurantDetail? _restaurantDetail;
  ResultState _state = ResultState.initial;
  String _message = '';

  RestaurantDetail? get restaurantDetail => _restaurantDetail;
  ResultState get state => _state;
  String get message => _message;

  /// Set data detail restoran
  set restaurantDetail(RestaurantDetail? restaurantDetail) {
    _restaurantDetail = restaurantDetail;
    notifyListeners();
  }

  /// Mengambil data detail restoran sesuai [id]-nya
  Future<void> getRestaurantDetail(String id) async {
    _state = ResultState.loading;
    notifyListeners();

    try {
      final result = await service.getRestaurantDetail(id);

      _restaurantDetail = result;

      _state = ResultState.data;
    } catch (e) {
      debugPrint('getRestaurantDetail error: ${e.toString()}');

      _message = 'Gagal memuat detail restoran. Error: ${e.toString()}';

      _state = ResultState.error;
    }

    notifyListeners();
  }
}
