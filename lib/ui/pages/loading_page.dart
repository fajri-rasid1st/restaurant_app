// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:restaurant_app/ui/widgets/scaffold_safe_area.dart';

class LoadingPage extends StatelessWidget {
  const LoadingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ScaffoldSafeArea(
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SpinKitRing(
                lineWidth: 4,
                color: Theme.of(context).colorScheme.primary,
              ),
              SizedBox(height: 24),
              Text(
                'Tunggu Sebentar...',
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
