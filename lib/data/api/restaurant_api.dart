import 'dart:convert';

import 'package:http/http.dart' as http;

import 'package:restaurant_app/data/common/const.dart';
import 'package:restaurant_app/data/models/restaurant.dart';

class RestaurantApi {
  /// Mengambil data daftar restaurant dari server. Jika [query] dimasukkan,
  /// maka akan mengambil daftar restaurant sesuai [query]. mengembalikan nilai berupa:
  ///
  /// * List restaurant, jika berhasil.
  /// * Throw exception error, jika gagal.
  static Future<List<Restaurant>> getRestaurants([String? query]) async {
    // Definisikan terlebih dahulu url-nya
    final url = (query == null)
        ? '${Const.baseUrl}/list'
        : '${Const.baseUrl}/search?q=$query';

    // Parsing string url ke bentuk uri
    final uri = Uri.parse(url);

    // Kirim http request menggunakan metode get
    final response = await http.get(uri);

    if (response.statusCode == 200) {
      // Parsing string dan mengembalikan nilai objek json
      final results = jsonDecode(response.body);

      // Casting hasilnya ke bentuk Map, lalu ambil value dari key restaurants.
      // karena data dari server berbentuk list, maka tipe List ditulis secara eksplisit.
      final List restaurants = (results as Map<String, dynamic>)['restaurants'];

      // Kembalikan nilai berupa daftar restaurant yang telah dibuat dari bentuk map
      return restaurants.map((restaurant) {
        return Restaurant.fromMap(restaurant);
      }).toList();
    } else {
      // Kembalikan exception error jika gagal
      throw Exception('Gagal Memuat Daftar Restoran!');
    }
  }

  /// Mengambil data detail restaurant dari server berdasarkan [id] restaurant
  /// dan mengembalikan:
  ///
  /// * Object Restaurant, jika berhasil.
  /// * Throw exception error, jika gagal.
  static Future<Restaurant> getRestaurantDetail(String id) async {
    // Parsing string url ke bentuk uri
    final uri = Uri.parse('${Const.baseUrl}/detail/$id');

    // Kirim http request menggunakan metode get
    final response = await http.get(uri);

    if (response.statusCode == 200) {
      // Parsing string dan mengembalikan nilai objek json
      final results = jsonDecode(response.body);

      // Casting hasilnya ke bentuk Map, lalu ambil value dari key restaurant.
      // karena data dari server berbentuk object, maka hasilnya berupa object Restaurant.
      final Restaurant restaurant =
          (results as Map<String, dynamic>)['restaurant'];

      // Kembalikan nilai berupa object restaurant yang telah dibuat dari bentuk map
      return restaurant;
    } else {
      // Kembalikan exception error jika gagal
      throw Exception('Gagal Memuat Data Restoran!');
    }
  }
}
