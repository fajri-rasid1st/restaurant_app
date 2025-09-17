// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:restaurant_app/ui/pages/main_page.dart';
import 'package:restaurant_app/ui/themes/app_theme.dart';

class RestaurantApp extends StatelessWidget {
  const RestaurantApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Restaurant App',
      debugShowCheckedModeBanner: false,
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: ThemeMode.system,
      home: SafeArea(
        top: false,
        left: false,
        right: false,
        child: MainPage(),
      ),
    );
  }
}
