import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:restaurant_app/data/api/restaurant_api.dart';
import 'package:restaurant_app/data/models/restaurant.dart';
import 'package:restaurant_app/ui/widgets/restaurant_item.dart';
import 'package:restaurant_app/ui/widgets/search_field.dart';

class HomePage extends StatefulWidget {
  final List<Restaurant> restaurants;

  const HomePage({Key? key, required this.restaurants}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _isSearching = false;
  String _query = '';
  List<Restaurant> _restaurantsFromSearch = <Restaurant>[];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: onWillPop,
      child: Scaffold(
        appBar: AppBar(
          title: _buildTitle(),
          leading: _buildLeading(),
          actions: _buildActions(),
          titleSpacing: 0,
          leadingWidth: 68,
          toolbarHeight: 68,
        ),
        body: SafeArea(
          child: _buildBody(),
        ),
      ),
    );
  }

  Widget _buildTitle() {
    return _isSearching
        ? SearchField(
            query: _query,
            hintText: 'Search Restaurants...',
            onChanged: searchRestaurant,
          )
        : const Text('Restaurant App');
  }

  Widget _buildLeading() {
    return _isSearching
        ? IconButton(
            onPressed: () => resetSearching(),
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

  List<Widget> _buildActions() {
    return <Widget>[
      if (!_isSearching) ...[
        IconButton(
          onPressed: () => setState(() => _isSearching = true),
          icon: const Icon(
            Icons.search_rounded,
            size: 28,
          ),
          tooltip: 'Search',
        )
      ]
    ];
  }

  Widget _buildBody() {
    List<Restaurant> restaurants;

    if (_isSearching && _query.isNotEmpty) {
      restaurants = _restaurantsFromSearch;
    } else {
      restaurants = widget.restaurants;
    }

    if (restaurants.isEmpty) {
      return _buildRestaurantEmpty();
    }

    return _buildRestaurantList(restaurants);
  }

  Center _buildRestaurantEmpty() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
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

  Future<void> searchRestaurant(String query) async {
    final restaurants = await RestaurantApi.searchRestaurants(query);

    setState(() {
      _query = query;
      _restaurantsFromSearch = restaurants;
    });
  }

  void resetSearching() {
    setState(() {
      _isSearching = false;
      _restaurantsFromSearch = widget.restaurants;
    });
  }

  Future<bool> onWillPop() {
    if (_isSearching) {
      resetSearching();

      return Future.value(false);
    }

    return Future.value(true);
  }
}
