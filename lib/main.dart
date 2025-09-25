// Flutter imports:
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// Package imports:
import 'package:provider/provider.dart';

// Project imports:
import 'package:restaurant_app/app.dart';
import 'package:restaurant_app/providers/api_providers/restaurants_provider.dart';
import 'package:restaurant_app/providers/app_providers/is_reload_provider.dart';
import 'package:restaurant_app/providers/app_providers/is_searching_provider.dart';
import 'package:restaurant_app/providers/app_providers/nav_bar_index_provider.dart';
import 'package:restaurant_app/providers/app_providers/search_query_provider.dart';
import 'package:restaurant_app/providers/app_providers/selected_category_provider.dart';
import 'package:restaurant_app/providers/database_providers/restaurant_database_provider.dart';
import 'package:restaurant_app/providers/prefs_providers/is_daily_reminder_actived_provider.dart';
import 'package:restaurant_app/providers/prefs_providers/is_dark_mode_actived_provider.dart';
import 'package:restaurant_app/services/api/restaurant_api.dart';
import 'package:restaurant_app/services/db/restaurant_database.dart';
import 'package:restaurant_app/services/prefs/restaurant_settings_prefs.dart';

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
        //* Service providers
        Provider(
          create: (_) => RestaurantSettingsPrefs(),
        ),
        Provider(
          create: (_) => RestaurantDatabase(),
        ),
        Provider(
          create: (_) => RestaurantApi(),
        ),

        //* App state providers
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

        //* Preferences providers
        ChangeNotifierProvider(
          create: (context) => IsDarkModeActivedProvider(
            context.read<RestaurantSettingsPrefs>(),
          )..loadValue(),
          lazy: false,
        ),
        ChangeNotifierProvider(
          create: (context) => IsDailyReminderActivedProvider(
            context.read<RestaurantSettingsPrefs>(),
          )..loadValue(),
          lazy: false,
        ),

        //* Database providers
        ChangeNotifierProvider(
          create: (context) => RestaurantDatabaseProvider(
            context.read<RestaurantDatabase>(),
          ),
        ),

        //* API list restaurant provider (di-fetch di awal)
        ChangeNotifierProvider(
          create: (context) => RestaurantsProvider(
            apiService: context.read<RestaurantApi>(),
            databaseService: context.read<RestaurantDatabase>(),
          )..getRestaurants(),
        ),
      ],
      child: RestaurantApp(),
    ),
  );
}
