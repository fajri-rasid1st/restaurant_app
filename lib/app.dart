// Flutter imports:
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_app/data/services/restaurant_api_service.dart';
import 'package:restaurant_app/providers/service_providers/restaurants_provider.dart';

// Project imports:
import 'package:restaurant_app/ui/pages/main_page.dart';
import 'package:restaurant_app/ui/themes/app_theme.dart';

class RestaurantApp extends StatelessWidget {
  const RestaurantApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Restaurant App',
      debugShowCheckedModeBanner: false,
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: ThemeMode.system,
      home: ChangeNotifierProvider<RestaurantsProvider>(
        create: (context) => RestaurantsProvider(
          context.read<RestaurantApiService>(),
        )..getRestaurants(),
        child: MainPage(),
      ),
    );
  }
}
