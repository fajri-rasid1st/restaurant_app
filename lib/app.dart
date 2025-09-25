// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:provider/provider.dart';

// Project imports:
import 'package:restaurant_app/common/theme/app_theme.dart';
import 'package:restaurant_app/providers/prefs_providers/is_dark_mode_actived_provider.dart';
import 'package:restaurant_app/ui/screens/main_screen.dart';

class RestaurantApp extends StatelessWidget {
  const RestaurantApp({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = context.select<IsDarkModeActivedProvider, bool>((provider) => provider.value);

    return MaterialApp(
      title: 'Restaurant App',
      debugShowCheckedModeBanner: false,
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: isDark ? ThemeMode.dark : ThemeMode.light,
      home: MainScreen(),
    );
  }
}
