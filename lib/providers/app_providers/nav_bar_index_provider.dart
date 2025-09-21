// Flutter imports:
import 'package:flutter/foundation.dart';

/// Provider untuk mengelola index dari NavigationBar
class NavBarIndexProvider extends ChangeNotifier {
  int _value = 0;

  int get value => _value;

  set value(int newValue) {
    if (_value == newValue) return;

    _value = newValue;
    notifyListeners();
  }
}
