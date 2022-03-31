import 'package:flutter/foundation.dart';
import 'package:restaurant_app/common/result_state.dart';
import 'package:restaurant_app/data/api/restaurant_api.dart';
import 'package:restaurant_app/data/models/customer_review.dart';
import 'package:restaurant_app/data/models/restaurant.dart';
import 'package:restaurant_app/data/models/restaurant_detail.dart';

class RestaurantProvider extends ChangeNotifier {
  static RestaurantProvider? _instance;

  RestaurantProvider._internal() {
    fetchAllRestaurants();
    _instance = this;
  }

  // singleton pattern agar kelas hanya bisa di instansiasi sekali
  factory RestaurantProvider() => _instance ?? RestaurantProvider._internal();

  // deklarasi tiap-tiap state
  late ResultState _state;
  late ResultState _detailState;

  // deklarasi tiap-tiap data restaurant
  late List<Restaurant> _restaurants;
  List<Restaurant>? _restaurantFromSearch;
  RestaurantDetail? _restaurantDetail;
  List<CustomerReview>? _customerReviews;

  // inisialisasi message yang akan dikembalikan jika terjadi error
  String _message = '';

  // inisialisasi kondisi saat sedang melakukan searching
  bool _isSearching = false;

  // inisialisasi query saat sedang melakukan searching
  String _query = '';

  // inisialisasi apakah halaman sedang di reload
  bool _isPageReload = false;

  // method getter untuk setiap data class
  ResultState get state => _state;
  ResultState get detailState => _detailState;
  List<Restaurant> get restaurants => _restaurants;
  List<Restaurant> get restaurantFromSearch => _restaurantFromSearch!;
  RestaurantDetail get restaurantDetail => _restaurantDetail!;
  List<CustomerReview> get customerReviews => _customerReviews!;
  String get message => _message;
  bool get isSearching => _isSearching;
  String get query => _query;
  bool get isPageReload => _isPageReload;

  // method setter untuk beberapa data class
  set state(ResultState value) {
    _state = value;
    notifyListeners();
  }

  set detailState(ResultState value) {
    _detailState = value;
    notifyListeners();
  }

  set restaurants(List<Restaurant> value) {
    _restaurants = value;
    notifyListeners();
  }

  set restaurantDetail(RestaurantDetail value) {
    _restaurantDetail = value;
    notifyListeners();
  }

  set isSearching(bool value) {
    _restaurantFromSearch = _restaurants;

    _isSearching = value;
    notifyListeners();
  }

  set isPageReload(bool value) {
    _isPageReload = value;
    notifyListeners();
  }

  /// Melukan pengambilan semua daftar restaurant
  Future<dynamic> fetchAllRestaurants() async {
    try {
      _state = ResultState.loading;
      notifyListeners();

      final result = await RestaurantApi.getRestaurants();

      _state = ResultState.hasData;
      notifyListeners();

      return _restaurants = result;
    } catch (error) {
      _state = ResultState.error;
      notifyListeners();

      return _message = 'Error: $error';
    }
  }

  /// Melukan pencarian data restaurant sesuai query yang dimasukkan
  Future<dynamic> searchRestaurants(String query) async {
    try {
      final result = await RestaurantApi.getRestaurants(query);

      _query = query;
      notifyListeners();

      return _restaurantFromSearch = result;
    } catch (error) {
      return _message = 'Error: $error';
    }
  }

  /// Melukan pengambilan data detail restauran sesuai id
  Future<dynamic> getRestaurantDetail(String id) async {
    try {
      _detailState = ResultState.loading;
      notifyListeners();

      final result = await RestaurantApi.getRestaurantDetail(id);

      _detailState = ResultState.hasData;
      notifyListeners();

      return _restaurantDetail = result;
    } catch (error) {
      _detailState = ResultState.error;
      notifyListeners();

      return _message = 'Error: $error';
    }
  }

  /// Melukan pengiriman review restaurant dan pengambilan hasil review
  ///
  /// * return true jika berhasil
  /// * return false jika gagal
  Future<bool> sendCustomerReview(
    String id,
    String name,
    String review,
  ) async {
    try {
      final result = await RestaurantApi.sendCustomerReview(id, name, review);

      _restaurantDetail!.customerReviews = result;
      notifyListeners();

      return true;
    } catch (error) {
      return false;
    }
  }
}
