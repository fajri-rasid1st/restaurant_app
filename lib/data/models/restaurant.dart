import 'package:restaurant_app/data/models/category.dart';
import 'package:restaurant_app/data/models/customer_review.dart';
import 'package:restaurant_app/data/models/menu.dart';

class Restaurant {
  final String id;
  final String name;
  final String description;
  final String city;
  final String address;
  final String pictureId;
  final double rating;
  final Menu menus;
  final List<Category> categories;
  final List<CustomerReview> customerReviews;

  Restaurant({
    required this.id,
    required this.name,
    required this.description,
    required this.city,
    required this.address,
    required this.pictureId,
    required this.rating,
    required this.menus,
    required this.categories,
    required this.customerReviews,
  });

  /// Constructor untuk membuat objek Restaurant dari bentuk map
  /// (hasil parsing json)
  factory Restaurant.fromMap(Map<String, dynamic> map) {
    return Restaurant(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      description: map['description'] ?? '',
      city: map['city'] ?? '',
      address: map['address'] ?? '',
      pictureId: map['pictureId'] ?? '',
      rating: map['rating']?.toDouble() ?? 0.0,
      menus: Menu.fromMap(map['menus']),
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
    );
  }
}
