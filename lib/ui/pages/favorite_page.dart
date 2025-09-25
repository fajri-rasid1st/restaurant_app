// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';

// Project imports:
import 'package:restaurant_app/common/extensions/text_style_extension.dart';
import 'package:restaurant_app/common/routes/route_names.dart';
import 'package:restaurant_app/common/utilities/asset_path.dart';
import 'package:restaurant_app/common/utilities/navigator_key.dart';
import 'package:restaurant_app/common/utilities/utilities.dart';
import 'package:restaurant_app/models/restaurant.dart';
import 'package:restaurant_app/models/restaurant_favorite.dart';
import 'package:restaurant_app/providers/api_providers/restaurants_provider.dart';
import 'package:restaurant_app/providers/database_providers/restaurant_database_provider.dart';
import 'package:restaurant_app/ui/widgets/custom_information.dart';
import 'package:restaurant_app/ui/widgets/restaurant_card.dart';
import 'package:restaurant_app/ui/widgets/scaffold_safe_area.dart';

class FavoritePage extends StatelessWidget {
  const FavoritePage({super.key});

  @override
  Widget build(BuildContext context) {
    return ScaffoldSafeArea(
      appBar: AppBar(
        title: Text('Favorites'),
        titleTextStyle: Theme.of(context).textTheme.titleLarge!.bold,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_rounded),
          tooltip: 'Kembali',
          onPressed: () => navigatorKey.currentState!.pop(),
        ),
      ),
      body: Consumer<RestaurantDatabaseProvider>(
        builder: (context, provider, child) {
          final favorites = provider.favorites;

          return favorites.isEmpty
              ? CustomInformation(
                  assetName: AssetPath.getVector('No_data_cuate.svg'),
                  title: 'Belum Ada Favorit Nih!',
                  subtitle: 'Restoran yang Anda like akan muncul di sini.',
                )
              : CustomScrollView(
                  slivers: [
                    SlidableAutoCloseBehavior(
                      child: SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (_, index) {
                            final count = favorites.length;
                            final hasSeparator = index != count - 1;

                            return Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                buildFavoriteItem(
                                  context: context,
                                  favorite: favorites[index],
                                ),
                                if (hasSeparator)
                                  Divider(
                                    height: 1,
                                    thickness: 0.5,
                                  ),
                              ],
                            );
                          },
                          childCount: favorites.length,
                        ),
                      ),
                    ),
                  ],
                );
        },
      ),
    );
  }

  /// Widget untuk membuat item card restoran favorit
  Widget buildFavoriteItem({
    required BuildContext context,
    required RestaurantFavorite favorite,
  }) {
    return Slidable(
      groupTag: 1,
      endActionPane: ActionPane(
        motion: ScrollMotion(),
        extentRatio: 0.25,
        children: [
          CustomSlidableAction(
            backgroundColor: Theme.of(context).colorScheme.primaryContainer,
            foregroundColor: Theme.of(context).colorScheme.onPrimaryContainer,
            onPressed: (_) => onFavoriteIconPressed(context, favorite),
            child: Icon(
              Icons.favorite_rounded,
              size: 26,
            ),
          ),
        ],
      ),
      child: RestaurantCard(
        restaurant: Restaurant.fromFavorite(favorite),
        onTap: () => navigatorKey.currentState!.pushNamed(
          Routes.detail,
          arguments: {'id': favorite.restaurantId},
        ),
      ),
    );
  }

  /// Fungsi untuk menghapus restoran dari daftar favorit
  Future<void> onFavoriteIconPressed(
    BuildContext context,
    RestaurantFavorite favorite,
  ) async {
    // Hapus restoran dari daftar favorit
    await context.read<RestaurantDatabaseProvider>().removeFromFavorites(favorite.restaurantId);

    if (!context.mounted) return;

    // Update status isFavorited pada restoran yang dipilih di daftar restoran
    updateRestaurantList(context, favorite.restaurantId);

    // Tampilkan snackbar
    Utilities.showSnackBarMessage(
      context: context,
      message: context.read<RestaurantDatabaseProvider>().message,
      action: SnackBarAction(
        label: 'Undo',
        textColor: Theme.of(context).colorScheme.primaryContainer,
        onPressed: () async {
          // Tambah kembali restoran ke daftar favorit
          await context.read<RestaurantDatabaseProvider>().addToFavorites(favorite);

          if (!context.mounted) return;

          // Update status isFavorited pada restoran yang dipilih di daftar restoran
          updateRestaurantList(context, favorite.restaurantId);
        },
      ),
    );
  }

  /// Fungsi untuk mengupdate status isFavorited pada restoran yang dipilih
  void updateRestaurantList(
    BuildContext context,
    String restaurantId,
  ) {
    final restaurants = context.read<RestaurantsProvider>().restaurants;
    final updatedRestaurant = restaurants.firstWhere((item) => item.id == restaurantId);
    final updatedIndex = restaurants.indexOf(updatedRestaurant);

    restaurants[updatedIndex] = updatedRestaurant.copyWith(
      isFavorited: !updatedRestaurant.isFavorited,
    );

    context.read<RestaurantsProvider>().restaurants = restaurants;
  }
}
