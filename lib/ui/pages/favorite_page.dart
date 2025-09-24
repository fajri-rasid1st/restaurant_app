// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:restaurant_app/common/extensions/text_style_extension.dart';
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
    );
  }
}
