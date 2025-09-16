// Flutter imports:
import 'package:flutter/material.dart';

final ColorScheme lightColorScheme = ColorScheme.fromSeed(
  brightness: Brightness.light,
  seedColor: Palette.primaryColor,
  primary: Palette.primaryColor,
  onPrimary: Palette.onPrimaryLight,
  primaryContainer: Palette.primaryContainerLight,
  onPrimaryContainer: Palette.onPrimaryContainerLight,
  secondary: Palette.secondaryLight,
  onSecondary: Palette.onSecondaryLight,
  secondaryContainer: Palette.secondaryContainerLight,
  onSecondaryContainer: Palette.onSecondaryContainerLight,
  tertiary: Palette.tertiaryLight,
  onTertiary: Palette.onTertiaryLight,
  tertiaryContainer: Palette.tertiaryContainerLight,
  onTertiaryContainer: Palette.onTertiaryContainerLight,
  error: Palette.errorLight,
  onError: Palette.onErrorLight,
  errorContainer: Palette.errorContainerLight,
  onErrorContainer: Palette.onErrorContainerLight,
  surface: Palette.surfaceLight,
  onSurface: Palette.onSurfaceLight,
  onSurfaceVariant: Palette.onSurfaceVariantLight,
  outline: Palette.outlineLight,
  outlineVariant: Palette.outlineVariantLight,
);

final ColorScheme darkColorScheme = ColorScheme.fromSeed(
  brightness: Brightness.dark,
  seedColor: Palette.primaryColor,
  primary: Palette.primaryDark,
  onPrimary: Palette.onPrimaryDark,
  primaryContainer: Palette.primaryContainerDark,
  onPrimaryContainer: Palette.onPrimaryContainerDark,
  secondary: Palette.secondaryDark,
  onSecondary: Palette.onSecondaryDark,
  secondaryContainer: Palette.secondaryContainerDark,
  onSecondaryContainer: Palette.onSecondaryContainerDark,
  tertiary: Palette.tertiaryDark,
  onTertiary: Palette.onTertiaryDark,
  tertiaryContainer: Palette.tertiaryContainerDark,
  onTertiaryContainer: Palette.onTertiaryContainerDark,
  error: Palette.errorDark,
  onError: Palette.onErrorDark,
  errorContainer: Palette.errorContainerDark,
  onErrorContainer: Palette.onErrorContainerDark,
  surface: Palette.surfaceDark,
  onSurface: Palette.onSurfaceDark,
  onSurfaceVariant: Palette.onSurfaceVariantDark,
  outline: Palette.outlineDark,
  outlineVariant: Palette.outlineVariantDark,
);

class Palette {
  // Core
  static const Color primaryColor = Color(0xFF2F184B);

  // ---------- LIGHT THEME ----------
  // Primaries
  static const Color onPrimaryLight = Color(0xFFFFFFFF);
  static const Color primaryContainerLight = Color(0xFFE9E0F4);
  static const Color onPrimaryContainerLight = Color(0xFF25133A);

  // Secondary (analogous lavender)
  static const Color secondaryLight = Color(0xFF6A5A84);
  static const Color onSecondaryLight = Color(0xFFFFFFFF);
  static const Color secondaryContainerLight = Color(0xFFE3DDF0);
  static const Color onSecondaryContainerLight = Color(0xFF241D3A);

  // Tertiary (muted teal)
  static const Color tertiaryLight = Color(0xFF7D59B6);
  static const Color onTertiaryLight = Color(0xFFFFFFFF);
  static const Color tertiaryContainerLight = Color(0xFFEBDDFF);
  static const Color onTertiaryContainerLight = Color(0xFF311A53);

  // Neutrals / Surfaces
  static const Color surfaceLight = Color(0xFFFFFBFF);
  static const Color onSurfaceLight = Color(0xFF1E1B22);
  static const Color onSurfaceVariantLight = Color(0xFF49454F);
  static const Color outlineLight = Color(0xFF7A757F);
  static const Color outlineVariantLight = Color(0xFFCAC4D0);

  // Error
  static const Color errorLight = Color(0xFFBA1A1A);
  static const Color onErrorLight = Color(0xFFFFFFFF);
  static const Color errorContainerLight = Color(0xFFFFDAD6);
  static const Color onErrorContainerLight = Color(0xFF410002);

  // ---------- DARK THEME ----------
  // Primaries
  static const Color primaryDark = Color(0xFFCFBCFF);
  static const Color onPrimaryDark = Color(0xFF392158);
  static const Color primaryContainerDark = Color(0xFF4A2D6D);
  static const Color onPrimaryContainerDark = Color(0xFFEADDFF);

  // Secondary
  static const Color secondaryDark = Color(0xFFCBBEDB);
  static const Color onSecondaryDark = Color(0xFF322A49);
  static const Color secondaryContainerDark = Color(0xFF4A4166);
  static const Color onSecondaryContainerDark = Color(0xFFE6DEF8);

  // Tertiary
  static const Color tertiaryDark = Color(0xFFD0B9FF);
  static const Color onTertiaryDark = Color(0xFF332053);
  static const Color tertiaryContainerDark = Color(0xFF4F2F75);
  static const Color onTertiaryContainerDark = Color(0xFFEBDDFF);

  // Neutrals / Surfaces
  static const Color surfaceDark = Color(0xFF141218);
  static const Color onSurfaceDark = Color(0xFFE7E1EA);
  static const Color onSurfaceVariantDark = Color(0xFFCAC4D0);
  static const Color outlineDark = Color(0xFF948F99);
  static const Color outlineVariantDark = Color(0xFF4A4458);

  // Error
  static const Color errorDark = Color(0xFFFFB4AB);
  static const Color onErrorDark = Color(0xFF690005);
  static const Color errorContainerDark = Color(0xFF93000A);
  static const Color onErrorContainerDark = Color(0xFFFFDAD6);
}
