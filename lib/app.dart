import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_app/data/services/restaurant_api_service.dart';
import 'package:restaurant_app/providers/service_providers/customer_review_provider.dart';
import 'package:restaurant_app/providers/service_providers/restaurant_detail_provider.dart';
import 'package:restaurant_app/providers/service_providers/restaurant_provider.dart';
import 'package:restaurant_app/ui/themes/color_scheme.dart';
import 'package:restaurant_app/ui/themes/text_theme.dart';

class RestaurantApp extends StatelessWidget {
  const RestaurantApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<RestaurantProvider>(
          create: (_) => RestaurantProvider(RestaurantApiService()),
        ),
        ChangeNotifierProvider<RestaurantDetailProvider>(
          create: (_) => RestaurantDetailProvider(RestaurantApiService()),
        ),
        ChangeNotifierProvider<CustomerReviewProvider>(
          create: (_) => CustomerReviewProvider(RestaurantApiService()),
        ),
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
        home: FlutterLogo(),
      ),
    );
  }
}
