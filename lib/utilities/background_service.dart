import 'dart:ui';
import 'dart:isolate';
import 'dart:math' as math;
import 'package:restaurant_app/data/api/notification_api.dart';
import 'package:restaurant_app/data/api/restaurant_api.dart';
import 'package:restaurant_app/main.dart';

// Inisialisasi port untuk menerima pesan (digunakan untuk komunikasi pada background)
final port = ReceivePort();

class BackgroundService {
  static BackgroundService? _service;

  BackgroundService._internal() {
    _service = this;
  }

  factory BackgroundService() => _service ?? BackgroundService._internal();

  static SendPort? _uiSendPort;
  static const String _isolateName = 'isolate';

  /// Mendaftarkan SendPort isolate UI untuk memungkinkan komunikasi dari
  /// isolate background
  void initIsolate() {
    IsolateNameServer.registerPortWithName(port.sendPort, _isolateName);
  }

  /// Mengambil data list restaurant lalu dimasukkan sebagai parameter pada
  /// fungsi [showNotification]. Digunakan fungsi [math.Random] untuk mengambil
  /// index secara random pada list restaurant.
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
