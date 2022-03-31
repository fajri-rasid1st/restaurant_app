import 'package:flutter/material.dart';
import 'package:restaurant_app/common/const.dart';
import 'package:restaurant_app/data/models/menu_item.dart';
import 'package:restaurant_app/ui/themes/color_scheme.dart';
import 'package:restaurant_app/ui/widgets/custom_network_image.dart';

class MenuItemView extends StatelessWidget {
  final MenuItem? food;
  final MenuItem? drink;

  const MenuItemView({Key? key, this.food, this.drink}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        alignment: AlignmentDirectional.bottomStart,
        children: <Widget>[
          CustomNetworkImage(
            imgUrl: food == null
                ? Const.imgDrinkPlaceholder
                : Const.imgFoodPlaceholder,
            width: 300,
            height: 300,
            placeHolderSize: 100,
          ),
          Positioned.fill(
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [
                    Colors.black,
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8),
            child: Text(
              food == null ? drink!.name : food!.name,
              style: Theme.of(context)
                  .textTheme
                  .subtitle2
                  ?.copyWith(color: onPrimaryColor),
            ),
          ),
        ],
      ),
    );
  }
}
