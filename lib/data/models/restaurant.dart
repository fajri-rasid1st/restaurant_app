import 'package:restaurant_app/data/models/menu.dart';

class Restaurant {
  final String id;
  final String name;
  final String description;
  final String pictureId;
  final String city;
  final double rating;
  final Menu menus;

  const Restaurant({
    required this.id,
    required this.name,
    required this.description,
    required this.pictureId,
    required this.city,
    required this.rating,
    required this.menus,
  });

  // constructor untuk membuat objek Restaurant dari bentuk Map (hasil parsing json)
  factory Restaurant.fromMap(Map<String, dynamic> restaurant) {
    return Restaurant(
      id: restaurant['id'] ?? '',
      name: restaurant['name'] ?? '',
      description: restaurant['description'] ?? '',
      pictureId: restaurant['pictureId'] ?? '',
      city: restaurant['city'] ?? '',
      rating: restaurant['rating']?.toDouble() ?? 0.0,
      menus: Menu.fromMap(restaurant['menus']),
    );
  }
}
