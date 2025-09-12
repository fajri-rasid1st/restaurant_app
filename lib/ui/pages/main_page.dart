import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_app/common/const.dart';
import 'package:restaurant_app/common/result_state.dart';
import 'package:restaurant_app/data/api/notification_api.dart';
import 'package:restaurant_app/providers/bottom_nav_provider.dart';
import 'package:restaurant_app/providers/category_provider.dart';
import 'package:restaurant_app/providers/restaurant_provider.dart';
import 'package:restaurant_app/providers/restaurant_search_provider.dart';
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
  final NotificationApi _notificationApi = NotificationApi();

  final List<Widget> _pages = <Widget>[
    const DiscoverPage(),
    const SettingsPage(),
  ];

  Timer? _debouncer;

  @override
  void initState() {
    _notificationApi.configureSelectNotificationSubject(context);

    super.initState();
  }

  @override
  void dispose() {
    selectNotificationSubject.close();

    _debouncer?.cancel();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isInvisible = MediaQuery.of(context).viewInsets.bottom != 0;

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
        final currentIndex = bottomNavProvider.index;

        return WillPopScope(
          onWillPop: () => onWillPop(searchProvider),
          child: Scaffold(
            resizeToAvoidBottomInset: false,
            appBar: currentIndex == 0 ? null : _buildAppBar(),
            body: currentIndex == 0
                ? _buildScaffoldBody(
                    bottomNavProvider,
                    searchProvider,
                    restaurantProvider,
                    categoryProvider,
                  )
                : _buildBody(currentIndex),
            bottomNavigationBar: _buildBottomNav(bottomNavProvider),
            floatingActionButton: isInvisible ? null : _buildFab(context),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerDocked,
          ),
        );
      },
    );
  }

  /// Widget app bar khusus untuk page settings
  AppBar _buildAppBar() {
    return AppBar(
      title: const Text('Settings'),
      titleSpacing: 0,
      leading: const Icon(Icons.settings),
    );
  }

  /// Widget untuk membuat [NestedScrollView] yang diisi sliver app bar dan body
  NestedScrollView _buildScaffoldBody(
    BottomNavProvider bottomNavProvider,
    RestaurantSearchProvider searchProvider,
    RestaurantProvider restaurantProvider,
    CategoryProvider categoryProvider,
  ) {
    return NestedScrollView(
      floatHeaderSlivers: true,
      headerSliverBuilder: (context, isScrolled) {
        return <Widget>[
          SliverOverlapAbsorber(
            handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
            sliver: SliverSafeArea(
              top: false,
              sliver: SliverAppBar(
                floating: true,
                pinned: true,
                snap: true,
                title: _buildTitle(searchProvider, bottomNavProvider),
                leading: _buildLeading(searchProvider),
                actions: _buildActions(
                  restaurantProvider,
                  searchProvider,
                  categoryProvider,
                ),
                bottom: _buildBottom(restaurantProvider, searchProvider),
                titleSpacing: 0,
                leadingWidth: 68,
              ),
            ),
          )
        ];
      },
      body: _buildBody(bottomNavProvider.index),
    );
  }

  /// Widget untuk membuat title app bar
  Widget _buildTitle(
    RestaurantSearchProvider searchProvider,
    BottomNavProvider bottomNavProvider,
  ) {
    return searchProvider.isSearching
        ? SearchField(
            hintText: 'Search Restaurants or Menu',
            onChanged: (query) {
              debounce(() => searchProvider.searchRestaurants(query));
            },
          )
        : Text(bottomNavProvider.title);
  }

  /// Widget untuk membuat leading app bar
  Widget _buildLeading(RestaurantSearchProvider searchProvider) {
    return searchProvider.isSearching
        ? IconButton(
            onPressed: () {
              searchProvider.isSearching = false;
              searchProvider.query = '';
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

  /// Widget untuk membuat action app bar
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
                  categoryProvider.category = '';
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

  /// Widget untuk membuat list category pada bottom app bar
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

  /// Widget untuk membuat body
  Widget _buildBody(int index) => _pages[index];

  /// Widget untuk membuat bottom navigation bar
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
          bottomNavProvider.index = index;

          switch (index) {
            case 0:
              bottomNavProvider.title = 'Discover';
              break;
            case 1:
              bottomNavProvider.title = 'Settings';
              break;
          }
        });
  }

  /// Widget untuk membuat floating action button
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
  Future<bool> onWillPop(RestaurantSearchProvider searchProvider) {
    if (searchProvider.isSearching) {
      searchProvider.isSearching = false;
      searchProvider.query = '';

      return Future.value(false);
    }

    return Future.value(true);
  }
}
