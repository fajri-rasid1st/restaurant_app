import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_app/common/result_state.dart';
import 'package:restaurant_app/utilities/utilities.dart';
import 'package:restaurant_app/data/models/restaurant.dart';
import 'package:restaurant_app/providers/category_provider.dart';
import 'package:restaurant_app/providers/database_provider.dart';
import 'package:restaurant_app/providers/favorite_provider.dart';
import 'package:restaurant_app/providers/restaurant_provider.dart';
import 'package:restaurant_app/providers/restaurant_search_provider.dart';
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
  Builder _buildRestaurantList(
    List<Restaurant> restaurants,
    DatabaseProvider databaseProvider,
    FavoriteProvider favoriteProvider,
  ) {
    return Builder(
      builder: (context) {
        return CustomScrollView(
          slivers: <Widget>[
            SliverOverlapInjector(
              handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
            ),
            SlidableAutoCloseBehavior(
              child: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final count = restaurants.length;
                    final hasSeparator = index != count - 1;

                    return Column(
                      children: <Widget>[
                        _buildSlidableTile(
                          restaurants[index],
                          databaseProvider,
                          favoriteProvider,
                        ),
                        if (hasSeparator) ...[
                          const Divider(height: 1, thickness: 1),
                        ]
                      ],
                    );
                  },
                  childCount: restaurants.length,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  /// Widget untuk membuat tile dan menambahkan fitur slidable ke kenan
  Slidable _buildSlidableTile(
    Restaurant restaurant,
    DatabaseProvider databaseProvider,
    FavoriteProvider favoriteProvider,
  ) {
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
