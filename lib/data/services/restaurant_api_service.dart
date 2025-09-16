// Dart imports:
import 'dart:convert';

// Package imports:
import 'package:http/http.dart' as http;

// Project imports:
import 'package:restaurant_app/common/const/const.dart';
import 'package:restaurant_app/data/models/restaurant.dart';
import 'package:restaurant_app/data/models/restaurant_detail.dart';

final class RestaurantApiService {
  static final RestaurantApiService _instance = RestaurantApiService._internal();

  RestaurantApiService._internal();

  factory RestaurantApiService() => _instance;

  /// Mengambil data daftar restaurant dari API. Jika [query] dimasukkan,
  /// maka akan mengambil daftar restaurant sesuai [query]. mengembalikan nilai berupa:
  ///
  /// * List [Restaurant], jika berhasil.
  /// * Throw [Exception], jika gagal.
  Future<List<Restaurant>> getRestaurants([String? query]) async {
    // Definisikan terlebih dahulu url
    final url = (query == null || query.isEmpty) ? '${Const.baseUrl}list' : '${Const.baseUrl}search?q=$query';

    // Parsing string url ke bentuk uri
    final uri = Uri.parse(url);

    try {
      // Kirim http request menggunakan metode get
      final response = await http.get(uri);

      if (response.statusCode == 200) {
        // Parsing string dan mengembalikan nilai objek json
        final results = jsonDecode(response.body);

        // Casting hasilnya ke bentuk Map, lalu ambil value dari key restaurants.
        // karena data dari API berbentuk list, maka tipe List ditulis secara eksplisit.
        final List restaurants = (results as Map<String, dynamic>)['restaurants'];

        // Kembalikan nilai berupa daftar restaurant yang telah dibuat dari bentuk map
        return restaurants.map((e) => Restaurant.fromMap(e)).toList();
      } else {
        // Kembalikan exception error jika gagal
        throw Exception('error code ${response.statusCode}');
      }
    } catch (e) {
      // Kembalikan exception error jika gagal
      rethrow;
    }
  }

  /// Mengambil data detail restaurant dari API berdasarkan [id] restaurant
  /// dan mengembalikan:
  ///
  /// * Object [Restaurant], jika berhasil.
  /// * Throw [Exception], jika gagal.
  Future<RestaurantDetail> getRestaurantDetail(String id) async {
    // Parsing string url ke bentuk uri
    final uri = Uri.parse('${Const.baseUrl}detail/$id');

    try {
      // Kirim http request menggunakan metode get
      final response = await http.get(uri);

      if (response.statusCode == 200) {
        // Parsing string dan mengembalikan nilai objek json
        final results = jsonDecode(response.body);

        // Casting hasilnya ke bentuk Map, lalu ambil value dari key restaurant.
        // karena data dari API berbentuk object, maka hasilnya berupa object Restaurant.
        final restaurant = (results as Map<String, dynamic>)['restaurant'];

        // Kembalikan nilai berupa object restaurant yang telah dibuat dari bentuk map
        return RestaurantDetail.fromMap(restaurant);
      } else {
        // Kembalikan exception error jika gagal
        throw Exception('error code ${response.statusCode}');
      }
    } catch (e) {
      // Kembalikan exception error jika gagal
      rethrow;
    }
  }

  /// Mengirim data review [id], [name], [review] ke server dan mengembalikan:
  ///
  /// * true, jika berhasil.
  /// * false, jika gagal.
  Future<List<CustomerReview>> sendCustomerReview({
    required String id,
    required String name,
    required String review,
  }) async {
    // Parsing string url ke bentuk uri
    final uri = Uri.parse('${Const.baseUrl}review');

    // Definisikan headers untuk request
    final headers = {'Content-Type': 'application/json'};

    // Definisikan body untuk request
    final body = jsonEncode({
      'id': id,
      'name': name,
      'review': review,
    });

    try {
      // Kirim data ke server dengan menggunakan metode post
      final response = await http.post(
        uri,
        headers: headers,
        body: body,
      );

      if (response.statusCode == 201) {
        // Parsing string dan mengembalikan nilai objek json
        final results = jsonDecode(response.body);

        // Casting hasilnya ke bentuk Map, lalu ambil value dari key customerReviews.
        final List reviews = (results as Map<String, dynamic>)['customerReviews'];

        // Kembalikan nilai berupa daftar review yang telah dibuat dari bentuk map
        return reviews.map((e) => CustomerReview.fromMap(e)).toList();
      } else {
        // Jika server tidak mengembalikan kode 201, maka throw exception
        throw Exception('error code ${response.statusCode}');
      }
    } catch (e) {
      // Kembalikan exception error jika gagal
      rethrow;
    }
  }
}
