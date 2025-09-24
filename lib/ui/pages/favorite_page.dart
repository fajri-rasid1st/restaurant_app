// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';

// Project imports:
import 'package:restaurant_app/common/extensions/text_style_extension.dart';
import 'package:restaurant_app/common/utilities/asset_path.dart';
import 'package:restaurant_app/common/utilities/utilities.dart';
import 'package:restaurant_app/data/api/restaurant_api.dart';
import 'package:restaurant_app/data/db/restaurant_database.dart';
import 'package:restaurant_app/data/models/restaurant.dart';
import 'package:restaurant_app/data/models/restaurant_favorite.dart';
import 'package:restaurant_app/providers/api_providers/restaurant_detail_provider.dart';
import 'package:restaurant_app/providers/api_providers/restaurants_provider.dart';
import 'package:restaurant_app/providers/database_providers/restaurant_database_provider.dart';
import 'package:restaurant_app/ui/pages/detail_page.dart';
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
          onPressed: () => Navigator.pop(context),
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
                          (context, index) {
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

  /// Widget untuk membuat item card restaurant favorit
  Widget buildFavoriteItem({
    required BuildContext context,
    required RestaurantFavorite favorite,
  }) {
    return Slidable(
      groupTag: 0,
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
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ChangeNotifierProvider(
              create: (_) => RestaurantDetailProvider(
                apiService: context.read<RestaurantApi>(),
                databaseService: context.read<RestaurantDatabase>(),
              )..getRestaurantDetail(favorite.restaurantId),
              child: DetailPage(
                restaurantId: favorite.restaurantId,
                heroTag: favorite.restaurantId,
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// Fungsi untuk menghapus restoran dari daftar favorit
  Future<void> onFavoriteIconPressed(
    BuildContext context,
    RestaurantFavorite favorite,
  ) async {
    // Tambah restoran jika belum ada di favorit, atau hapus jika sudah ada
    await context.read<RestaurantDatabaseProvider>().removeFromFavorites(favorite.restaurantId);

    if (!context.mounted) return;

    // Update status isFavorited pada restoran yang dipilih
    final restaurants = context.read<RestaurantsProvider>().restaurants;
    final updatedRestaurant = restaurants.firstWhere((item) => item.id == favorite.restaurantId);
    final updatedIndex = restaurants.indexOf(updatedRestaurant);

    restaurants[updatedIndex] = updatedRestaurant.copyWith(isFavorited: !updatedRestaurant.isFavorited);

    context.read<RestaurantsProvider>().restaurants = restaurants;

    // Tampilkan snackbar
    Utilities.showSnackBarMessage(
      context: context,
      message: context.read<RestaurantDatabaseProvider>().message,
      action: SnackBarAction(
        label: 'Undo',
        textColor: Theme.of(context).colorScheme.primaryContainer,
        onPressed: () {},
      ),
    );
  }
}
