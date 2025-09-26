// Flutter imports:
import 'package:flutter/widgets.dart';

// Project imports:
import 'package:restaurant_app/services/notifications/local_notification_service.dart';

class LocalNotificationProvider extends ChangeNotifier {
  final LocalNotificationService localNotificationService;

  LocalNotificationProvider(this.localNotificationService);

  int _notificationId = 0;
  bool? _permission = false;

  int get notificationId => _notificationId;
  bool? get permission => _permission;

  Future<void> requestPermissions() async {
    _permission = await localNotificationService.requestPermissions();
    notifyListeners();
  }

  Future<void> scheduleDailyNotification(int? hour) async {
    _notificationId += 1;

    await localNotificationService.scheduleDailyNotification(
      id: _notificationId,
      title: 'Waktunya makan siang ⏰',
      body: 'Cek restoran yang sesuai keinginanmu!',
      payload: '',
      hour: hour,
    );
  }

  Future<void> cancelNotification(int id) async {
    await localNotificationService.cancelNotification(id);
  }
}
