// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:google_fonts/google_fonts.dart';

// Project imports:
import 'package:restaurant_app/ui/themes/color_scheme.dart';

final TextTheme textTheme = GoogleFonts.quicksandTextTheme().apply(
  displayColor: Palette.primaryTextColor,
  bodyColor: Palette.primaryTextColor,
);

extension TextStyleExtension on TextStyle {
  // Size
  TextStyle get s10 => copyWith(fontSize: 10);
  TextStyle get s12 => copyWith(fontSize: 12);
  TextStyle get s14 => copyWith(fontSize: 14);
  TextStyle get s16 => copyWith(fontSize: 16);
  TextStyle get s18 => copyWith(fontSize: 18);
  TextStyle get s20 => copyWith(fontSize: 20);
  TextStyle get s22 => copyWith(fontSize: 22);
  TextStyle get s24 => copyWith(fontSize: 24);
  TextStyle get s26 => copyWith(fontSize: 26);
  TextStyle get s28 => copyWith(fontSize: 28);
  TextStyle get s30 => copyWith(fontSize: 30);
  TextStyle get s32 => copyWith(fontSize: 32);
  TextStyle get s36 => copyWith(fontSize: 36);
  TextStyle get s40 => copyWith(fontSize: 40);
  TextStyle get s48 => copyWith(fontSize: 48);
  TextStyle get s56 => copyWith(fontSize: 56);
  TextStyle get s64 => copyWith(fontSize: 64);

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
