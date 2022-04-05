import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_app/data/models/favorite.dart';
import 'package:restaurant_app/data/models/restaurant.dart';
import 'package:restaurant_app/data/models/restaurant_detail.dart';
import 'package:restaurant_app/provider/database_provider.dart';
import 'package:restaurant_app/provider/favorite_provider.dart';
import 'package:restaurant_app/provider/restaurant_detail_provider.dart';
import 'package:restaurant_app/ui/screens/detail_screen.dart';
import 'package:restaurant_app/ui/themes/color_scheme.dart';

class Utilities {
  /// Menampilkan snackbar dengan [text] dan [action] (opsional)
  static void showSnackBarMessage({
    required BuildContext context,
    required String text,
    SnackBarAction? action,
  }) {
    // Create snackbar
    SnackBar snackBar = SnackBar(
      content: Text(
        text,
        style: GoogleFonts.quicksand(),
      ),
      action: action,
      duration: const Duration(seconds: 3),
    );

    // Show snackbar
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(snackBar);
  }

  /// Pindah ke halaman detail dengan terlebih dahulu menentukan icon favorite
  /// apa yang akan muncul dan mengambil data detail restaurant.
  static void navigateToDetailScreen({
    required BuildContext context,
    Restaurant? restaurant,
    Favorite? favorite,
  }) {
    final id = restaurant?.id ?? favorite!.restaurantId;
    final heroTag =
        restaurant != null ? '${restaurant.id}_res' : '${favorite!.id}_fav';

    context.read<FavoriteProvider>().setFavoriteIconButton(id);
    context.read<RestaurantDetailProvider>().getRestaurantDetail(id);

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: ((context) {
          return DetailScreen(restaurantId: id, heroTag: heroTag);
        }),
      ),
    );
  }

  /// Menambah restaurant ke favorite database
  static Future<void> addToFavorite({
    required BuildContext context,
    required DatabaseProvider databaseProvider,
    required FavoriteProvider favoriteProvider,
    Restaurant? restaurant,
    RestaurantDetail? restaurantDetail,
  }) async {
    final id = restaurant?.id ?? restaurantDetail!.id;
    final name = restaurant?.name ?? restaurantDetail!.name;
    final pictureId = restaurant?.pictureId ?? restaurantDetail!.pictureId;
    final city = restaurant?.city ?? restaurantDetail!.city;
    final rating = restaurant?.rating ?? restaurantDetail!.rating;

    final favorite = Favorite(
      restaurantId: id,
      name: name,
      pictureId: pictureId,
      city: city,
      rating: rating,
      createdAt: DateTime.now(),
    );

    await databaseProvider.createFavorite(favorite);

    favoriteProvider.icon = Icon(
      Icons.favorite_rounded,
      color: Colors.red[400],
    );

    favoriteProvider.isFavorite = true;

    showSnackBarMessage(
      context: context,
      text: 'Berhasil ditambahkan ke favorite.',
    );
  }

  /// Menghapus restaurant favorite dari database
  static Future<void> removeFromFavorite({
    required BuildContext context,
    required DatabaseProvider databaseProvider,
    required FavoriteProvider favoriteProvider,
    Restaurant? restaurant,
    RestaurantDetail? restaurantDetail,
  }) async {
    final restaurantId = restaurant?.id ?? restaurantDetail!.id;

    await databaseProvider.deleteFavoriteByRestaurantId(restaurantId);

    favoriteProvider.icon = Icon(
      Icons.favorite_outline_rounded,
      color: backGroundColor,
    );

    favoriteProvider.isFavorite = false;

    showSnackBarMessage(
      context: context,
      text: 'Berhasil dihapus dari favorite.',
    );
  }
}
