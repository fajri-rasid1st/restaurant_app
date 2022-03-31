import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Utilities {
  /// Fungsi untuk menampilkan snackbar
  static void showSnackBarMessage({
    required BuildContext context,
    required String text,
  }) {
    // create snackbar
    SnackBar snackBar = SnackBar(
      content: Text(
        text,
        style: GoogleFonts.quicksand(),
      ),
    );

    // show snackbar
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(snackBar);
  }
}
