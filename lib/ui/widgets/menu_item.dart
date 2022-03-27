import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:restaurant_app/data/models/drink.dart';
import 'package:restaurant_app/data/models/food.dart';
import 'package:restaurant_app/ui/themes/color_scheme.dart';

class MenuItem extends StatelessWidget {
  final Food? food;
  final Drink? drink;

  const MenuItem({Key? key, this.food, this.drink}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        alignment: AlignmentDirectional.bottomStart,
        children: <Widget>[
          CachedNetworkImage(
            imageUrl: food == null ? drink!.imgUrl : food!.imgUrl,
            width: 300,
            height: 300,
            fit: BoxFit.fill,
            fadeInDuration: const Duration(milliseconds: 200),
            fadeOutDuration: const Duration(milliseconds: 200),
            placeholder: (context, url) {
              return Center(
                child: SizedBox(
                  width: 100,
                  height: 100,
                  child: SpinKitPulse(color: primaryColor),
                ),
              );
            },
            errorWidget: (context, url, error) {
              return Center(
                child: SizedBox(
                  width: 100,
                  height: 100,
                  child: Icon(
                    Icons.motion_photos_off_outlined,
                    color: secondaryTextColor,
                  ),
                ),
              );
            },
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
