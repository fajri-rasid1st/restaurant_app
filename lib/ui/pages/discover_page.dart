import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_app/common/result_state.dart';
import 'package:restaurant_app/data/models/restaurant.dart';
import 'package:restaurant_app/provider/category_provider.dart';
import 'package:restaurant_app/provider/restaurant_provider.dart';
import 'package:restaurant_app/provider/restaurant_search_provider.dart';
import 'package:restaurant_app/ui/screens/error_screen.dart';
import 'package:restaurant_app/ui/screens/loading_screen.dart';
import 'package:restaurant_app/ui/widgets/custom_information.dart';
import 'package:restaurant_app/ui/widgets/restaurant_card.dart';

class DiscoverPage extends StatelessWidget {
  const DiscoverPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer3<RestaurantProvider, RestaurantSearchProvider,
        CategoryProvider>(
      builder: (
        context,
        restaurantProvider,
        searchProvider,
        categoryProvider,
        child,
      ) {
        return _buildMainPage(
          restaurantProvider,
          searchProvider,
          categoryProvider,
        );
      },
    );
  }

  Widget _buildMainPage(
    RestaurantProvider restaurantProvider,
    RestaurantSearchProvider searchProvider,
    CategoryProvider categoryProvider,
  ) {
    switch (restaurantProvider.state) {
      case ResultState.loading:
        return const LoadingScreen();

      case ResultState.error:
        return const ErrorScreen();
      default:
        var restaurants = <Restaurant>[];

        if (searchProvider.isSearching && searchProvider.query.isNotEmpty) {
          restaurants = searchProvider.restaurants;
        } else if (categoryProvider.category.isNotEmpty) {
          restaurants = searchProvider.restaurants;
        } else {
          restaurants = restaurantProvider.restaurants;
        }

        if (searchProvider.state == ResultState.loading) {
          return const LoadingScreen();
        } else if (searchProvider.state == ResultState.error) {
          return const ErrorScreen();
        }

        return restaurants.isEmpty
            ? _buildRestaurantEmpty()
            : _buildRestaurantList(restaurants);
    }
  }

  /// Widget untuk membuat page kosong jika data tidak ditemukan
  CustomInformation _buildRestaurantEmpty() {
    return const CustomInformation(
      imgPath: 'assets/svg/404_Error_cuate.svg',
      title: 'Ups, Restoran Tidak Ditemukan!',
      subtitle: 'Coba masukkan kata kunci lainnya.',
    );
  }

  /// Widget untuk membuat list restaurant jika data berhasil didapatkan
  ListView _buildRestaurantList(List<Restaurant> restaurants) {
    return ListView.separated(
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
      itemBuilder: (context, index) {
        return RestaurantCard(restaurant: restaurants[index]);
      },
      separatorBuilder: (context, index) {
        return const SizedBox(height: 12);
      },
      itemCount: restaurants.length,
    );
  }
}
