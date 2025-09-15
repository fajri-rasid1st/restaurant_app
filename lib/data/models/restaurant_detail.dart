import 'package:restaurant_app/data/models/restaurant.dart';

class RestaurantDetail extends Restaurant {
  final String address;
  final List<Category> categories;
  final List<CustomerReview> customerReviews;
  final Menu menus;

  RestaurantDetail({
    required super.id,
    required super.name,
    required super.description,
    required super.pictureId,
    required super.city,
    required super.rating,
    required this.address,
    required this.categories,
    required this.customerReviews,
    required this.menus,
  });

  /// Constructor untuk membuat objek RestaurantDetail dari bentuk json map
  factory RestaurantDetail.fromMap(Map<String, dynamic> json) {
    return RestaurantDetail(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      pictureId: json['pictureId'] ?? '',
      city: json['city'] ?? '',
      rating: json['rating']?.toDouble() ?? 0.0,
      address: json['address'] ?? '',
      categories: List<Category>.from(json['categories']?.map((e) => Category.fromMap(e))),
      customerReviews: List<CustomerReview>.from(json['customerReviews']?.map((e) => CustomerReview.fromMap(e))),
      menus: Menu.fromMap(json['menus']),
    );
  }

  /// Method untuk meng-copy object dengan beberapa field yang diubah
  @override
  RestaurantDetail copyWith({
    String? id,
    String? name,
    String? description,
    String? pictureId,
    String? city,
    double? rating,
    String? address,
    List<Category>? categories,
    List<CustomerReview>? customerReviews,
    Menu? menus,
  }) {
    return RestaurantDetail(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      pictureId: pictureId ?? this.pictureId,
      city: city ?? this.city,
      rating: rating ?? this.rating,
      address: address ?? this.address,
      categories: categories ?? this.categories,
      customerReviews: customerReviews ?? this.customerReviews,
      menus: menus ?? this.menus,
    );
  }
}

class Category {
  final String name;

  Category({required this.name});

  /// Constructor untuk membuat objek Category dari bentuk json map
  factory Category.fromMap(Map<String, dynamic> json) {
    return Category(name: json['name'] ?? '');
  }
}

class CustomerReview {
  final String name;
  final String review;
  final String date;

  CustomerReview({
    required this.name,
    required this.review,
    required this.date,
  });

  /// Constructor untuk membuat objek CustomerReview dari bentuk json map
  factory CustomerReview.fromMap(Map<String, dynamic> json) {
    return CustomerReview(
      name: json['name'] ?? '',
      review: json['review'] ?? '',
      date: json['date'] ?? '',
    );
  }
}

class Menu {
  final List<ItemMenu> foods;
  final List<ItemMenu> drinks;

  Menu({
    required this.foods,
    required this.drinks,
  });

  /// Constructor untuk membuat objek Menu dari bentuk json map
  factory Menu.fromMap(Map<String, dynamic> json) {
    return Menu(
      foods: List<ItemMenu>.from(json['foods']?.map((e) => ItemMenu.fromMap(e))),
      drinks: List<ItemMenu>.from(json['drinks']?.map((e) => ItemMenu.fromMap(e))),
    );
  }
}

class ItemMenu {
  final String name;

  ItemMenu({required this.name});

  /// Constructor untuk membuat objek ItemMenu dari bentuk json map
  factory ItemMenu.fromMap(Map<String, dynamic> json) {
    return ItemMenu(name: json['name'] ?? '');
  }
}
