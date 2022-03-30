import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_app/data/models/restaurant.dart';
import 'package:restaurant_app/provider/restaurant_provider.dart';
import 'package:restaurant_app/ui/widgets/restaurant_item.dart';
import 'package:restaurant_app/ui/widgets/search_field.dart';

class HomePage extends StatelessWidget {
  final List<Restaurant> restaurants;

  const HomePage({Key? key, required this.restaurants}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => onWillPop(context),
      child: Scaffold(
        appBar: AppBar(
          title: _buildTitle(context),
          leading: _buildLeading(context),
          actions: _buildActions(context),
          titleSpacing: 0,
          leadingWidth: 68,
          toolbarHeight: 68,
        ),
        body: SafeArea(
          child: _buildBody(context),
        ),
      ),
    );
  }

  Widget _buildTitle(BuildContext context) {
    return context.watch<RestaurantProvider>().isSearching
        ? SearchField(
            query: context.watch<RestaurantProvider>().query,
            hintText: 'Search Restaurants...',
            onChanged: (query) {
              context.read<RestaurantProvider>().searchRestaurants(query);
            },
          )
        : const Text('Restaurant App');
  }

  Widget _buildLeading(BuildContext context) {
    return context.watch<RestaurantProvider>().isSearching
        ? IconButton(
            onPressed: () {
              context.read<RestaurantProvider>().isSearching = false;
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

  List<Widget> _buildActions(BuildContext context) {
    return <Widget>[
      if (!context.watch<RestaurantProvider>().isSearching) ...[
        IconButton(
          onPressed: () {
            context.watch<RestaurantProvider>().isSearching = true;
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

  Widget _buildBody(BuildContext context) {
    // final isSearching = context.watch<RestaurantProvider>().isSearching;
    // final query = context.watch<RestaurantProvider>().query;

    // if (isSearching && query.isNotEmpty) {
    //   restaurants = _restaurantsFromSearch;
    // } else {
    //   restaurants = widget.restaurants;
    // }

    final restaurants = context.watch<RestaurantProvider>().restaurants;

    if (restaurants.isEmpty) {
      return _buildRestaurantEmpty(context);
    }

    return _buildRestaurantList(restaurants);
  }

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
              'Restoran Tidak Ditemukan',
              style: Theme.of(context).textTheme.bodyText1,
            ),
          ],
        ),
      ),
    );
  }

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

  /// melakukan pengecekan, apakah sedang melakukan searching atau tidak.
  ///
  /// * jika iya, maka aplikasi tidak akan keluar jika menekan tombol back pada perangkat,
  /// melainkan akan melakukan reset searching terlebih dahulu.
  /// * jika tidak, aplikasi akan keluar jika menekan tombol back.
  Future<bool> onWillPop(BuildContext context) {
    if (context.watch<RestaurantProvider>().isSearching) {
      context.read<RestaurantProvider>().isSearching = false;

      return Future.value(false);
    }

    return Future.value(true);
  }
}
