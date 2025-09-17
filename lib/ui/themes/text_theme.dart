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

extension TextStyleExtension on TextStyle {
  // Weight
  TextStyle get light => copyWith(fontWeight: FontWeight.w300);
  TextStyle get regular => copyWith(fontWeight: FontWeight.w400);
  TextStyle get medium => copyWith(fontWeight: FontWeight.w500);
  TextStyle get semiBold => copyWith(fontWeight: FontWeight.w600);
  TextStyle get bold => copyWith(fontWeight: FontWeight.w700);
}
