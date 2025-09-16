// Flutter imports:
import 'package:flutter/material.dart';

final ColorScheme colorScheme = ColorScheme.fromSeed(
  seedColor: Palette.primaryColor,
  primary: Palette.primaryColor,
  onPrimary: Palette.onPrimaryColor,
  secondary: Palette.secondaryColor,
  onSecondary: Palette.primaryTextColor,
  surface: Palette.backgroundColor,
  onSurface: Palette.primaryTextColor,
  outline: Palette.primaryColor,
  shadow: Palette.primaryColor,
);

class Palette {
  static const Color primaryColor = Color(0XFF3F3A57);
  static const Color onPrimaryColor = Color(0XFFFFFFFF);
  static const Color secondaryColor = Color(0XFFE7EDFC);
  static const Color backgroundColor = Color(0XFFFFFFFF);
  static const Color primaryTextColor = Color(0XFF3F3A57);
  static const Color secondaryTextColor = Color(0XFF727178);
  static const Color dividerColor = Color(0XFFC7D2DB);
}
