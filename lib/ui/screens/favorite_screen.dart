import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_app/common/result_state.dart';
import 'package:restaurant_app/data/models/favorite.dart';
import 'package:restaurant_app/provider/database_provider.dart';
import 'package:restaurant_app/ui/screens/loading_screen.dart';
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
      body: Consumer<DatabaseProvider>(
        builder: (context, provider, child) {
          if (provider.state == ResultState.loading) {
            return const LoadingScreen();
          }

          return _buildBody(provider);
        },
      ),
    );
  }

  /// Widget untuk membuat tampilan utama
  Widget _buildBody(DatabaseProvider databaseProvider) {
    return databaseProvider.favorites.isEmpty
        ? _buildFavoriteEmpty()
        : _buildFavoriteList(databaseProvider.favorites);
  }

  // Widget untuk membuat list restaurant jika data berhasil didapatkan
  ListView _buildFavoriteList(List<Favorite> favorites) {
    return ListView.separated(
      padding: const EdgeInsets.all(0),
      itemBuilder: (context, index) {
        return RestaurantCard(favorite: favorites[index]);
      },
      separatorBuilder: (context, index) {
        return const Divider(height: 1, thickness: 1);
      },
      itemCount: favorites.length,
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
}
