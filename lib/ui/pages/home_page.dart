import 'dart:async';

import 'package:flutter/material.dart';
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
  final String _query = '';
  Timer? _debouncer;

  late ScrollController _scrollController;

  @override
  void initState() {
    _scrollController = ScrollController();

    if (_debouncer != null) _debouncer!.cancel();

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
          toolbarHeight: 67,
          titleSpacing: 0,
        ),
        body: SafeArea(
          child: ListView.separated(
            padding: const EdgeInsets.all(16),
            itemBuilder: (context, index) {
              final restaurant = widget.restaurants[index];

              return RestaurantItem(restaurant: restaurant);
            },
            separatorBuilder: (context, index) {
              return const SizedBox(height: 8);
            },
            itemCount: widget.restaurants.length,
          ),
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
              width: 32,
              height: 32,
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

  Future<bool> onWillPop() {
    if (_isSearching) {
      resetSearching();

      return Future.value(false);
    }

    return Future.value(true);
  }

  void resetSearching() {
    setState(() => _isSearching = false);

    _scrollController.animateTo(
      0,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeOut,
    );
  }

  void debounce(VoidCallback callback) {
    if (_debouncer != null) _debouncer!.cancel();

    _debouncer = Timer(const Duration(milliseconds: 500), callback);
  }

  Future<void> searchRestaurant(String query) async {}
}
