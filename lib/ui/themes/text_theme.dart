// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:google_fonts/google_fonts.dart';

TextTheme buildTextTheme(ColorScheme scheme) {
  final base = scheme.brightness == Brightness.dark
      ? ThemeData(brightness: Brightness.dark).textTheme
      : ThemeData(brightness: Brightness.light).textTheme;

  return GoogleFonts.quicksandTextTheme(base).apply(
    bodyColor: scheme.onSurface,
    displayColor: scheme.onSurface,
  );
}
