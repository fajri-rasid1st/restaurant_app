import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:flutter/widgets.dart';
import 'package:restaurant_app/utilities/background_service.dart';
import 'package:restaurant_app/utilities/date_time_helper.dart';

class SchedulingProvider extends ChangeNotifier {
  bool _isScheduled = false;

  bool get isScheduled => _isScheduled;

  set isScheduled(bool value) {
    _isScheduled = value;
    notifyListeners();
  }

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
      );
    }

    return await AndroidAlarmManager.cancel(1);
  }
}
