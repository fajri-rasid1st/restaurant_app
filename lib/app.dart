// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:provider/provider.dart';

// Project imports:
import 'package:restaurant_app/data/api/restaurant_api.dart';
import 'package:restaurant_app/data/db/restaurant_database.dart';
import 'package:restaurant_app/providers/api_providers/restaurants_provider.dart';
import 'package:restaurant_app/providers/prefs_providers/is_dark_mode_actived_provider.dart';
import 'package:restaurant_app/ui/screens/main_screen.dart';
import 'package:restaurant_app/ui/themes/app_theme.dart';

class RestaurantApp extends StatelessWidget {
  const RestaurantApp({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = context.select<IsDarkModeActivedProvider, bool>((provider) => provider.value);

    return MaterialApp(
      title: 'Restaurant App',
      debugShowCheckedModeBanner: false,
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: isDark ? ThemeMode.dark : ThemeMode.light,
      home: ChangeNotifierProvider(
        create: (context) => RestaurantsProvider(
          apiService: context.read<RestaurantApi>(),
          databaseService: context.read<RestaurantDatabase>(),
        )..getRestaurants(),
        child: MainScreen(),
      ),
    );
  }
}
