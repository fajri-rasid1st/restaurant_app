import 'package:flutter/foundation.dart';

class PageReloadProvider extends ChangeNotifier {
  bool _isPageReload = false;

  bool get isPageReload => _isPageReload;

  set isPageReload(bool value) {
    _isPageReload = value;
    notifyListeners();
  }
}
