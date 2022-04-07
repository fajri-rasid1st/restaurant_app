import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:flutter/widgets.dart';
import 'package:restaurant_app/utilities/background_service.dart';
import 'package:restaurant_app/utilities/date_time_helper.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SchedulingProvider extends ChangeNotifier {
  SchedulingProvider() {
    getSwitchValue();
  }

  bool _isScheduled = false;

  bool get isScheduled => _isScheduled;

  /// Melakukan scheduling notifikasi.
  ///
  /// * Jika [value] bernilai true, akan dilakukan scheduling.
  /// * Jika [value] bernilai false, scheduling akan dibatalkan.
  Future<bool> scheduledRestaurant(bool value) async {
    _isScheduled = value;
    notifyListeners();

    if (_isScheduled) {
      return await AndroidAlarmManager.periodic(
        const Duration(minutes: 1),
        1,
        BackgroundService.callback,
        startAt: DateTimeHelper.dateTimeScheduled(),
        exact: true,
        wakeup: true,
        allowWhileIdle: true,
      );
    }

    return await AndroidAlarmManager.cancel(1);
  }

  Future<void> setSwitchValue(bool value) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setBool('switch_key', value);

    _isScheduled = value;
    notifyListeners();
  }

  Future<bool> getSwitchValue() async {
    final prefs = await SharedPreferences.getInstance();

    if (prefs.getBool('switch_key') == null) {
      await prefs.setBool('switch_key', false);
    }

    _isScheduled = prefs.getBool('switch_key')!;
    notifyListeners();

    return _isScheduled;
  }
}
