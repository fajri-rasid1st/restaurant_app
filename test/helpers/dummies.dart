import 'package:restaurant_app/models/restaurant.dart';
import 'package:restaurant_app/models/restaurant_detail.dart';

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

final dummyRestaurantsSearchResult = <Restaurant>[
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

// Hasil list review setelah kirim review sukses (API sendCustomerReview di project-mu
// mengembalikan List<CustomerReview>, bukan RestaurantDetail)
final dummyReviewsAfterPost = [
  ...dummyRestaurantDetail.customerReviews,
  CustomerReview(
    name: 'Ani',
    review: 'Enak bgt',
    date: '2024-01-02',
  ),
];
