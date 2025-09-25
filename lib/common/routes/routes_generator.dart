// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:provider/provider.dart';

// Project imports:
import 'package:restaurant_app/common/routes/route_names.dart';
import 'package:restaurant_app/providers/api_providers/restaurant_detail_provider.dart';
import 'package:restaurant_app/providers/database_providers/restaurant_database_provider.dart';
import 'package:restaurant_app/services/api/restaurant_api.dart';
import 'package:restaurant_app/services/db/restaurant_database.dart';
import 'package:restaurant_app/ui/pages/detail_page.dart';
import 'package:restaurant_app/ui/pages/favorite_page.dart';
import 'package:restaurant_app/ui/pages/review_form_page.dart';

/// Routes generator
Route<dynamic>? generateAppRoutes(RouteSettings settings) {
  switch (settings.name) {
    case Routes.detail:
      final args = settings.arguments as Map<String, dynamic>;

      return MaterialPageRoute(
        builder: (context) => ChangeNotifierProvider(
          create: (context) => RestaurantDetailProvider(
            apiService: context.read<RestaurantApi>(),
            databaseService: context.read<RestaurantDatabase>(),
          )..getRestaurantDetail(args['id']),
          child: DetailPage(
            restaurantId: args['id'],
            heroTag: args['id'],
          ),
        ),
      );

    case Routes.reviewForm:
      final args = settings.arguments as Map<String, dynamic>;

      return MaterialPageRoute(
        builder: (context) => ChangeNotifierProvider.value(
          value: context.read<RestaurantDetailProvider>(),
          child: ReviewFormPage(
            restaurantId: args['id'],
            restaurantName: args['name'],
          ),
        ),
      );

    case Routes.favorites:
      return MaterialPageRoute(
        builder: (context) => ChangeNotifierProvider.value(
          value: context.read<RestaurantDatabaseProvider>()..getAllFavorites(),
          child: FavoritePage(),
        ),
      );

    default:
      return null;
  }
}
