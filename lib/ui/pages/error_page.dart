// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:provider/provider.dart';

// Project imports:
import 'package:restaurant_app/common/utilities/asset_path.dart';
import 'package:restaurant_app/providers/app_providers/is_reload_provider.dart';
import 'package:restaurant_app/ui/widgets/custom_information.dart';

class ErrorPage extends StatelessWidget {
  final String message;
  final VoidCallback onRefresh;

  const ErrorPage({
    super.key,
    required this.message,
    required this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Center(
        child: CustomInformation(
          assetName: AssetPath.getVector('404_error_lost_in_space_cuate.svg'),
          title: 'Gagal Memuat Data',
          subtitle: message,
          child: Consumer<IsReloadProvider>(
            builder: (context, provider, child) {
              return FilledButton.icon(
                onPressed: provider.value ? null : onRefresh,
                icon: provider.value
                    ? SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      )
                    : Icon(Icons.replay_rounded),
                label: provider.value ? Text('Memuat Data...') : Text('Coba Lagi'),
                style: FilledButton.styleFrom(
                  padding: EdgeInsets.symmetric(
                    vertical: 8,
                    horizontal: 16,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
