// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:restaurant_app/common/extensions/text_style_extension.dart';

class Utilities {
  /// Menampilkan snackbar dengan [message] dan opsional [action]
  static void showSnackBarMessage({
    required BuildContext context,
    required String message,
    SnackBarAction? action,
  }) {
    // Create snackbar
    final snackBar = SnackBar(
      content: Text(
        message,
        style: Theme.of(context).textTheme.bodySmall!.semiBold.colorSurface(context),
      ),
      action: action,
      actionOverflowThreshold: 0.3,
      duration: Duration(seconds: 3),
    );

    // Show snackbar
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(snackBar);
  }
}
