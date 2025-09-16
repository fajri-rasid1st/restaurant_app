// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:provider/provider.dart';

// Project imports:
import 'package:restaurant_app/common/enum/restaurant_category.dart';
import 'package:restaurant_app/common/enum/result_state.dart';
import 'package:restaurant_app/common/utilities/asset_path.dart';
import 'package:restaurant_app/common/utilities/utilities.dart';
import 'package:restaurant_app/data/models/restaurant.dart';
import 'package:restaurant_app/providers/app_providers/is_reload_provider.dart';
import 'package:restaurant_app/providers/app_providers/is_searching_provider.dart';
import 'package:restaurant_app/providers/app_providers/search_query_provider.dart';
import 'package:restaurant_app/providers/app_providers/selected_category_provider.dart';
import 'package:restaurant_app/providers/service_providers/restaurants_provider.dart';
import 'package:restaurant_app/ui/pages/error_page.dart';
import 'package:restaurant_app/ui/pages/loading_page.dart';
import 'package:restaurant_app/ui/widgets/category_list.dart';
import 'package:restaurant_app/ui/widgets/custom_information.dart';
import 'package:restaurant_app/ui/widgets/restaurant_card.dart';
import 'package:restaurant_app/ui/widgets/search_field.dart';

class MainPage extends StatelessWidget {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<IsSearchingProvider>(
      builder: (context, provider, child) {
        return PopScope(
          canPop: false,
          onPopInvokedWithResult: (didPop, result) {
            if (didPop) return;

            if (provider.value) {
              context.read<IsSearchingProvider>().value = false;
              context.read<SearchQueryProvider>().value = '';
            }
          },
          child: Scaffold(
            resizeToAvoidBottomInset: false,
            body: buildScaffoldBody(
              context: context,
              isSearching: provider.value,
            ),
          ),
        );
      },
    );
  }

  /// Widget untuk membuat NestedScrollView yang diisi SliverAppBar dan body
  Widget buildScaffoldBody({
    required BuildContext context,
    required bool isSearching,
  }) {
    return Consumer<RestaurantsProvider>(
      builder: (context, provider, child) {
        return NestedScrollView(
          floatHeaderSlivers: true,
          headerSliverBuilder: (_, __) {
            return [
              SliverOverlapAbsorber(
                handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
                sliver: SliverSafeArea(
                  top: false,
                  sliver: SliverAppBar(
                    floating: true,
                    pinned: true,
                    snap: true,
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
                    bottom: buildAppBarBottom(
                      context: context,
                      isSearching: isSearching,
                      state: provider.state,
                    ),
                    titleSpacing: 0,
                    leadingWidth: 68,
                  ),
                ),
              ),
            ];
          },
          body: buildMainBody(
            context: context,
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
            hintText: 'Search Restaurants or Menu',
            onChanged: (query) {
              context.read<SearchQueryProvider>().value = query;
              context.read<RestaurantsProvider>().getRestaurants(query);
            },
          )
        : Text("Daftar Restoran");
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
            },
            icon: Icon(
              Icons.arrow_back_rounded,
              size: 28,
            ),
            tooltip: 'Back',
          )
        : Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Image.asset(
              AssetPath.getIcon('ic_launcher.png'),
              width: 48,
              height: 48,
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
  PreferredSizeWidget? buildAppBarBottom({
    required BuildContext context,
    required bool isSearching,
    required ResultState state,
  }) {
    return isSearching || state == ResultState.error
        ? null
        : PreferredSize(
            preferredSize: Size.fromHeight(60),
            child: CategoryList(
              categories: RestaurantCategory.values,
              onCategorySelected: (value) {
                final query = value == RestaurantCategory.all ? null : value.name.toLowerCase();

                context.read<SelectedCategoryProvider>().value = value;
                context.read<RestaurantsProvider>().getRestaurants(query);
              },
            ),
          );
  }

  /// Widget untuk membuat body pada NestedScrollView
  Widget buildMainBody({
    required BuildContext context,
    required List<Restaurant> restaurants,
    required ResultState state,
    required String message,
  }) {
    switch (state) {
      case ResultState.initial:
        return SizedBox.shrink();
      case ResultState.loading:
        return LoadingPage();
      case ResultState.error:
        return Consumer<SearchQueryProvider>(
          builder: (context, provider, child) {
            return ErrorPage(
              message: message,
              onRefresh: () => refreshPage(context, provider.value),
            );
          },
        );
      case ResultState.data:
        if (restaurants.isEmpty) {
          return buildRestaurantEmpty();
        }

        return buildRestaurantList(
          context: context,
          restaurants: restaurants,
        );
    }
  }

  /// Widget untuk membuat page kosong jika data tidak ditemukan/tidak ada
  Widget buildRestaurantEmpty() {
    return CustomInformation(
      assetName: AssetPath.getVector('404_Error_cuate.svg'),
      title: 'Ops, Restoran Tidak Ditemukan.',
      subtitle: 'Coba masukkan kata kunci lain.',
    );
  }

  /// Widget untuk membuat daftar restoran jika data tidak kosong
  Widget buildRestaurantList({
    required BuildContext context,
    required List<Restaurant> restaurants,
  }) {
    return CustomScrollView(
      slivers: [
        SliverOverlapInjector(
          handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
        ),
        SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) {
              final count = restaurants.length;
              final hasSeparator = index != count - 1;

              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  RestaurantCard(
                    restaurant: restaurants[index],
                    onTap: () {},
                  ),
                  if (hasSeparator)
                    Divider(
                      height: 1,
                      thickness: 1,
                    ),
                ],
              );
            },
            childCount: restaurants.length,
          ),
        ),
      ],
    );
  }

  /// Fungsi untuk reload halaman saat data gagal di-fetch
  Future<void> refreshPage(
    BuildContext context,
    String searchQuery,
  ) async {
    context.read<IsReloadProvider>().value = true;

    Future.wait([
          Future.delayed(Duration(milliseconds: 500)),
          context.read<RestaurantsProvider>().getRestaurants(searchQuery),
        ])
        .then((_) {
          if (!context.mounted) return;

          context.read<IsReloadProvider>().value = false;
        })
        .catchError((_) {
          if (!context.mounted) return;

          context.read<IsReloadProvider>().value = false;

          Utilities.showSnackBarMessage(
            context: context,
            text: 'Gagal memuat daftar restoran',
          );
        });
  }
}
