import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:restaurant_app/data/api/restaurant_api.dart';
import 'package:restaurant_app/data/models/restaurant.dart';
import 'package:restaurant_app/ui/pages/error_page.dart';
import 'package:restaurant_app/ui/pages/home_page.dart';
import 'package:restaurant_app/ui/pages/loading_page.dart';
import 'package:restaurant_app/ui/themes/color_scheme.dart';
import 'package:restaurant_app/ui/themes/text_theme.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  // untuk mencegah orientasi landskap
  SystemChrome.setPreferredOrientations(<DeviceOrientation>[
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // ubah warna status bar
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    systemNavigationBarColor: backGroundColor,
  ));

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Restaurant App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: primaryColor,
          brightness: Brightness.light,
          primary: primaryColor,
          onPrimary: onPrimaryColor,
          secondary: secondaryColor,
          onSecondary: primaryTextColor,
          background: backGroundColor,
          onBackground: primaryTextColor,
          outline: primaryColor,
          shadow: primaryColor,
        ),
        textTheme: myTextTheme,
        scaffoldBackgroundColor: backGroundColor,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: FutureBuilder<List<Restaurant>>(
        future: RestaurantApi.getRestaurants(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasData) {
              return HomePage(restaurants: snapshot.data!);
            }

            return const ErrorPage();
          }

          return const LoadingPage();
        },
      ),
    );
  }
}
