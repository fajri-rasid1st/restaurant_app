// Project imports:
import 'package:restaurant_app/models/restaurant_favorite.dart';

class Restaurant {
  final String id;
  final String name;
  final String description;
  final String pictureId;
  final String city;
  final double rating;
  final bool isFavorited;

  const Restaurant({
    required this.id,
    required this.name,
    required this.description,
    required this.pictureId,
    required this.city,
    required this.rating,
    this.isFavorited = false,
  });

  /// Factory constructor untuk membuat objek dari bentuk json map
  factory Restaurant.fromMap(Map<String, dynamic> json) {
    return Restaurant(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      pictureId: json['pictureId'] ?? '',
      city: json['city'] ?? '',
      rating: json['rating']?.toDouble() ?? 0.0,
    );
  }

  /// Constructor untuk membuat objek dari model restaurant favorit
  factory Restaurant.fromFavorite(RestaurantFavorite favorite) {
    return Restaurant(
      id: favorite.restaurantId,
      name: favorite.name,
      description: favorite.description,
      pictureId: favorite.pictureId,
      city: favorite.city,
      rating: favorite.rating.toDouble(),
    );
  }

  /// Method untuk meng-copy object dengan beberapa field yang diubah
  Restaurant copyWith({
    String? id,
    String? name,
    String? description,
    String? pictureId,
    String? city,
    double? rating,
    bool? isFavorited,
  }) {
    return Restaurant(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      pictureId: pictureId ?? this.pictureId,
      city: city ?? this.city,
      rating: rating ?? this.rating,
      isFavorited: isFavorited ?? this.isFavorited,
    );
  }
}
