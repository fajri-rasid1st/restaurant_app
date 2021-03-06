import 'package:flutter/foundation.dart';
import 'package:restaurant_app/data/api/restaurant_api.dart';
import 'package:restaurant_app/data/models/customer_review.dart';

class CustomerReviewProvider extends ChangeNotifier {
  final RestaurantApi restaurantApi;

  CustomerReviewProvider({required this.restaurantApi});

  late List<CustomerReview> _customerReviews;

  List<CustomerReview> get customerReviews => _customerReviews;

  /// Melukan pengiriman review restaurant dan pengambilan hasil review
  ///
  /// * return true jika berhasil
  /// * return false jika gagal
  Future<bool> sendCustomerReview(String id, String name, String review) async {
    try {
      final result = await restaurantApi.sendCustomerReview(id, name, review);

      _customerReviews = result;
      notifyListeners();

      return true;
    } catch (_) {
      return false;
    }
  }
}
