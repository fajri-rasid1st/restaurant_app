// Dart imports:
import 'dart:convert';
import 'dart:math';

// Package imports:
import 'package:workmanager/workmanager.dart';

// Project imports:
import 'package:restaurant_app/common/utilities/navigator_key.dart';
import 'package:restaurant_app/services/api/restaurant_api.dart';
import 'package:restaurant_app/services/notifications/local_notification_service.dart';

const String uniqueName = "com.example.restaurant_app";
const String taskName = "notificationTask";

@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    final restaurantApiService = RestaurantApi();
    final localNotificationService = LocalNotificationService();

    await localNotificationService.initialize(navigatorKey: navigatorKey);

    if (task == taskName) {
      final restaurants = await restaurantApiService.getRestaurants();
      final randIndex = Random().nextInt(restaurants.length);
      final restaurant = restaurants[randIndex];

      await localNotificationService.showNotification(
        id: randIndex,
        title: 'Waktunya makan siang ⏰',
        body: 'Anda mungkin tertarik dengan restoran "${restaurant.name}"',
        payload: jsonEncode(restaurant.toMap()),
      );
    }

    return Future.value(true);
  });
}

class WorkmanagerService {
  final Workmanager _workmanager;

  WorkmanagerService([Workmanager? workmanager]) : _workmanager = workmanager ??= Workmanager();

  Future<void> init() async {
    await _workmanager.initialize(
      callbackDispatcher,
      // ignore: deprecated_member_use
      isInDebugMode: true,
    );
  }

  Future<void> runPeriodicTask() async {
    await _workmanager.registerPeriodicTask(
      uniqueName,
      taskName,
      frequency: Duration(hours: 3),
      initialDelay: Duration(minutes: 3),
      constraints: Constraints(
        networkType: NetworkType.connected,
      ),
      existingWorkPolicy: ExistingPeriodicWorkPolicy.replace,
      inputData: {"data": "data"},
    );
  }

  Future<void> cancelAllTask() async {
    await _workmanager.cancelAll();
  }

  // Duration calculateInitialDelay(int hour) {
  //   final now = DateTime.now();
  //   final scheduled = DateTime(now.year, now.month, now.day, hour, 0, 0);

  //   if (now.isAfter(scheduled)) {
  //     // If it's after [hour] today, schedule for [hour] tomorrow
  //     final tomorrow = now.add(Duration(days: 1));
  //     final hourTomorrow = DateTime(tomorrow.year, tomorrow.month, tomorrow.day, hour, 0, 0);

  //     return hourTomorrow.difference(now);
  //   } else {
  //     // If it's before [hour] today, schedule for [hour] today
  //     return scheduled.difference(now);
  //   }
  // }
}
