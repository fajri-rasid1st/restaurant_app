// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';

// Project imports:
import 'package:restaurant_app/common/enum/restaurant_category.dart';
import 'package:restaurant_app/common/enum/result_state.dart';
import 'package:restaurant_app/common/extensions/text_style_extension.dart';
import 'package:restaurant_app/common/utilities/asset_path.dart';
import 'package:restaurant_app/data/api/restaurant_api.dart';
import 'package:restaurant_app/data/db/restaurant_database.dart';
import 'package:restaurant_app/data/models/restaurant.dart';
import 'package:restaurant_app/providers/api_providers/restaurant_detail_provider.dart';
import 'package:restaurant_app/providers/api_providers/restaurants_provider.dart';
import 'package:restaurant_app/providers/app_providers/is_reload_provider.dart';
import 'package:restaurant_app/providers/app_providers/is_searching_provider.dart';
import 'package:restaurant_app/providers/app_providers/search_query_provider.dart';
import 'package:restaurant_app/providers/app_providers/selected_category_provider.dart';
import 'package:restaurant_app/ui/pages/detail_page.dart';
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
            tooltip: 'Back',
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
        final query = provider.value;

        switch (state) {
          case ResultState.initial:
            return SizedBox.shrink();
          case ResultState.loading:
            return LoadingPage();
          case ResultState.error:
            return ErrorPage(
              message: message,
              onRefresh: () => refreshPage(context, query),
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
  Future<void> refreshPage(
    BuildContext context,
    String query,
  ) async {
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
                    (context, index) {
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
      startActionPane: ActionPane(
        motion: ScrollMotion(),
        extentRatio: 0.25,
        children: [
          SlidableAction(
            onPressed: (context) {},
            backgroundColor: Theme.of(context).colorScheme.primaryContainer,
            foregroundColor: Theme.of(context).colorScheme.onPrimaryContainer,
            icon: restaurant.isFavorited ? Icons.favorite_rounded : Icons.favorite_outline_rounded,
          ),
        ],
      ),
      child: RestaurantCard(
        restaurant: restaurant,
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ChangeNotifierProvider(
              create: (_) => RestaurantDetailProvider(
                apiService: context.read<RestaurantApi>(),
                databaseService: context.read<RestaurantDatabase>(),
              )..getRestaurantDetail(restaurant.id),
              child: DetailPage(
                restaurantId: restaurant.id,
                heroTag: restaurant.id,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
