// Flutter imports:
import 'package:flutter/foundation.dart';

// Project imports:
import 'package:restaurant_app/services/prefs/restaurant_settings_prefs.dart';

class DailyReminderProvider extends ChangeNotifier {
  final RestaurantSettingsPrefs prefs;

  DailyReminderProvider(this.prefs);

  bool _value = false;

  bool get value => _value;

  Future<bool> loadValue() async {
    final result = await prefs.getValue(kDailyReminderKey);

    _value = result;
    notifyListeners();

    return _value;
  }

  Future<void> setValue(bool newValue) async {
    if (_value == newValue) return;

    _value = newValue;

    await prefs.setValue(kDailyReminderKey, newValue);

    notifyListeners();
  }
}
