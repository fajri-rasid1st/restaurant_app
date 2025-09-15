import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_app/data/services/restaurant_api_service.dart';
import 'package:restaurant_app/providers/service_providers/restaurant_provider.dart';
import 'package:restaurant_app/ui/themes/color_scheme.dart';
import 'package:restaurant_app/ui/themes/text_theme.dart';

class RestaurantApp extends StatelessWidget {
  const RestaurantApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<RestaurantApiService>(
          create: (context) => RestaurantApiService(),
        ),
        ChangeNotifierProvider<RestaurantProvider>(
          create: (context) => RestaurantProvider(context.read<RestaurantApiService>()),
        ),
        // ChangeNotifierProvider<RestaurantDetailProvider>(
        //   create: (context) => RestaurantDetailProvider(context.read<RestaurantApiService>()),
        // ),
        // ChangeNotifierProvider<CustomerReviewProvider>(
        //   create: (context) => CustomerReviewProvider(context.read<RestaurantApiService>()),
        // ),
      ],
      child: MaterialApp(
        title: 'Resto App',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          fontFamily: 'Quicksand',
          colorScheme: colorScheme,
          textTheme: textTheme,
          scaffoldBackgroundColor: Palette.backgroundColor,
          dividerColor: Palette.dividerColor,
        ),
        home: Placeholder(),
      ),
    );
  }
}
