// Flutter imports:
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// Package imports:
import 'package:provider/provider.dart';

// Project imports:
import 'package:restaurant_app/app.dart';
import 'package:restaurant_app/data/api/restaurant_api.dart';
import 'package:restaurant_app/data/db/restaurant_database.dart';
import 'package:restaurant_app/data/prefs/restaurant_settings_prefs.dart';
import 'package:restaurant_app/providers/app_providers/is_reload_provider.dart';
import 'package:restaurant_app/providers/app_providers/is_searching_provider.dart';
import 'package:restaurant_app/providers/app_providers/nav_bar_index_provider.dart';
import 'package:restaurant_app/providers/app_providers/search_query_provider.dart';
import 'package:restaurant_app/providers/app_providers/selected_category_provider.dart';

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
        Provider(
          create: (_) => RestaurantSettingsPrefs(),
        ),
        Provider(
          create: (_) => RestaurantDatabase(),
        ),
        Provider(
          create: (_) => RestaurantApi(),
        ),
        ChangeNotifierProvider(
          create: (_) => NavBarIndexProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => IsReloadProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => IsSearchingProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => SearchQueryProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => SelectedCategoryProvider(),
        ),
      ],
      child: RestaurantApp(),
    ),
  );
}
