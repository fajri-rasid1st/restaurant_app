import 'package:restaurant_app/data/models/category.dart';
import 'package:restaurant_app/data/models/customer_review.dart';
import 'package:restaurant_app/data/models/menu.dart';
import 'package:restaurant_app/data/models/restaurant.dart';

class RestaurantDetail extends Restaurant {
  final String address;
  final List<Category> categories;
  late List<CustomerReview> customerReviews;
  final Menu menus;

  RestaurantDetail({
    required String id,
    required String name,
    required String description,
    required String pictureId,
    required String city,
    required double rating,
    required this.address,
    required this.categories,
    required this.customerReviews,
    required this.menus,
  }) : super(
            id: id,
            name: name,
            description: description,
            pictureId: pictureId,
            city: city,
            rating: rating);

  /// Constructor untuk membuat objek RestaurantDetail dari bentuk map
  /// (hasil parsing json)
  factory RestaurantDetail.fromMap(Map<String, dynamic> map) {
    return RestaurantDetail(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      description: map['description'] ?? '',
      pictureId: map['pictureId'] ?? '',
      city: map['city'] ?? '',
      rating: map['rating']?.toDouble() ?? 0.0,
      address: map['address'] ?? '',
      categories: List<Category>.from(
        map['categories']?.map((category) {
          return Category.fromMap(category);
        }),
      ),
      customerReviews: List<CustomerReview>.from(
        map['customerReviews']?.map((customerReview) {
          return CustomerReview.fromMap(customerReview);
        }),
      ),
      menus: Menu.fromMap(map['menus']),
    );
  }
}
