import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_app/data/models/restaurant.dart';
import 'package:restaurant_app/provider/restaurant_provider.dart';
import 'package:restaurant_app/provider/restaurant_search_provider.dart';
import 'package:restaurant_app/ui/widgets/restaurant_item.dart';
import 'package:restaurant_app/ui/widgets/search_field.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Timer? _debouncer;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    if (_debouncer != null) _debouncer!.cancel();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<RestaurantProvider, RestaurantSearchProvider>(
      builder: (context, restaurantProvider, searchProvider, child) {
        return WillPopScope(
          onWillPop: () => onWillPop(searchProvider),
          child: Scaffold(
            appBar: AppBar(
              title: _buildTitle(searchProvider),
              leading: _buildLeading(searchProvider),
              actions: _buildActions(searchProvider, restaurantProvider),
              titleSpacing: 0,
              leadingWidth: 68,
              toolbarHeight: 68,
            ),
            body: _buildBody(searchProvider, restaurantProvider),
          ),
        );
      },
    );
  }

  /// Widget untuk membuat appbar title
  Widget _buildTitle(RestaurantSearchProvider searchProvider) {
    return searchProvider.isSearching
        ? SearchField(
            query: searchProvider.query,
            hintText: 'Search Restaurants, Categories, or Menu',
            onChanged: (query) {
              debounce(() => searchProvider.searchRestaurants(query));
            },
          )
        : const Text('Restaurant App');
  }

  /// Widget untuk membuat appbar leading
  Widget _buildLeading(RestaurantSearchProvider searchProvider) {
    return searchProvider.isSearching
        ? IconButton(
            onPressed: () => searchProvider.isSearching = false,
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

  /// Widget untuk membuat appbar action
  List<Widget> _buildActions(
    RestaurantSearchProvider searchProvider,
    RestaurantProvider restaurantProvider,
  ) {
    return <Widget>[
      if (!searchProvider.isSearching) ...[
        IconButton(
          onPressed: () {
            searchProvider.isSearching = true;
            searchProvider.restaurants = restaurantProvider.restaurants;
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

  /// Widget untuk membuat body
  Builder _buildBody(
    RestaurantSearchProvider searchProvider,
    RestaurantProvider restaurantProvider,
  ) {
    return Builder(
      builder: (context) {
        var restaurants = <Restaurant>[];

        if (searchProvider.isSearching && searchProvider.query.isNotEmpty) {
          restaurants = searchProvider.restaurants;
        } else {
          restaurants = restaurantProvider.restaurants;
        }

        return restaurants.isEmpty
            ? _buildRestaurantEmpty()
            : _buildRestaurantList(restaurants);
      },
    );
  }

  /// Widget untuk membuat page kosong jika data tidak ditemukan
  Center _buildRestaurantEmpty() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Stack(
          alignment: AlignmentDirectional.bottomCenter,
          children: <Widget>[
            SvgPicture.asset(
              'assets/svg/404_Error_cuate.svg',
              width: 300,
              fit: BoxFit.fill,
            ),
            Text(
              'Oops, Restoran Tidak Ditemukan!',
              style: Theme.of(context).textTheme.bodyText1,
            ),
          ],
        ),
      ),
    );
  }

  /// Widget untuk membuat list restaurant jika data berhasil didapatkan
  ListView _buildRestaurantList(List<Restaurant> restaurants) {
    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemBuilder: (context, index) {
        return RestaurantItem(restaurant: restaurants[index]);
      },
      separatorBuilder: (context, index) {
        return const SizedBox(height: 12);
      },
      itemCount: restaurants.length,
    );
  }

  /// Method untuk memberikan jeda saat melakukan searching selama 0.5 detik
  /// untuk mencegah pemanggilan method GET secara terus-menerus.
  void debounce(VoidCallback callback) {
    if (_debouncer != null) _debouncer!.cancel();

    _debouncer = Timer(const Duration(milliseconds: 500), callback);
  }

  // Melakukan pengecekan, apakah sedang melakukan searching atau tidak?
  //
  // * jika iya, maka aplikasi tidak akan keluar jika menekan tombol back
  //   pada perangkat, melainkan akan melakukan reset searching terlebih dahulu.
  // * jika tidak, aplikasi akan keluar jika menekan tombol back.
  Future<bool> onWillPop(RestaurantSearchProvider searchProvider) {
    if (searchProvider.isSearching) {
      searchProvider.isSearching = false;

      return Future.value(false);
    }

    return Future.value(true);
  }
}
