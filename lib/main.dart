// Flutter imports:
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// Package imports:
import 'package:provider/provider.dart';

// Project imports:
import 'package:restaurant_app/app.dart';
import 'package:restaurant_app/data/services/restaurant_api_service.dart';
import 'package:restaurant_app/providers/app_providers/is_reload_provider.dart';
import 'package:restaurant_app/providers/app_providers/is_searching_provider.dart';
import 'package:restaurant_app/providers/app_providers/search_query_provider.dart';
import 'package:restaurant_app/providers/app_providers/selected_category_provider.dart';
import 'package:restaurant_app/providers/service_providers/restaurants_provider.dart';

Future<void> main() async {
  // Memastikan widget Flutter sudah diinisialisasi
  WidgetsFlutterBinding.ensureInitialized();

  // Untuk mencegah orientasi landscape
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  runApp(
    MultiProvider(
      providers: [
        Provider<RestaurantApiService>(
          create: (context) => RestaurantApiService(),
        ),
        ChangeNotifierProvider<IsReloadProvider>(
          create: (context) => IsReloadProvider(),
        ),
        ChangeNotifierProvider<IsSearchingProvider>(
          create: (context) => IsSearchingProvider(),
        ),
        ChangeNotifierProvider<SearchQueryProvider>(
          create: (context) => SearchQueryProvider(),
        ),
        ChangeNotifierProvider<SelectedCategoryProvider>(
          create: (context) => SelectedCategoryProvider(),
        ),
        ChangeNotifierProvider<RestaurantsProvider>(
          create: (context) => RestaurantsProvider(context.read<RestaurantApiService>())..getRestaurants(),
        ),
      ],
      builder: (context, child) => RestaurantApp(),
    ),
  );
}
