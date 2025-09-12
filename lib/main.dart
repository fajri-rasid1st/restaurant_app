import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:restaurant_app/app.dart';

Future<void> main() async {
  // Pastikan widget Flutter sudah diinisialisasi
  WidgetsFlutterBinding.ensureInitialized();

  // Untuk mencegah orientasi landscape
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  runApp(const RestaurantApp());
}
