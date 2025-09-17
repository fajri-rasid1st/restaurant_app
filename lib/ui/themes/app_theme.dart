// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:restaurant_app/ui/themes/color_scheme.dart';
import 'package:restaurant_app/ui/themes/text_theme.dart';

final ThemeData lightTheme = ThemeData(
  useMaterial3: true,
  brightness: Brightness.light,
  colorScheme: lightColorScheme,
  textTheme: buildTextTheme(lightColorScheme),
  appBarTheme: AppBarTheme(
    backgroundColor: Palette.primaryContainerLight,
    surfaceTintColor: Palette.primaryContainerLight,
  ),
);

final ThemeData darkTheme = ThemeData(
  useMaterial3: true,
  brightness: Brightness.dark,
  colorScheme: darkColorScheme,
  textTheme: buildTextTheme(darkColorScheme),
  appBarTheme: AppBarTheme(
    backgroundColor: Palette.primaryContainerDark,
    surfaceTintColor: Palette.primaryContainerDark,
  ),
);
