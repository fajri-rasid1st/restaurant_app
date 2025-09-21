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

class RestaurantFavorite {
  final int? id;
  final String restaurantId;
  final String name;
  final String description;
  final String pictureId;
  final String city;
  final num rating;
  final DateTime createdAt;

  RestaurantFavorite({
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

  /// Method untuk menyalin object dengan mengganti beberapa atribut sesuai parameter yang dimasukkan
  RestaurantFavorite copyWith({
    int? id,
    String? restaurantId,
    String? name,
    String? description,
    String? pictureId,
    String? city,
    num? rating,
    DateTime? createdAt,
  }) {
    return RestaurantFavorite(
      id: id ?? this.id,
      restaurantId: restaurantId ?? this.restaurantId,
      name: name ?? this.name,
      description: description ?? this.description,
      pictureId: pictureId ?? this.pictureId,
      city: city ?? this.city,
      rating: rating ?? this.rating,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
