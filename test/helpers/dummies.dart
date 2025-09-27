// Project imports:
import 'package:restaurant_app/models/restaurant.dart';
import 'package:restaurant_app/models/restaurant_detail.dart';
import 'package:restaurant_app/models/restaurant_favorite.dart';

final dummyRestaurants = [
  Restaurant(
    id: 'r1',
    name: 'Restoran Sederhana',
    description: 'Masakan Padang',
    pictureId: 'pic_1',
    city: 'Jakarta',
    rating: 4.5,
  ),
  Restaurant(
    id: 'r2',
    name: 'Padang Maknyus',
    description: 'Ikonik rendang',
    pictureId: 'pic_2',
    city: 'Bandung',
    rating: 4.3,
  ),
];

final dummyRestaurantsSearchResult = [
  Restaurant(
    id: 'r1',
    name: 'Restoran Sederhana',
    description: 'Masakan Padang',
    pictureId: 'pic_1',
    city: 'Jakarta',
    rating: 4.5,
  ),
];

final dummyRestaurantDetail = RestaurantDetail(
  id: 'r1',
  name: 'Restoran Sederhana',
  description: 'Masakan Padang lengkap',
  pictureId: 'pic_1',
  city: 'Jakarta',
  rating: 4.5,
  isFavorited: false,
  address: 'Jl. Sudirman No. 1',
  categories: [
    Category(
      name: 'Padang',
    ),
  ],
  customerReviews: [
    CustomerReview(
      name: 'Budi',
      review: 'Mantap!',
      date: '2024-01-01',
    ),
  ],
  menus: Menu(
    foods: [
      ItemMenu(
        name: 'Rendang',
      ),
    ],
    drinks: [
      ItemMenu(
        name: 'Es Teh',
      ),
    ],
  ),
);

final dummyReviewsAfterPost = [
  ...dummyRestaurantDetail.customerReviews,
  CustomerReview(
    name: 'Ani',
    review: 'Enak bgt',
    date: '2024-01-02',
  ),
];

final dummyRestaurantFavorite1 = RestaurantFavorite(
  id: 1,
  restaurantId: 'r1',
  name: 'Sederhana',
  description: 'Masakan Padang',
  pictureId: 'pic_1',
  city: 'Jakarta',
  rating: 4.5,
  createdAt: DateTime.parse('2024-01-01'),
);

final dummyRestaurantFavorite2 = RestaurantFavorite(
  id: 2,
  restaurantId: 'r2',
  name: 'Padang Maknyus',
  description: 'Rendang juara',
  pictureId: 'pic_2',
  city: 'Bandung',
  rating: 4.3,
  createdAt: DateTime.parse('2024-01-02'),
);

final dummyRestaurantFavoriteList = [dummyRestaurantFavorite2, dummyRestaurantFavorite1];
