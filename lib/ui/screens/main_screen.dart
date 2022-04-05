import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_app/common/const.dart';
import 'package:restaurant_app/common/result_state.dart';
import 'package:restaurant_app/provider/bottom_nav_provider.dart';
import 'package:restaurant_app/provider/category_provider.dart';
import 'package:restaurant_app/provider/restaurant_provider.dart';
import 'package:restaurant_app/provider/restaurant_search_provider.dart';
import 'package:restaurant_app/ui/pages/discover_page.dart';
import 'package:restaurant_app/ui/pages/settings_page.dart';
import 'package:restaurant_app/ui/screens/favorite_screen.dart';
import 'package:restaurant_app/ui/themes/color_scheme.dart';
import 'package:restaurant_app/ui/widgets/category_list.dart';
import 'package:restaurant_app/ui/widgets/search_field.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  Timer? _debouncer;

  final List<Widget> _pages = <Widget>[
    const DiscoverPage(),
    const SettingsPage(),
  ];

  @override
  void dispose() {
    super.dispose();

    _debouncer?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    final isFabVisible = MediaQuery.of(context).viewInsets.bottom == 0;

    return Consumer4<RestaurantProvider, RestaurantSearchProvider,
        CategoryProvider, BottomNavProvider>(
      builder: (
        context,
        restaurantProvider,
        searchProvider,
        categoryProvider,
        bottomNavProvider,
        child,
      ) {
        return WillPopScope(
          onWillPop: () => onWillPop(restaurantProvider, searchProvider),
          child: Scaffold(
            resizeToAvoidBottomInset: false,
            body: NestedScrollView(
              floatHeaderSlivers: true,
              headerSliverBuilder: (BuildContext context, bool scrolled) {
                return <Widget>[
                  SliverAppBar(
                    floating: true,
                    pinned: true,
                    title: _buildTitle(searchProvider, bottomNavProvider),
                    leading: _buildLeading(restaurantProvider, searchProvider),
                    actions: _buildActions(
                      restaurantProvider,
                      searchProvider,
                      categoryProvider,
                    ),
                    bottom: _buildBottom(restaurantProvider, searchProvider),
                    titleSpacing: 0,
                    leadingWidth: 68,
                  )
                ];
              },
              body: _buildBody(bottomNavProvider),
            ),
            bottomNavigationBar: _buildBottomNav(bottomNavProvider),
            floatingActionButton: isFabVisible ? _buildFab(context) : null,
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerDocked,
          ),
        );
      },
    );
  }

  Widget _buildTitle(
    RestaurantSearchProvider searchProvider,
    BottomNavProvider bottomNavProvider,
  ) {
    return searchProvider.isSearching
        ? SearchField(
            hintText: 'Search Restaurants, Categories, or Menu',
            onChanged: (query) {
              debounce(() => searchProvider.searchRestaurants(query));
            },
          )
        : Text(bottomNavProvider.title);
  }

  Widget _buildLeading(
    RestaurantProvider restaurantProvider,
    RestaurantSearchProvider searchProvider,
  ) {
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

  List<Widget> _buildActions(
    RestaurantProvider restaurantProvider,
    RestaurantSearchProvider searchProvider,
    CategoryProvider categoryProvider,
  ) {
    return <Widget>[
      if (!searchProvider.isSearching) ...[
        IconButton(
          onPressed: restaurantProvider.state == ResultState.error
              ? null
              : () {
                  searchProvider.isSearching = true;
                  categoryProvider.index = -1;
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

  Widget _buildBody(BottomNavProvider bottomNavProvider) {
    return _pages[bottomNavProvider.index];
  }

  BottomNavigationBar _buildBottomNav(BottomNavProvider bottomNavProvider) {
    return BottomNavigationBar(
      currentIndex: bottomNavProvider.index,
      selectedFontSize: 12,
      selectedItemColor: primaryColor,
      selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold),
      unselectedFontSize: 12,
      unselectedItemColor: secondaryTextColor,
      type: BottomNavigationBarType.fixed,
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.explore_outlined),
          activeIcon: Icon(Icons.explore),
          label: 'Discover',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.settings_outlined),
          activeIcon: Icon(Icons.settings),
          label: 'Settings',
        ),
      ],
      onTap: (index) {
        setState(() {
          bottomNavProvider.index = index;

          switch (bottomNavProvider.index) {
            case 0:
              bottomNavProvider.title = 'Restaurant App';

              break;
            case 1:
              bottomNavProvider.title = 'Settings';

              break;
          }
        });
      },
    );
  }

  FloatingActionButton _buildFab(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const FavoriteScreen()),
        );
      },
      child: const Icon(Icons.favorite_rounded),
      tooltip: 'Favorite',
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
    RestaurantProvider restaurantProvider,
    RestaurantSearchProvider searchProvider,
  ) {
    if (searchProvider.isSearching) {
      searchProvider.isSearching = false;

      return Future.value(false);
    }

    return Future.value(true);
  }
}
