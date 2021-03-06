import 'dart:io';
import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:restaurant_app/data/api/notification_api.dart';
import 'package:restaurant_app/data/api/restaurant_api.dart';
import 'package:restaurant_app/data/db/favorite_database.dart';
import 'package:restaurant_app/providers/bottom_nav_provider.dart';
import 'package:restaurant_app/providers/category_provider.dart';
import 'package:restaurant_app/providers/customer_review_provider.dart';
import 'package:restaurant_app/providers/database_provider.dart';
import 'package:restaurant_app/providers/favorite_provider.dart';
import 'package:restaurant_app/providers/page_reload_provider.dart';
import 'package:restaurant_app/providers/restaurant_detail_provider.dart';
import 'package:restaurant_app/providers/restaurant_provider.dart';
import 'package:restaurant_app/providers/restaurant_search_provider.dart';
import 'package:restaurant_app/providers/scheduling_provider.dart';
import 'package:restaurant_app/ui/screens/main_screen.dart';
import 'package:restaurant_app/ui/themes/color_scheme.dart';
import 'package:restaurant_app/ui/themes/text_theme.dart';
import 'package:restaurant_app/utilities/background_service.dart';

// Inisialisasi local notifikasi plugin
final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Untuk mencegah orientasi landskap
  SystemChrome.setPreferredOrientations(<DeviceOrientation>[
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // Ubah warna status bar
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    systemNavigationBarColor: backGroundColor,
    systemNavigationBarIconBrightness: Brightness.dark,
  ));

  final notificationApi = NotificationApi();
  final service = BackgroundService();

  service.initIsolate();

  if (Platform.isAndroid) await AndroidAlarmManager.initialize();

  await notificationApi.initNotifications(flutterLocalNotificationsPlugin);

  runApp(
    MultiProvider(
      providers: <SingleChildWidget>[
        ChangeNotifierProvider<RestaurantProvider>(
          create: (_) {
            return RestaurantProvider(restaurantApi: RestaurantApi());
          },
        ),
        ChangeNotifierProvider<RestaurantDetailProvider>(
          create: (_) {
            return RestaurantDetailProvider(restaurantApi: RestaurantApi());
          },
        ),
        ChangeNotifierProvider<RestaurantSearchProvider>(
          create: (_) {
            return RestaurantSearchProvider(restaurantApi: RestaurantApi());
          },
        ),
        ChangeNotifierProvider<CustomerReviewProvider>(
          create: (_) {
            return CustomerReviewProvider(restaurantApi: RestaurantApi());
          },
        ),
        ChangeNotifierProvider<DatabaseProvider>(
          create: (_) {
            return DatabaseProvider(favoriteDatabase: FavoriteDatabase());
          },
        ),
        ChangeNotifierProvider<FavoriteProvider>(
          create: (_) {
            return FavoriteProvider(favoriteDatabase: FavoriteDatabase());
          },
        ),
        ChangeNotifierProvider<CategoryProvider>(
          create: (_) => CategoryProvider(),
        ),
        ChangeNotifierProvider<BottomNavProvider>(
          create: (_) => BottomNavProvider(),
        ),
        ChangeNotifierProvider<PageReloadProvider>(
          create: (_) => PageReloadProvider(),
        ),
        ChangeNotifierProvider<SchedulingProvider>(
          create: (_) => SchedulingProvider(),
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
        fontFamily: 'Quicksand',
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
      home: const MainScreen(),
    );
  }
}
