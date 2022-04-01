import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Utilities {
  /// Fungsi untuk menampilkan snackbar
  static void showSnackBarMessage({
    required BuildContext context,
    required String text,
  }) {
    // Create snackbar
    SnackBar snackBar = SnackBar(
      content: Text(
        text,
        style: GoogleFonts.quicksand(),
      ),
    );

    // Show snackbar
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(snackBar);
  }
}
