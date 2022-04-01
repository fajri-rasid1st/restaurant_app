import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:restaurant_app/common/result_state.dart';
import 'package:restaurant_app/provider/category_provider.dart';
import 'package:restaurant_app/provider/customer_review_provider.dart';
import 'package:restaurant_app/provider/page_reload_provider.dart';
import 'package:restaurant_app/provider/restaurant_detail_provider.dart';
import 'package:restaurant_app/provider/restaurant_provider.dart';
import 'package:restaurant_app/provider/restaurant_search_provider.dart';
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

  runApp(
    MultiProvider(
      providers: <SingleChildWidget>[
        ChangeNotifierProvider<RestaurantProvider>(
          create: (_) => RestaurantProvider(),
        ),
        ChangeNotifierProvider<RestaurantDetailProvider>(
          create: (_) => RestaurantDetailProvider(),
        ),
        ChangeNotifierProvider<RestaurantSearchProvider>(
          create: (_) => RestaurantSearchProvider(),
        ),
        ChangeNotifierProvider<CustomerReviewProvider>(
          create: (_) => CustomerReviewProvider(),
        ),
        ChangeNotifierProvider<PageReloadProvider>(
          create: (_) => PageReloadProvider(),
        ),
        ChangeNotifierProvider<CategoryProvider>(
          create: (_) => CategoryProvider(),
        ),
      ],
      child: const MyApp(),
    ),
  );
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
      home: Consumer<RestaurantProvider>(
        builder: ((context, value, child) {
          if (value.state == ResultState.loading) {
            return const LoadingPage();
          } else if (value.state == ResultState.error) {
            return const ErrorPage();
          }

          return const HomePage();
        }),
      ),
    );
  }
}
