import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:restaurant_app/ui/themes/color_scheme.dart';

final TextTheme textTheme = GoogleFonts.quicksandTextTheme().apply(
  displayColor: Palette.primaryTextColor,
  bodyColor: Palette.primaryTextColor,
);

extension TextStyleExtension on TextStyle {
  // Weight
  TextStyle get light => copyWith(fontWeight: FontWeight.w300);
  TextStyle get regular => copyWith(fontWeight: FontWeight.w400);
  TextStyle get medium => copyWith(fontWeight: FontWeight.w500);
  TextStyle get semiBold => copyWith(fontWeight: FontWeight.w600);
  TextStyle get bold => copyWith(fontWeight: FontWeight.w700);

  // Color
  TextStyle get primaryColor => copyWith(color: Palette.primaryColor);
  TextStyle get onPrimaryColor => copyWith(color: Palette.onPrimaryColor);
  TextStyle get secondaryColor => copyWith(color: Palette.secondaryColor);
  TextStyle get backgroundColor => copyWith(color: Palette.backgroundColor);
  TextStyle get primaryTextColor => copyWith(color: Palette.primaryTextColor);
  TextStyle get secondaryTextColor => copyWith(color: Palette.secondaryTextColor);
  TextStyle get dividerColor => copyWith(color: Palette.dividerColor);

  // Style
  TextStyle get italic => copyWith(fontStyle: FontStyle.italic);
}
