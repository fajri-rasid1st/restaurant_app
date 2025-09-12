import 'package:flutter/foundation.dart';
import 'package:restaurant_app/common/enum/result_state.dart';
import 'package:restaurant_app/data/models/restaurant_detail.dart';
import 'package:restaurant_app/data/services/restaurant_api_service.dart';

class CustomerReviewProvider extends ChangeNotifier {
  final RestaurantApiService service;

  CustomerReviewProvider(this.service);

  List<CustomerReview> _customerReviews = [];
  ResultState _state = ResultState.initial;
  String _message = '';

  List<CustomerReview> get customerReviews => _customerReviews;
  ResultState get state => _state;
  String get message => _message;

  /// Mengirim data review restaurant dan mengembalikan daftar review
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

      _customerReviews = result;

      _state = ResultState.data;
    } catch (e) {
      debugPrint('sendCustomerReview error: ${e.toString()}');

      _message = 'Gagal mengirim review. Silahkan coba lagi.';

      _state = ResultState.error;
    }

    notifyListeners();
  }
}
