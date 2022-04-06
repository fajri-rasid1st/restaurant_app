import 'package:flutter/foundation.dart';

class PageReloadProvider extends ChangeNotifier {
  bool _isReload = false;

  bool get isReload => _isReload;

  set isReload(bool value) {
    _isReload = value;
    notifyListeners();
  }
}
