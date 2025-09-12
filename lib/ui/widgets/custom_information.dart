import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

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
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            Text(
              subtitle,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            SizedBox(height: 16),
            if (child != null) child!,
          ],
        ),
      ),
    );
  }
}
