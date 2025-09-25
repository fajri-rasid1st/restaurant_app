// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';

// Project imports:
import 'package:restaurant_app/common/enum/restaurant_category.dart';
import 'package:restaurant_app/common/enum/result_state.dart';
import 'package:restaurant_app/common/extensions/text_style_extension.dart';
import 'package:restaurant_app/common/routes/route_names.dart';
import 'package:restaurant_app/common/utilities/asset_path.dart';
import 'package:restaurant_app/common/utilities/navigator_key.dart';
import 'package:restaurant_app/common/utilities/utilities.dart';
import 'package:restaurant_app/models/restaurant.dart';
import 'package:restaurant_app/models/restaurant_favorite.dart';
import 'package:restaurant_app/providers/api_providers/restaurants_provider.dart';
import 'package:restaurant_app/providers/app_providers/is_reload_provider.dart';
import 'package:restaurant_app/providers/app_providers/is_searching_provider.dart';
import 'package:restaurant_app/providers/app_providers/search_query_provider.dart';
import 'package:restaurant_app/providers/app_providers/selected_category_provider.dart';
import 'package:restaurant_app/providers/database_providers/restaurant_database_provider.dart';
import 'package:restaurant_app/ui/pages/error_page.dart';
import 'package:restaurant_app/ui/pages/loading_page.dart';
import 'package:restaurant_app/ui/widgets/category_list.dart';
import 'package:restaurant_app/ui/widgets/custom_information.dart';
import 'package:restaurant_app/ui/widgets/restaurant_card.dart';
import 'package:restaurant_app/ui/widgets/search_field.dart';

class DiscoverPage extends StatelessWidget {
  const DiscoverPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<IsSearchingProvider>(
      builder: (context, provider, child) {
        final isSearching = provider.value;

        return PopScope(
          canPop: !isSearching,
          onPopInvokedWithResult: (didPop, result) {
            if (didPop) return;

            if (isSearching) {
              context.read<IsSearchingProvider>().value = false;
              context.read<SearchQueryProvider>().value = '';
              context.read<RestaurantsProvider>().getRestaurants();
            }
          },
          child: _DiscoverMainWidget(
            isSearching: isSearching,
          ),
        );
      },
    );
  }
}

/// Widget class untuk membuat bagian utama halaman Discover
class _DiscoverMainWidget extends StatelessWidget {
  final bool isSearching;

  const _DiscoverMainWidget({required this.isSearching});

  @override
  Widget build(BuildContext context) {
    return Consumer<RestaurantsProvider>(
      builder: (context, provider, child) {
        return NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) {
            return [
              SliverOverlapAbsorber(
                handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
                sliver: SliverAppBar(
                  pinned: true,
                  titleSpacing: 16,
                  titleTextStyle: Theme.of(context).textTheme.titleLarge!.bold,
                  title: buildAppBarTitle(
                    context: context,
                    isSearching: isSearching,
                  ),
                  leading: buildAppBarLeading(
                    context: context,
                    isSearching: isSearching,
                  ),
                  actions: buildAppBarActions(
                    context: context,
                    isSearching: isSearching,
                    state: provider.state,
                  ),
                ),
              ),
              PinnedHeaderSliver(
                child: buildAppBarBottom(
                  context: context,
                  isSearching: isSearching,
                  state: provider.state,
                ),
              ),
            ];
          },
          body: buildBody(
            restaurants: provider.restaurants,
            state: provider.state,
            message: provider.message,
          ),
        );
      },
    );
  }

  /// Widget untuk membuat title app bar
  Widget buildAppBarTitle({
    required BuildContext context,
    required bool isSearching,
  }) {
    return isSearching
        ? SearchField(
            hintText: 'Search restaurants...',
            onChanged: (query) {
              context.read<SearchQueryProvider>().value = query;
              context.read<RestaurantsProvider>().getRestaurants(query);
            },
          )
        : Text("Restaurant App");
  }

  /// Widget untuk membuat leading app bar
  Widget buildAppBarLeading({
    required BuildContext context,
    required bool isSearching,
  }) {
    return isSearching
        ? IconButton(
            onPressed: () {
              context.read<IsSearchingProvider>().value = false;
              context.read<SearchQueryProvider>().value = '';
              context.read<RestaurantsProvider>().getRestaurants();
            },
            icon: Icon(Icons.arrow_back_rounded),
            tooltip: 'Kembali',
          )
        : Padding(
            padding: EdgeInsets.only(left: 16),
            child: Image.asset(
              AssetPath.getIcon('ic_launcher.png'),
            ),
          );
  }

  /// Widget untuk membuat action app bar
  List<Widget> buildAppBarActions({
    required BuildContext context,
    required bool isSearching,
    required ResultState state,
  }) {
    return [
      if (!isSearching) ...[
        IconButton(
          onPressed: state == ResultState.error
              ? null
              : () {
                  context.read<IsSearchingProvider>().value = true;
                  context.read<SelectedCategoryProvider>().value = RestaurantCategory.all;
                  context.read<RestaurantsProvider>().getRestaurants();
                },
          icon: Icon(
            Icons.search_rounded,
            size: 28,
          ),
          tooltip: 'Search',
        ),
      ],
    ];
  }

  /// Widget untuk membuat list category pada bottom app bar
  Widget buildAppBarBottom({
    required BuildContext context,
    required bool isSearching,
    required ResultState state,
  }) {
    return isSearching || state == ResultState.error
        ? SizedBox.shrink()
        : CategoryList(
            categories: RestaurantCategory.values,
            onCategorySelected: (value) {
              final query = value == RestaurantCategory.all ? null : value.name.toLowerCase();

              context.read<SelectedCategoryProvider>().value = value;
              context.read<RestaurantsProvider>().getRestaurants(query);
            },
          );
  }

  /// Widget untuk membuat body pada NestedScrollView
  Widget buildBody({
    required List<Restaurant> restaurants,
    required ResultState state,
    required String message,
  }) {
    return Consumer<SearchQueryProvider>(
      builder: (context, provider, child) {
        switch (state) {
          case ResultState.loading:
            return LoadingPage();
          case ResultState.error:
            return ErrorPage(
              message: message,
              onRefresh: () => refreshPage(context, provider.value),
            );
          case ResultState.data:
            return _RestaurantListWidget(
              restaurants: restaurants,
            );
        }
      },
    );
  }

  /// Fungsi untuk reload halaman saat data gagal di-fetch
  void refreshPage(
    BuildContext context,
    String query,
  ) {
    context.read<IsReloadProvider>().value = true;

    Future.wait([
          Future.delayed(Duration(milliseconds: 500)),
          context.read<RestaurantsProvider>().getRestaurants(query),
        ])
        .then((_) {
          if (!context.mounted) return;

          context.read<IsReloadProvider>().value = false;
        })
        .catchError((_) {
          if (!context.mounted) return;

          context.read<IsReloadProvider>().value = false;
        });
  }
}

// Widget class untuk menampilkan daftar restaurant
class _RestaurantListWidget extends StatelessWidget {
  final List<Restaurant> restaurants;

  const _RestaurantListWidget({required this.restaurants});

  @override
  Widget build(BuildContext context) {
    return restaurants.isEmpty
        ? CustomInformation(
            assetName: AssetPath.getVector('404_Error_cuate.svg'),
            title: 'Ops, Restoran Tidak Ditemukan.',
            subtitle: 'Coba masukkan kata kunci lain.',
          )
        : CustomScrollView(
            slivers: [
              SliverOverlapInjector(
                handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
              ),
              SlidableAutoCloseBehavior(
                child: SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (_, index) {
                      final count = restaurants.length;
                      final hasSeparator = index != count - 1;

                      return Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          buildRestaurantItem(
                            context: context,
                            restaurant: restaurants[index],
                          ),
                          if (hasSeparator)
                            Divider(
                              height: 1,
                              thickness: 0.5,
                            ),
                        ],
                      );
                    },
                    childCount: restaurants.length,
                  ),
                ),
              ),
            ],
          );
  }

  /// Widget untuk membuat item card restaurant
  Widget buildRestaurantItem({
    required BuildContext context,
    required Restaurant restaurant,
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
            onPressed: (_) => onFavoriteIconPressed(context, restaurant),
            child: Icon(
              restaurant.isFavorited ? Icons.favorite_rounded : Icons.favorite_outline_rounded,
              size: 26,
            ),
          ),
        ],
      ),
      child: RestaurantCard(
        restaurant: restaurant,
        onTap: () => navigatorKey.currentState!.pushNamed(
          Routes.detail,
          arguments: {'id': restaurant.id},
        ),
      ),
    );
  }

  /// Fungsi untuk menambahkan atau menghapus restoran dari daftar favorit
  Future<void> onFavoriteIconPressed(
    BuildContext context,
    Restaurant restaurant,
  ) async {
    // Tambah restoran jika belum ada di favorit, atau hapus jika sudah ada
    if (restaurant.isFavorited) {
      await context.read<RestaurantDatabaseProvider>().removeFromFavorites(
        restaurant.id,
      );
    } else {
      await context.read<RestaurantDatabaseProvider>().addToFavorites(
        RestaurantFavorite.fromRestaurant(restaurant),
      );
    }

    if (!context.mounted) return;

    // Update status isFavorited restoran yang dipilih di daftar restoran
    final restaurants = context.read<RestaurantsProvider>().restaurants;
    final updatedRestaurant = restaurants.firstWhere((item) => item.id == restaurant.id);
    final updatedIndex = restaurants.indexOf(updatedRestaurant);

    restaurants[updatedIndex] = updatedRestaurant.copyWith(
      isFavorited: !updatedRestaurant.isFavorited,
    );

    context.read<RestaurantsProvider>().restaurants = restaurants;

    // Tampilkan snackbar
    Utilities.showSnackBarMessage(
      context: context,
      message: context.read<RestaurantDatabaseProvider>().message,
      action: restaurant.isFavorited
          ? null
          : SnackBarAction(
              label: 'Lihat',
              textColor: Theme.of(context).colorScheme.primaryContainer,
              onPressed: () => navigatorKey.currentState!.pushNamed(Routes.favorites),
            ),
    );
  }
}
