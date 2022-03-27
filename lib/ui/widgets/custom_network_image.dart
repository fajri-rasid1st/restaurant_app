import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import 'package:restaurant_app/ui/themes/color_scheme.dart';

class CustomNetworkImage extends StatelessWidget {
  final String imgUrl;
  final double width;
  final double height;
  final double placeHolderSize;

  const CustomNetworkImage({
    Key? key,
    required this.imgUrl,
    required this.width,
    required this.height,
    required this.placeHolderSize,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: imgUrl,
      fit: BoxFit.fill,
      width: width,
      height: height,
      fadeInDuration: const Duration(milliseconds: 200),
      fadeOutDuration: const Duration(milliseconds: 200),
      placeholder: (context, url) {
        return Center(
          child: SizedBox(
            width: placeHolderSize,
            height: placeHolderSize,
            child: SpinKitPulse(color: primaryColor),
          ),
        );
      },
      errorWidget: (context, url, error) {
        return Center(
          child: SizedBox(
            width: placeHolderSize,
            height: placeHolderSize,
            child: Icon(
              Icons.motion_photos_off_outlined,
              color: secondaryTextColor,
            ),
          ),
        );
      },
    );
  }
}
