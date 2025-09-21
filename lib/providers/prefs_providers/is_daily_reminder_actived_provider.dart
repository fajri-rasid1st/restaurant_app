// Flutter imports:
import 'package:flutter/foundation.dart';

// Project imports:
import 'package:restaurant_app/data/prefs/restaurant_settings_prefs.dart';

class IsDailyReminderActivedProvider extends ChangeNotifier {
  final RestaurantSettingsPrefs prefs;

  IsDailyReminderActivedProvider(this.prefs);

  bool _value = false;

  bool get value => _value;

  Future<bool> loadValue() async {
    final result = await prefs.getIsDailyReminderActived();

    _value = result;
    notifyListeners();

    return _value;
  }

  Future<void> setValue(bool newValue) async {
    if (_value == newValue) return;

    _value = newValue;
    notifyListeners();

    await prefs.setIsDailyReminderActived(newValue);
  }
}
