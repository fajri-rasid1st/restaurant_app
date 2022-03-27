import 'dart:convert';

import 'package:http/http.dart' as http;

import 'package:restaurant_app/data/const.dart';
import 'package:restaurant_app/data/models/restaurant.dart';

class RestaurantApi {
  /// mengambil list data restaurant dari server, dan mengembalikan:
  ///
  /// * list daftar restaurant, jika berhasil
  /// * throm exception error, jika gagal
  static Future<List<Restaurant>> getRestaurants() async {
    // definisikan target url
    const url = Const.urlToData;

    // parsing string url ke bentuk uri
    final uri = Uri.parse(url);

    // kirim http request menggunakan metode get
    final response = await http.get(uri);

    if (response.statusCode == 200) {
      // parsing string dan mengembalikan nilai objek json
      final results = jsonDecode(response.body);

      // casting hasilnya ke bentuk Map<string, dynamic>, lalu ambil value dari key restaurants
      final List<dynamic> restaurants =
          (results as Map<String, dynamic>)['restaurants'];

      // inisialisasi list restaurant kosong
      final newRestaurantList = <Restaurant>[];

      for (var restaurant in restaurants) {
        // tambahkan objek restaurant ke list, yang diperoleh melalui method map
        newRestaurantList.add(Restaurant.fromMap(restaurant));
      }

      // kembalikan nilai newRestaurantList
      return newRestaurantList;
    } else {
      throw Exception();
    }
  }

  /// mengambil list data restaurant dari server kemudian melakukan filter sesuai query
  static Future<List<Restaurant>> searchRestaurants(String query) async {
    // mengembalikan nilai dari method [getRestaurants]
    return getRestaurants().then((restaurants) {
      // kembalikan list restaurant hasil filter pada namanya sesuai kueri
      return restaurants.where((restaurant) {
        final restaurantNameLower = restaurant.name.toLowerCase();
        final queryLower = query.toLowerCase();

        return restaurantNameLower.contains(queryLower);
      }).toList();
    });
  }
}
