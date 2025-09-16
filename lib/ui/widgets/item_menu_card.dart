// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:restaurant_app/common/utilities/asset_path.dart';
import 'package:restaurant_app/data/models/restaurant_detail.dart';
import 'package:restaurant_app/ui/themes/color_scheme.dart';

class ItemMenuCard extends StatelessWidget {
  final ItemMenu item;
  final bool isFood;

  const ItemMenuCard({
    super.key,
    required this.item,
    required this.isFood,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        alignment: AlignmentDirectional.bottomCenter,
        children: [
          Image.asset(
            isFood ? AssetPath.getImage("placeholder_2.png") : AssetPath.getImage("placeholder_1.png"),
            fit: BoxFit.cover,
          ),
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [
                    Colors.black,
                    Colors.transparent,
                  ],
                  stops: [
                    0.0,
                    0.75,
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(8),
            child: Text(
              item.name,
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                color: Palette.onPrimaryColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
