const String favoriteTable = 'favorite_table';

class FavoriteFields {
  static const String id = '_id';
  static const String restaurantId = 'restaurantId';
  static const String name = 'name';
  static const String pictureId = 'pictureId';
  static const String city = 'city';
  static const String rating = 'rating';
  static const String createdAt = 'createdAt';
}

class Favorite {
  final int? id;
  final String restaurantId;
  final String name;
  final String pictureId;
  final String city;
  final num rating;
  final DateTime createdAt;

  Favorite({
    this.id,
    required this.restaurantId,
    required this.name,
    required this.pictureId,
    required this.city,
    required this.rating,
    required this.createdAt,
  });

  /// Method untuk menyalin object dengan mengganti beberapa atribut sesuai
  /// parameter yang dimasukkan
  Favorite copyWith({
    int? id,
    String? restaurantId,
    String? name,
    String? pictureId,
    String? city,
    num? rating,
    DateTime? createdAt,
  }) {
    return Favorite(
      id: id ?? this.id,
      restaurantId: restaurantId ?? this.restaurantId,
      name: name ?? this.name,
      pictureId: pictureId ?? this.pictureId,
      city: city ?? this.city,
      rating: rating ?? this.rating,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  /// Method untuk mengubah bentuk object ke Map
  Map<String, dynamic> toMap() {
    return {
      FavoriteFields.id: id,
      FavoriteFields.restaurantId: restaurantId,
      FavoriteFields.name: name,
      FavoriteFields.pictureId: pictureId,
      FavoriteFields.city: city,
      FavoriteFields.rating: rating,
      FavoriteFields.createdAt: createdAt.toIso8601String(),
    };
  }

  /// Constructor untuk membuat objek dari bentuk map
  factory Favorite.fromMap(Map<String, dynamic> favorite) {
    return Favorite(
      id: favorite[FavoriteFields.id] as int,
      restaurantId: favorite[FavoriteFields.restaurantId] as String,
      name: favorite[FavoriteFields.name] as String,
      pictureId: favorite[FavoriteFields.pictureId] as String,
      city: favorite[FavoriteFields.city] as String,
      rating: favorite[FavoriteFields.rating] as num,
      createdAt: DateTime.parse(favorite[FavoriteFields.createdAt] as String),
    );
  }
}
