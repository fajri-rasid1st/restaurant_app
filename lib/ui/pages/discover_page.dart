import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
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

  /// Widget untuk membuat tampilan utama
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
        if (searchProvider.state == ResultState.loading) {
          return const LoadingScreen();
        } else if (searchProvider.state == ResultState.error) {
          return const ErrorScreen();
        }

        var restaurants = restaurantProvider.restaurants;

        if (searchProvider.isSearching && searchProvider.query.isNotEmpty ||
            categoryProvider.category.isNotEmpty) {
          restaurants = searchProvider.restaurants;
        }

        return restaurants.isEmpty
            ? _buildRestaurantEmpty()
            : _buildRestaurantList(restaurants);
    }
  }

  /// Widget untuk membuat list restaurant jika data berhasil didapatkan
  ListView _buildRestaurantList(List<Restaurant> restaurants) {
    return ListView.separated(
      padding: const EdgeInsets.all(0),
      itemBuilder: (context, index) {
        return Slidable(
          startActionPane: const ActionPane(
            motion: ScrollMotion(),
            children: [
              // A SlidableAction can have an icon and/or a label.
              SlidableAction(
                onPressed: null,
                backgroundColor: Color(0xFFFE4A49),
                foregroundColor: Colors.white,
                icon: Icons.delete,
                label: 'Delete',
              ),
              SlidableAction(
                onPressed: null,
                backgroundColor: Color(0xFF21B7CA),
                foregroundColor: Colors.white,
                icon: Icons.share,
                label: 'Share',
              ),
            ],
          ),
          child: RestaurantCard(restaurant: restaurants[index]),
        );
      },
      separatorBuilder: (context, index) {
        return const Divider(height: 1, thickness: 1);
      },
      itemCount: restaurants.length,
    );
  }

  /// Widget untuk membuat page kosong jika data tidak ditemukan
  CustomInformation _buildRestaurantEmpty() {
    return const CustomInformation(
      imgPath: 'assets/svg/404_Error_cuate.svg',
      title: 'Ups, Restoran Tidak Ditemukan!',
      subtitle: 'Coba masukkan kata kunci lainnya.',
    );
  }
}
