import 'dart:convert';
import 'dart:math';
import 'package:flutter/widgets.dart';
import 'package:restaurant_app/models/restaurant.dart';
import 'package:restaurant_app/services/api/restaurant_api.dart';
import 'package:restaurant_app/services/db/restaurant_database.dart';
import 'package:restaurant_app/services/notifications/local_notification_service.dart';
import 'package:workmanager/workmanager.dart';
import 'package:timezone/data/latest_all.dart' as tzdata;
import 'package:timezone/timezone.dart' as tz;
import 'package:flutter_timezone/flutter_timezone.dart';

@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    WidgetsFlutterBinding.ensureInitialized();

    // Konfigurasi local timezone di background isolate
    tzdata.initializeTimeZones();

    final timezoneInfo = await FlutterTimezone.getLocalTimezone();

    tz.setLocalLocation(tz.getLocation(timezoneInfo.identifier));

    final mode = inputData?['mode']?.toString() ?? 'daily';
    final devMinutes = int.tryParse((inputData?['devMinutes'] ?? '').toString());

    try {
      final restaurant = await _fetchRandomRestaurant();

      final payload = jsonEncode({
        'restaurantId': restaurant.id,
        'restaurantName': restaurant.name,
      });

      await LocalNotificationService().showSimpleNotification(
        id: 1100, // id channel harian
        title: 'Waktunya Makan Siang⏰',
        body: 'Coba, cek ${restaurant.name} hari ini 🍽️',
        payload: payload,
      );
    } catch (e) {
      debugPrint('Worker failed to fetch/show notification: $e');
    }

    // Jika mode devChain (<15 menit), re-enqueue one-off lagi
    if (mode == 'devChain' && devMinutes != null) {
      await Workmanager().registerOneOffTask(
        LocalNotificationService.dailyTaskUniqueName,
        LocalNotificationService.dailyTaskName,
        initialDelay: Duration(
          minutes: devMinutes,
        ),
        constraints: Constraints(
          networkType: NetworkType.connected,
        ),
        inputData: {
          'mode': 'devChain',
          'devMinutes': devMinutes,
        },
        existingWorkPolicy: ExistingWorkPolicy.update,
      );
    }

    return Future.value(true);
  });
}

Future<Restaurant> _fetchRandomRestaurant() async {
  final apiService = RestaurantApi();
  final dbService = RestaurantDatabase();

  final result = await apiService.getRestaurants();
  final randIndex = Random().nextInt(result.length);
  final restaurant = result[randIndex];
  final isFavorited = await dbService.isExist(restaurant.id);

  return restaurant.copyWith(isFavorited: isFavorited);
}
