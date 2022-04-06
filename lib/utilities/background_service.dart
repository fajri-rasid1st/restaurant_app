import 'dart:ui';
import 'dart:isolate';
import 'dart:math' as math;
import 'package:restaurant_app/data/api/notification_api.dart';
import 'package:restaurant_app/data/api/restaurant_api.dart';
import 'package:restaurant_app/main.dart';

final ReceivePort port = ReceivePort();

class BackgroundService {
  static BackgroundService? _instance;
  static SendPort? _uiSendPort;
  static const String _isolateName = 'isolate';

  BackgroundService._internal() {
    _instance = this;
  }

  factory BackgroundService() => _instance ?? BackgroundService._internal();

  void initIsolate() {
    IsolateNameServer.registerPortWithName(port.sendPort, _isolateName);
  }

  static Future<void> callback() async {
    final notificationApi = NotificationApi();
    final result = await RestaurantApi().getRestaurants();

    await notificationApi.showNotification(
      flutterLocalNotificationsPlugin,
      result[math.Random().nextInt(result.length)],
    );

    _uiSendPort ??= IsolateNameServer.lookupPortByName(_isolateName);
    _uiSendPort?.send(null);
  }
}
