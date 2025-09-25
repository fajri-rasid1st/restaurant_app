// Flutter imports:
import 'package:flutter/foundation.dart';

// Project imports:
import 'package:restaurant_app/services/prefs/restaurant_settings_prefs.dart';

class IsDarkModeActivedProvider extends ChangeNotifier {
  final RestaurantSettingsPrefs prefs;

  IsDarkModeActivedProvider(this.prefs);

  bool _value = false;

  bool get value => _value;

  Future<bool> loadValue() async {
    final result = await prefs.getIsDarkModeActived();

    _value = result;
    notifyListeners();

    return _value;
  }

  Future<void> setValue(bool newValue) async {
    if (_value == newValue) return;

    _value = newValue;
    notifyListeners();

    await prefs.setIsDarkModeActived(newValue);
  }
}
