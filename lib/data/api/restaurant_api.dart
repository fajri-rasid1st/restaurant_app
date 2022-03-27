import 'dart:convert';

import 'package:http/http.dart' as http;

import 'package:restaurant_app/data/const.dart';
import 'package:restaurant_app/data/models/restaurant.dart';

class RestaurantApi {
  // function to get list of restaurants
  static Future<List<Restaurant>> getRestaurants() async {
    // define url target
    const url = Const.urlToData;

    // parsing string to uri object
    final uri = Uri.parse(url);

    // send http with get method request
    final response = await http.get(uri);

    if (response.statusCode == 200) {
      // parse the string and returns the resulting json object
      final results = jsonDecode(response.body);

      // casting results to Map<string, dynamic> and get 'restaurants' value
      final List<dynamic> restaurants =
          (results as Map<String, dynamic>)['restaurants'];

      // initialize empty restaurant list
      final newRestaurantList = <Restaurant>[];

      for (var restaurant in restaurants) {
        // add restaurant object to new restaurant list
        newRestaurantList.add(Restaurant.fromMap(restaurant));
      }

      // return new restaurant list
      return newRestaurantList;
    } else {
      throw Exception();
    }
  }

  // function to search restaurants
  static Future<List<Restaurant>> searchRestaurants(String query) async {
    // define url target
    const url = Const.urlToData;

    // parsing string to uri object
    final uri = Uri.parse(url);

    // send http with get method request
    final response = await http.get(uri);

    if (response.statusCode == 200) {
      // parse the string and returns the resulting json object
      final results = jsonDecode(response.body);

      // casting results to Map<string, dynamic> and get 'restaurants' value
      final List<dynamic> restaurants =
          (results as Map<String, dynamic>)['restaurants'];

      // initialize empty restaurant list
      final newRestaurantList = <Restaurant>[];

      for (var restaurant in restaurants) {
        // add restaurant object to new restaurant list
        newRestaurantList.add(Restaurant.fromMap(restaurant));
      }

      // return new restaurant list
      return newRestaurantList.where((restaurant) {
        final restaurantNameLower = restaurant.name.toLowerCase();
        final queryLower = query.toLowerCase();

        return restaurantNameLower.contains(queryLower);
      }).toList();
    } else {
      throw Exception('error network connection.');
    }
  }
}
