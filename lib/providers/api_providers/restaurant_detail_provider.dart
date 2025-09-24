// Flutter imports:
import 'package:flutter/foundation.dart';

// Project imports:
import 'package:restaurant_app/common/enum/result_state.dart';
import 'package:restaurant_app/data/api/restaurant_api.dart';
import 'package:restaurant_app/data/db/restaurant_database.dart';
import 'package:restaurant_app/data/models/restaurant_detail.dart';

class RestaurantDetailProvider extends ChangeNotifier {
  final RestaurantApi apiService;
  final RestaurantDatabase databaseService;

  RestaurantDetailProvider({
    required this.apiService,
    required this.databaseService,
  });

  RestaurantDetail? restaurantDetail;
  ResultState _state = ResultState.loading;
  String _message = '';

  ResultState get state => _state;
  String get message => _message;

  /// Mengambil data detail restoran sesuai [id]-nya
  Future<void> getRestaurantDetail(String id) async {
    _state = ResultState.loading;
    notifyListeners();

    try {
      final result = await apiService.getRestaurantDetail(id);

      final isFavorited = await databaseService.isExist(id);

      restaurantDetail = result.copyWith(isFavorited: isFavorited);

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
    try {
      final result = await apiService.sendCustomerReview(
        id: id,
        name: name,
        review: review,
      );

      if (restaurantDetail != null) {
        restaurantDetail = restaurantDetail!.copyWith(customerReviews: result);
      }

      _message = 'Berhasil mengirim review.';
    } catch (e) {
      _message = 'Gagal mengirim review. Silahkan coba lagi.';
    }

    notifyListeners();
  }
}
