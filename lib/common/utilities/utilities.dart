// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:google_fonts/google_fonts.dart';

class Utilities {
  /// Menampilkan snackbar dengan [text] dan [action] (opsional)
  static void showSnackBarMessage({
    required BuildContext context,
    required String text,
    SnackBarAction? action,
  }) {
    // Create snackbar
    final snackBar = SnackBar(
      content: Text(
        text,
        style: GoogleFonts.quicksand(),
      ),
      action: action,
      duration: const Duration(seconds: 3),
    );

    // Show snackbar
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(snackBar);
  }
}
