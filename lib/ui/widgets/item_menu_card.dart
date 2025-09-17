// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:restaurant_app/common/utilities/asset_path.dart';
import 'package:restaurant_app/data/models/restaurant_detail.dart';

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
      clipBehavior: Clip.antiAlias,
      margin: EdgeInsets.all(0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Stack(
        alignment: AlignmentDirectional.bottomCenter,
        children: [
          Image.asset(
            isFood ? AssetPath.getImage("placeholder_2.png") : AssetPath.getImage("placeholder_1.png"),
            fit: BoxFit.contain,
          ),
          Padding(
            padding: EdgeInsets.all(8),
            child: Text(
              item.name,
              style: Theme.of(context).textTheme.titleSmall, // TODO:
            ),
          ),
        ],
      ),
    );
  }
}
