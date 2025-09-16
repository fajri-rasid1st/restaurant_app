// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_svg/flutter_svg.dart';

// Project imports:
import 'package:restaurant_app/ui/themes/text_theme.dart';

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
              width: 240,
              fit: BoxFit.fill,
            ),
            Text(
              title,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleLarge!.bold.copyWith(
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            SizedBox(height: 8),
            Text(
              subtitle,
              textAlign: TextAlign.center,
              maxLines: 4,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                color: Theme.of(context).colorScheme.outline,
              ),
            ),
            SizedBox(height: 16),
            if (child != null) child!,
          ],
        ),
      ),
    );
  }
}
