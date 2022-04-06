import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_app/common/result_state.dart';
import 'package:restaurant_app/common/utilities.dart';
import 'package:restaurant_app/data/models/restaurant.dart';
import 'package:restaurant_app/provider/category_provider.dart';
import 'package:restaurant_app/provider/database_provider.dart';
import 'package:restaurant_app/provider/favorite_provider.dart';
import 'package:restaurant_app/provider/restaurant_provider.dart';
import 'package:restaurant_app/provider/restaurant_search_provider.dart';
import 'package:restaurant_app/ui/screens/error_screen.dart';
import 'package:restaurant_app/ui/screens/loading_screen.dart';
import 'package:restaurant_app/ui/themes/color_scheme.dart';
import 'package:restaurant_app/ui/widgets/custom_information.dart';
import 'package:restaurant_app/ui/widgets/restaurant_card.dart';

class DiscoverPage extends StatelessWidget {
  const DiscoverPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer5<RestaurantProvider, RestaurantSearchProvider,
        CategoryProvider, DatabaseProvider, FavoriteProvider>(
      builder: (
        context,
        restaurantProvider,
        searchProvider,
        categoryProvider,
        databaseProvider,
        favoriteProvider,
        child,
      ) {
        return _buildMainPage(
          restaurantProvider,
          searchProvider,
          categoryProvider,
          databaseProvider,
          favoriteProvider,
        );
      },
    );
  }

  /// Widget untuk membuat tampilan utama
  Widget _buildMainPage(
    RestaurantProvider restaurantProvider,
    RestaurantSearchProvider searchProvider,
    CategoryProvider categoryProvider,
    DatabaseProvider databaseProvider,
    FavoriteProvider favoriteProvider,
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
            : _buildRestaurantList(
                restaurants,
                databaseProvider,
                favoriteProvider,
              );
    }
  }

  /// Widget untuk membuat list restaurant jika data berhasil didapatkan
  SlidableAutoCloseBehavior _buildRestaurantList(
    List<Restaurant> restaurants,
    DatabaseProvider databaseProvider,
    FavoriteProvider favoriteProvider,
  ) {
    return SlidableAutoCloseBehavior(
      child: ListView.separated(
        key: const PageStorageKey<String>('restaurant_list'),
        padding: const EdgeInsets.all(0),
        itemBuilder: (context, index) {
          final restaurant = restaurants[index];

          return Slidable(
            groupTag: 0,
            startActionPane: ActionPane(
              motion: const ScrollMotion(),
              children: [
                SlidableAction(
                  onPressed: (context) {
                    Utilities.navigateToDetailScreen(
                      context: context,
                      restaurant: restaurant,
                    );
                  },
                  icon: Icons.open_in_new_rounded,
                  foregroundColor: backGroundColor,
                  backgroundColor: primaryColor,
                ),
                SlidableAction(
                  onPressed: (context) {
                    databaseProvider
                        .isFavoriteAlreadyExist(restaurant.id)
                        .then((isExist) {
                      if (isExist) {
                        Utilities.showSnackBarMessage(
                          context: context,
                          text: 'Sudah ada di daftar favorite Anda.',
                        );
                      } else {
                        Utilities.addToFavorite(
                          context: context,
                          databaseProvider: databaseProvider,
                          favoriteProvider: favoriteProvider,
                          restaurant: restaurant,
                        );
                      }
                    });
                  },
                  icon: Icons.add_rounded,
                  foregroundColor: primaryColor,
                  backgroundColor: secondaryColor,
                ),
              ],
            ),
            child: RestaurantCard(restaurant: restaurant),
          );
        },
        separatorBuilder: (context, index) {
          return const Divider(height: 1, thickness: 1);
        },
        itemCount: restaurants.length,
      ),
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
