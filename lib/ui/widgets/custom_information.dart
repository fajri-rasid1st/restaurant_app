// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_svg/flutter_svg.dart';
import 'package:restaurant_app/common/extensions/text_style_extension.dart';

class CustomInformation extends StatelessWidget {
  final String assetName;
  final String title;
  final String subtitle;
  final Widget? child;

  const CustomInformation({
    super.key,
    required this.assetName,
    required this.title,
    required this.subtitle,
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SvgPicture.asset(
              assetName,
              width: 250,
              fit: BoxFit.cover,
            ),
            Text(
              title,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleMedium!.bold.colorPrimary(context),
            ),
            SizedBox(height: 8),
            Text(
              subtitle,
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.bodyMedium!.colorOutline(context),
            ),
            SizedBox(height: 16),
            if (child != null) child!,
          ],
        ),
      ),
    );
  }
}
