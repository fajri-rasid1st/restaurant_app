// Flutter imports:
import 'package:flutter/foundation.dart';

// Project imports:
import 'package:restaurant_app/common/enum/result_state.dart';
import 'package:restaurant_app/data/models/restaurant_detail.dart';
import 'package:restaurant_app/data/api/restaurant_api.dart';

class RestaurantDetailProvider extends ChangeNotifier {
  final RestaurantApi service;

  RestaurantDetailProvider(this.service);

  RestaurantDetail? restaurantDetail;
  ResultState _state = ResultState.initial;
  String _message = '';

  ResultState get state => _state;
  String get message => _message;

  /// Mengambil data detail restoran sesuai [id]-nya
  Future<void> getRestaurantDetail(String id) async {
    _state = ResultState.loading;
    notifyListeners();

    try {
      final result = await service.getRestaurantDetail(id);

      restaurantDetail = result;

      _state = ResultState.data;
    } catch (e) {
      _message = 'Gagal memuat detail restoran. Silahkan coba lagi.';

      _state = ResultState.error;
    }

    notifyListeners();
  }

  /// Mengirim data review restaurant
  Future<void> sendCustomerReview({
    required String id,
    required String name,
    required String review,
  }) async {
    _state = ResultState.loading;
    notifyListeners();

    try {
      final result = await service.sendCustomerReview(
        id: id,
        name: name,
        review: review,
      );

      if (restaurantDetail != null) {
        restaurantDetail = restaurantDetail!.copyWith(customerReviews: result);
      }

      _message = 'Berhasil mengirim review.';

      _state = ResultState.data;
    } catch (e) {
      _message = 'Gagal mengirim review. Silahkan coba lagi.';

      _state = ResultState.error;
    }

    notifyListeners();
  }
}
