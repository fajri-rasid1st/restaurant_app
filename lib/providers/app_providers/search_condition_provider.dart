// Flutter imports:
import 'package:flutter/foundation.dart';

/// Provider untuk mengatur state kondisi pencarian
class SearchConditionProvider extends ChangeNotifier {
  bool _value = false;

  bool get value => _value;

  set value(bool newValue) {
    if (_value == newValue) return;

    _value = newValue;
    notifyListeners();
  }
}
