// Project imports:
import 'package:restaurant_app/data/models/restaurant.dart';

/// Nama tabel pada database
const String favoriteTable = 'favorite_table';

class FavoriteFields {
  static const String id = '_id';
  static const String restaurantId = 'restaurantId';
  static const String name = 'name';
  static const String description = 'description';
  static const String pictureId = 'pictureId';
  static const String city = 'city';
  static const String rating = 'rating';
  static const String createdAt = 'createdAt';
}

/// Model untuk restoran favorite yang disimpan di database
class RestaurantFavorite {
  final int? id;
  final String restaurantId;
  final String name;
  final String description;
  final String pictureId;
  final String city;
  final num rating;
  final DateTime createdAt;

  const RestaurantFavorite({
    this.id,
    required this.restaurantId,
    required this.name,
    required this.description,
    required this.pictureId,
    required this.city,
    required this.rating,
    required this.createdAt,
  });

  /// Constructor untuk membuat objek dari bentuk map
  factory RestaurantFavorite.fromMap(Map<String, dynamic> map) {
    return RestaurantFavorite(
      id: map[FavoriteFields.id] as int?,
      restaurantId: map[FavoriteFields.restaurantId] as String,
      name: map[FavoriteFields.name] as String,
      description: map[FavoriteFields.description] as String,
      pictureId: map[FavoriteFields.pictureId] as String,
      city: map[FavoriteFields.city] as String,
      rating: map[FavoriteFields.rating] as num,
      createdAt: DateTime.parse(map[FavoriteFields.createdAt]),
    );
  }

  /// Constructor untuk membuat objek dari model restaurant
  factory RestaurantFavorite.fromRestaurant(Restaurant restaurant) {
    return RestaurantFavorite(
      restaurantId: restaurant.id,
      name: restaurant.name,
      description: restaurant.description,
      pictureId: restaurant.pictureId,
      city: restaurant.city,
      rating: restaurant.rating,
      createdAt: DateTime.now(),
    );
  }

  /// Method untuk mengubah bentuk object ke Map
  Map<String, dynamic> toMap() {
    return {
      FavoriteFields.id: id,
      FavoriteFields.restaurantId: restaurantId,
      FavoriteFields.name: name,
      FavoriteFields.description: description,
      FavoriteFields.pictureId: pictureId,
      FavoriteFields.city: city,
      FavoriteFields.rating: rating,
      FavoriteFields.createdAt: createdAt.toIso8601String(),
    };
  }
}
