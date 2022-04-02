import 'package:flutter/foundation.dart';
import 'package:restaurant_app/common/result_state.dart';
import 'package:restaurant_app/data/api/restaurant_api.dart';
import 'package:restaurant_app/data/models/restaurant_detail.dart';

class RestaurantDetailProvider extends ChangeNotifier {
  final RestaurantApi restaurantApi;

  RestaurantDetailProvider({required this.restaurantApi});

  late RestaurantDetail _detail;
  late ResultState _state;
  String _message = '';

  RestaurantDetail get detail => _detail;
  ResultState get state => _state;
  String get message => _message;

  set detail(RestaurantDetail value) {
    _detail = value;
    notifyListeners();
  }

  set state(ResultState value) {
    _state = value;
    notifyListeners();
  }

  /// Melukan pengambilan data detail restauran sesuai id
  Future<dynamic> getRestaurantDetail(String id) async {
    try {
      _state = ResultState.loading;

      final result = await restaurantApi.getRestaurantDetail(id);

      _detail = result;

      _state = ResultState.hasData;
      notifyListeners();

      return _detail;
    } catch (_) {
      _message = 'Gagal memuat detail restoran. Silahkan coba lagi.';

      _state = ResultState.error;
      notifyListeners();

      return _message;
    }
  }
}
