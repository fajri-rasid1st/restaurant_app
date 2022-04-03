import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_app/common/const.dart';
import 'package:restaurant_app/common/result_state.dart';
import 'package:restaurant_app/data/models/restaurant.dart';
import 'package:restaurant_app/provider/category_provider.dart';
import 'package:restaurant_app/provider/restaurant_provider.dart';
import 'package:restaurant_app/provider/restaurant_search_provider.dart';
import 'package:restaurant_app/ui/screens/error_screen.dart';
import 'package:restaurant_app/ui/screens/loading_screen.dart';
import 'package:restaurant_app/ui/widgets/category_list.dart';
import 'package:restaurant_app/ui/widgets/custom_information.dart';
import 'package:restaurant_app/ui/widgets/restaurant_card.dart';
import 'package:restaurant_app/ui/widgets/search_field.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  Timer? _debouncer;

  @override
  void dispose() {
    _debouncer?.cancel();

    super.dispose();
  }

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
        return WillPopScope(
          onWillPop: () => onWillPop(searchProvider, restaurantProvider),
          child: Scaffold(
            resizeToAvoidBottomInset: false,
            body: NestedScrollView(
              floatHeaderSlivers: true,
              headerSliverBuilder: (BuildContext context, bool scrolled) {
                return <Widget>[
                  SliverAppBar(
                    floating: true,
                    pinned: true,
                    title: _buildTitle(searchProvider),
                    leading: _buildLeading(searchProvider, restaurantProvider),
                    actions: _buildActions(
                      searchProvider,
                      restaurantProvider,
                      categoryProvider,
                    ),
                    bottom: _buildBottom(restaurantProvider, searchProvider),
                    titleSpacing: 0,
                    leadingWidth: 68,
                  )
                ];
              },
              body: _buildBody(
                restaurantProvider,
                searchProvider,
                categoryProvider,
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildTitle(RestaurantSearchProvider searchProvider) {
    return searchProvider.isSearching
        ? SearchField(
            hintText: 'Search Restaurants, Categories, or Menu',
            onChanged: (query) {
              debounce(() => searchProvider.searchRestaurants(query));
            },
          )
        : const Text('Restaurant App');
  }

  Widget _buildLeading(
    RestaurantSearchProvider searchProvider,
    RestaurantProvider restaurantProvider,
  ) {
    return searchProvider.isSearching
        ? IconButton(
            onPressed: () {
              searchProvider.restaurants = restaurantProvider.restaurants;
              searchProvider.isSearching = false;
            },
            icon: const Icon(
              Icons.arrow_back_rounded,
              size: 28,
            ),
            tooltip: 'Back',
          )
        : Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Image.asset(
              'assets/img/restaurant_icon.png',
              color: Colors.white,
            ),
          );
  }

  List<Widget> _buildActions(
    RestaurantSearchProvider searchProvider,
    RestaurantProvider restaurantProvider,
    CategoryProvider categoryProvider,
  ) {
    return <Widget>[
      if (!searchProvider.isSearching) ...[
        IconButton(
          onPressed: restaurantProvider.state == ResultState.error
              ? null
              : () {
                  categoryProvider.index = 0;
                  searchProvider.restaurants = restaurantProvider.restaurants;
                  searchProvider.isSearching = true;
                },
          icon: const Icon(
            Icons.search_rounded,
            size: 28,
          ),
          tooltip: 'Search',
        )
      ]
    ];
  }

  CategoryList? _buildBottom(
    RestaurantProvider restaurantProvider,
    RestaurantSearchProvider searchProvider,
  ) {
    return restaurantProvider.state == ResultState.error
        ? null
        : searchProvider.isSearching == true
            ? null
            : const CategoryList(categories: Const.categories);
  }

  /// Widget untuk membuat tampilan utama
  Widget _buildBody(
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
        return RestaurantCard(restaurant: restaurants[index]);
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

  /// Method untuk memberikan jeda saat melakukan searching selama 0.5 detik
  /// untuk mencegah pemanggilan method GET secara terus-menerus.
  void debounce(VoidCallback callback) {
    _debouncer?.cancel();

    _debouncer = Timer(const Duration(milliseconds: 500), callback);
  }

  // Melakukan pengecekan, apakah sedang melakukan searching atau tidak?
  //
  // * jika iya, maka aplikasi tidak akan keluar jika menekan tombol back
  //   pada perangkat, melainkan akan melakukan reset searching terlebih dahulu.
  // * jika tidak, aplikasi akan keluar jika menekan tombol back.
  Future<bool> onWillPop(
    RestaurantSearchProvider searchProvider,
    RestaurantProvider restaurantProvider,
  ) {
    if (searchProvider.isSearching) {
      searchProvider.restaurants = restaurantProvider.restaurants;
      searchProvider.isSearching = false;

      return Future.value(false);
    }

    return Future.value(true);
  }
}
