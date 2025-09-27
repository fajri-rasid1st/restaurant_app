// Flutter imports:
import 'package:flutter/foundation.dart';

// Project imports:
import 'package:restaurant_app/services/prefs/restaurant_settings_prefs.dart';

class DarkModeProvider extends ChangeNotifier {
  final RestaurantSettingsPrefs prefs;

  DarkModeProvider(this.prefs);

  bool _value = false;

  bool get value => _value;

  Future<bool> loadValue() async {
    final result = await prefs.getValue(kDarkModeKey);

    _value = result;
    notifyListeners();

    return _value;
  }

  Future<void> setValue(bool newValue) async {
    if (_value == newValue) return;

    _value = newValue;

    await prefs.setValue(kDarkModeKey, newValue);

    notifyListeners();
  }
}
