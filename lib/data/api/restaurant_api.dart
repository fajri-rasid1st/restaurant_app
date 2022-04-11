import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:restaurant_app/common/const.dart';
import 'package:restaurant_app/data/models/customer_review.dart';
import 'package:restaurant_app/data/models/restaurant.dart';
import 'package:restaurant_app/data/models/restaurant_detail.dart';

class RestaurantApi {
  static RestaurantApi? _restaurantApi;

  RestaurantApi._internal() {
    _restaurantApi = this;
  }

  factory RestaurantApi() => _restaurantApi ?? RestaurantApi._internal();

  /// Mengambil data daftar restaurant dari server. Jika [query] dimasukkan,
  /// maka akan mengambil daftar restaurant sesuai [query]. mengembalikan nilai berupa:
  ///
  /// * List restaurant, jika berhasil.
  /// * Throw exception error, jika gagal.
  Future<List<Restaurant>> getRestaurants([String? query]) async {
    // Definisikan terlebih dahulu url-nya
    final url = (query == null || query.isEmpty)
        ? '${Const.baseUrl}/list'
        : '${Const.baseUrl}/search?q=$query';

    // Parsing string url ke bentuk uri
    final uri = Uri.parse(url);

    try {
      // Kirim http request menggunakan metode get
      final response = await http.get(uri);

      if (response.statusCode == 200) {
        // Parsing string dan mengembalikan nilai objek json
        final results = jsonDecode(response.body);

        // Casting hasilnya ke bentuk Map, lalu ambil value dari key restaurants.
        // karena data dari server berbentuk list, maka tipe List ditulis secara eksplisit.
        final List restaurants =
            (results as Map<String, dynamic>)['restaurants'];

        // Kembalikan nilai berupa daftar restaurant yang telah dibuat dari bentuk map
        return restaurants.map((restaurant) {
          return Restaurant.fromMap(restaurant);
        }).toList();
      } else {
        // Kembalikan exception error jika gagal
        throw Exception();
      }
    } catch (e) {
      // Kembalikan exception error jika gagal
      throw Exception();
    }
  }

  /// Mengambil data detail restaurant dari server berdasarkan [id] restaurant
  /// dan mengembalikan:
  ///
  /// * Object Restaurant, jika berhasil.
  /// * Throw exception error, jika gagal.
  Future<RestaurantDetail> getRestaurantDetail(String id) async {
    // Parsing string url ke bentuk uri
    final uri = Uri.parse('${Const.baseUrl}/detail/$id');

    try {
      // Kirim http request menggunakan metode get
      final response = await http.get(uri);

      if (response.statusCode == 200) {
        // Parsing string dan mengembalikan nilai objek json
        final results = jsonDecode(response.body);

        // Casting hasilnya ke bentuk Map, lalu ambil value dari key restaurant.
        // karena data dari server berbentuk object, maka hasilnya berupa object Restaurant.
        final restaurant = (results as Map<String, dynamic>)['restaurant'];

        // Kembalikan nilai berupa object restaurant yang telah dibuat dari bentuk map
        return RestaurantDetail.fromMap(restaurant);
      } else {
        // Kembalikan exception error jika gagal
        throw Exception();
      }
    } catch (e) {
      // Kembalikan exception error jika gagal
      throw Exception();
    }
  }

  /// Mengirim data review [id], [name], [review] ke server dan mengembalikan:
  ///
  /// * true , jika berhasil.
  /// * false, jika gagal.
  Future<List<CustomerReview>> sendCustomerReview(
    String id,
    String name,
    String review,
  ) async {
    // Parsing string url ke bentuk uri
    final uri = Uri.parse('${Const.baseUrl}/review');

    try {
      // Kirim data ke server dengan menggunakan metode post
      final response = await http.post(
        uri,
        headers: <String, String>{
          'Content-Type': 'application/json',
        },
        body: jsonEncode(<String, String>{
          'id': id,
          'name': name,
          'review': review,
        }),
      );

      if (response.statusCode == 201) {
        // Parsing string dan mengembalikan nilai objek json
        final results = jsonDecode(response.body);

        // Casting hasilnya ke bentuk Map, lalu ambil value dari key customerReviews.
        final List review =
            (results as Map<String, dynamic>)['customerReviews'];

        // Kembalikan nilai berupa daftar review yang telah dibuat dari bentuk map
        return review.map((customerReview) {
          return CustomerReview.fromMap(customerReview);
        }).toList();
      } else {
        // Jika server tidak mengembalikan kode 201, maka throw exception
        throw Exception();
      }
    } catch (e) {
      // Kembalikan exception error jika gagal
      throw Exception();
    }
  }
}
