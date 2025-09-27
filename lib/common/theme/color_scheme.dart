// Flutter imports:
import 'package:flutter/material.dart';

final lightColorScheme = ColorScheme.fromSeed(
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

final darkColorScheme = ColorScheme.fromSeed(
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
  static const primaryColor = Color(0xFF2F184B);

  // ---------- Light Theme ----------
  // Primaries
  static const onPrimaryLight = Color(0xFFFFFFFF);
  static const primaryContainerLight = Color(0xFFE9E0F4);
  static const onPrimaryContainerLight = Color(0xFF25133A);

  // Secondary (analogous lavender)
  static const secondaryLight = Color(0xFF6A5A84);
  static const onSecondaryLight = Color(0xFFFFFFFF);
  static const secondaryContainerLight = Color(0xFFE3DDF0);
  static const onSecondaryContainerLight = Color(0xFF241D3A);

  // Tertiary (muted teal)
  static const tertiaryLight = Color(0xFF7D59B6);
  static const onTertiaryLight = Color(0xFFFFFFFF);
  static const tertiaryContainerLight = Color(0xFFEBDDFF);
  static const onTertiaryContainerLight = Color(0xFF311A53);

  // Neutrals / Surfaces
  static const surfaceLight = Color(0xFFFFFBFF);
  static const onSurfaceLight = Color(0xFF1E1B22);
  static const onSurfaceVariantLight = Color(0xFF49454F);
  static const outlineLight = Color(0xFF7A757F);
  static const outlineVariantLight = Color(0xFFCAC4D0);

  // Error
  static const errorLight = Color(0xFFBA1A1A);
  static const onErrorLight = Color(0xFFFFFFFF);
  static const errorContainerLight = Color(0xFFFFDAD6);
  static const onErrorContainerLight = Color(0xFF410002);

  // ---------- Dark Theme ----------
  // Primaries
  static const primaryDark = Color(0xFFCFBCFF);
  static const onPrimaryDark = Color(0xFF392158);
  static const primaryContainerDark = Color(0xFF4A2D6D);
  static const onPrimaryContainerDark = Color(0xFFEADDFF);

  // Secondary
  static const secondaryDark = Color(0xFFCBBEDB);
  static const onSecondaryDark = Color(0xFF322A49);
  static const secondaryContainerDark = Color(0xFF4A4166);
  static const onSecondaryContainerDark = Color(0xFFE6DEF8);

  // Tertiary
  static const tertiaryDark = Color(0xFFD0B9FF);
  static const onTertiaryDark = Color(0xFF332053);
  static const tertiaryContainerDark = Color(0xFF4F2F75);
  static const onTertiaryContainerDark = Color(0xFFEBDDFF);

  // Neutrals / Surfaces
  static const surfaceDark = Color(0xFF141218);
  static const onSurfaceDark = Color(0xFFE7E1EA);
  static const onSurfaceVariantDark = Color(0xFFCAC4D0);
  static const outlineDark = Color(0xFF948F99);
  static const outlineVariantDark = Color(0xFF4A4458);

  // Error
  static const errorDark = Color(0xFFFFB4AB);
  static const onErrorDark = Color(0xFF690005);
  static const errorContainerDark = Color(0xFF93000A);
  static const onErrorContainerDark = Color(0xFFFFDAD6);
}
