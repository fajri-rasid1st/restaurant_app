// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:provider/provider.dart';

// Project imports:
import 'package:restaurant_app/common/extensions/text_style_extension.dart';
import 'package:restaurant_app/common/utilities/asset_path.dart';
import 'package:restaurant_app/providers/database_providers/restaurant_database_provider.dart';
import 'package:restaurant_app/ui/widgets/custom_information.dart';
import 'package:restaurant_app/ui/widgets/scaffold_safe_area.dart';

class FavoritePage extends StatelessWidget {
  const FavoritePage({super.key});

  @override
  Widget build(BuildContext context) {
    return ScaffoldSafeArea(
      appBar: AppBar(
        title: Text('Favorites'),
        titleTextStyle: Theme.of(context).textTheme.titleLarge!.bold,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_rounded),
          tooltip: 'Kembali',
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Consumer<RestaurantDatabaseProvider>(
        builder: (context, provider, child) {
          return provider.restaurants.isEmpty
              ? CustomInformation(
                  assetName: AssetPath.getVector('No_data_cuate.svg'),
                  title: 'Belum Ada Favorit Nih!',
                  subtitle: 'Restoran yang Anda like akan muncul di sini.',
                )
              : SizedBox.shrink();
        },
      ),
    );
  }
}
