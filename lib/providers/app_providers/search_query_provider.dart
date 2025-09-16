// Flutter imports:
import 'package:flutter/foundation.dart';

/// Provider untuk mengatur state query pencarian
class SearchQueryProvider extends ChangeNotifier {
  String _value = '';

  String get value => _value;

  set value(String newValue) {
    if (_value == newValue) return;

    _value = newValue;
    notifyListeners();
  }
}
