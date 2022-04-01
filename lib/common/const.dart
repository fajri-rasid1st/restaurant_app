class Const {
  // Url utama untuk mengambil data restaurant
  static const String baseUrl = 'https://restaurant-api.dicoding.dev';

  // Url untuk mengambil gambar restaurant (ukuran kecil)
  static const String imgUrl =
      'https://restaurant-api.dicoding.dev/images/small';

  // Url untuk mengambil gambar placeholder food
  static const String imgFoodPlaceholder =
      'https://raw.githubusercontent.com/fajri-rasid1st/assets/main/foods_and_beverages/food_placeholder.png';

  // Url untuk mengambil gambar placeholder drink
  static const String imgDrinkPlaceholder =
      'https://raw.githubusercontent.com/fajri-rasid1st/assets/main/foods_and_beverages/drink_placeholder.png';

  static const List<String> categories = <String>[
    'Semua',
    'Italia',
    'Jawa',
    'Modern',
    'Sop',
    'Bali',
    'Spanyol',
    'Sunda',
  ];
}
