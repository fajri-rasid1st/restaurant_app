// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:restaurant_app/common/extensions/text_style_extension.dart';
import 'package:restaurant_app/common/utilities/asset_path.dart';
import 'package:restaurant_app/models/restaurant_detail.dart';

class ItemMenuCard extends StatelessWidget {
  final ItemMenu item;
  final bool isFood;
  final double aspectRatio;

  const ItemMenuCard({
    super.key,
    required this.item,
    required this.isFood,
    required this.aspectRatio,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Stack(
        alignment: AlignmentDirectional.bottomCenter,
        children: [
          AspectRatio(
            aspectRatio: aspectRatio,
            child: Image.asset(
              isFood ? AssetPath.getImage('placeholder_2.png') : AssetPath.getImage('placeholder_1.png'),
              fit: BoxFit.cover,
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              padding: EdgeInsetsGeometry.symmetric(
                vertical: 8,
                horizontal: 10,
              ),
              color: Theme.of(context).colorScheme.primaryContainer.withValues(alpha: .7),
              child: Text(
                item.name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.titleSmall!.semiBold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
