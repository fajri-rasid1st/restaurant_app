import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_app/common/result_state.dart';
import 'package:restaurant_app/common/utilities.dart';
import 'package:restaurant_app/data/models/favorite.dart';
import 'package:restaurant_app/provider/database_provider.dart';
import 'package:restaurant_app/provider/favorite_provider.dart';
import 'package:restaurant_app/ui/screens/loading_screen.dart';
import 'package:restaurant_app/ui/themes/color_scheme.dart';
import 'package:restaurant_app/ui/widgets/custom_information.dart';
import 'package:restaurant_app/ui/widgets/restaurant_card.dart';

class FavoriteScreen extends StatelessWidget {
  const FavoriteScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Favorite'),
        centerTitle: true,
      ),
      body: Consumer2<DatabaseProvider, FavoriteProvider>(
        builder: (context, databaseProvider, favoriteProvider, child) {
          if (databaseProvider.state == ResultState.loading) {
            return const LoadingScreen();
          }

          return _buildBody(databaseProvider, favoriteProvider);
        },
      ),
    );
  }

  /// Widget untuk membuat tampilan utama
  Widget _buildBody(
    DatabaseProvider databaseProvider,
    FavoriteProvider favoriteProvider,
  ) {
    return databaseProvider.favorites.isEmpty
        ? _buildFavoriteEmpty()
        : _buildFavoriteList(databaseProvider, favoriteProvider);
  }

  /// Widget untuk membuat list restaurant favorite
  SlidableAutoCloseBehavior _buildFavoriteList(
    DatabaseProvider databaseProvider,
    FavoriteProvider favoriteProvider,
  ) {
    return SlidableAutoCloseBehavior(
      child: ListView.separated(
        padding: const EdgeInsets.all(0),
        itemBuilder: (context, index) {
          final favorite = databaseProvider.favorites[index];

          return Slidable(
            groupTag: 1,
            startActionPane: ActionPane(
              motion: const ScrollMotion(),
              children: [
                SlidableAction(
                  onPressed: (context) {
                    Utilities.navigateToDetailScreen(
                      context: context,
                      favorite: favorite,
                    );
                  },
                  icon: Icons.open_in_new_rounded,
                  foregroundColor: backGroundColor,
                  backgroundColor: primaryColor,
                ),
                SlidableAction(
                  onPressed: (context) {
                    databaseProvider.deleteFavoriteById(favorite.id!).then((_) {
                      Utilities.showSnackBarMessage(
                        context: context,
                        text: 'Berhasil dihapus dari favorite.',
                        action: retrieveDeletedFavorite(
                          favorite,
                          databaseProvider,
                        ),
                      );
                    });
                  },
                  icon: Icons.delete_outline_rounded,
                  foregroundColor: primaryColor,
                  backgroundColor: secondaryColor,
                ),
              ],
            ),
            child: RestaurantCard(favorite: favorite),
          );
        },
        separatorBuilder: (context, index) {
          return const Divider(height: 1, thickness: 1);
        },
        itemCount: databaseProvider.favorites.length,
      ),
    );
  }

  /// Widget untuk membuat page kosong jika favorite tidak ditemukan
  CustomInformation _buildFavoriteEmpty() {
    return const CustomInformation(
      imgPath: 'assets/svg/No_data_cuate.svg',
      title: 'Belum Ada Favorite Nih!',
      subtitle: 'Restoran yang anda suka akan muncul di sini.',
    );
  }

  /// Mengembalikan kembali restaurant yang telah dihapus dari favorite
  SnackBarAction retrieveDeletedFavorite(
    Favorite favorite,
    DatabaseProvider databaseProvider,
  ) {
    return SnackBarAction(
      label: 'Dismiss',
      onPressed: () async {
        await databaseProvider.createFavorite(favorite);
      },
    );
  }
}
