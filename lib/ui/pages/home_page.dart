import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_app/data/models/restaurant.dart';
import 'package:restaurant_app/provider/restaurant_provider.dart';
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
    return Consumer<RestaurantProvider>(
      builder: (context, value, child) {
        return WillPopScope(
          // Melakukan pengecekan, apakah sedang melakukan searching atau tidak?
          //
          // * jika iya, maka aplikasi tidak akan keluar jika menekan tombol back
          //   pada perangkat, melainkan akan melakukan reset searching terlebih dahulu.
          // * jika tidak, aplikasi akan keluar jika menekan tombol back.
          onWillPop: () {
            if (value.isSearching) {
              value.isSearching = false;

              return Future.value(false);
            }

            return Future.value(true);
          },
          child: Scaffold(
            appBar: AppBar(
              title: value.isSearching
                  ? SearchField(
                      query: value.query,
                      hintText: 'Search Restaurants, Categories, or Menu',
                      onChanged: (query) {
                        debounce(() => value.searchRestaurants(query));
                      },
                    )
                  : const Text('Restaurant App'),
              leading: value.isSearching
                  ? IconButton(
                      onPressed: () => value.isSearching = false,
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
                    ),
              actions: <Widget>[
                if (!value.isSearching) ...[
                  IconButton(
                    onPressed: () => value.isSearching = true,
                    icon: const Icon(
                      Icons.search_rounded,
                      size: 28,
                    ),
                    tooltip: 'Search',
                  )
                ]
              ],
              titleSpacing: 0,
              leadingWidth: 68,
              toolbarHeight: 68,
            ),
            body: SafeArea(
              child: Builder(
                builder: (context) {
                  var restaurants = <Restaurant>[];

                  if (value.isSearching && value.query.isNotEmpty) {
                    restaurants = value.restaurantFromSearch;
                  } else {
                    restaurants = value.restaurants;
                  }

                  return restaurants.isEmpty
                      ? _buildRestaurantEmpty(context)
                      : _buildRestaurantList(restaurants);
                },
              ),
            ),
          ),
        );
      },
    );
  }

  /// Widget untuk membuat page kosong jika data tidak ditemukan.
  Center _buildRestaurantEmpty(BuildContext context) {
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

  /// Widget untuk membuat list restaurant jika data berhasil didapatkan.
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
}
