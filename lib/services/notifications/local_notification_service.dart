// Dart imports:
import 'dart:convert';

// Flutter imports:
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:timezone/data/latest_all.dart' as tzdata;
import 'package:timezone/timezone.dart' as tz;

// Project imports:
import 'package:restaurant_app/common/routes/route_names.dart';

// Instance of flutter local notifications plugin
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

class LocalNotificationService {
  // Singleton pattern
  static final LocalNotificationService _instance = LocalNotificationService._internal();

  LocalNotificationService._internal();

  factory LocalNotificationService() => _instance;

  // Navigator key untuk navigasi dari notifikasi
  GlobalKey<NavigatorState>? _navigatorKey;

  /// Init Android and iOS settings
  Future<void> initialize({GlobalKey<NavigatorState>? navigatorKey}) async {
    _navigatorKey = navigatorKey;

    const initializationSettingsAndroid = AndroidInitializationSettings(
      '@mipmap/ic_launcher',
    );

    const initializationSettingsDarwin = DarwinInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
    );

    final initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsDarwin,
    );

    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: notificationTapForeground,
      onDidReceiveBackgroundNotificationResponse: notificationTapBackground,
    );
  }

  Future<bool> _isAndroidPermissionGranted() async {
    return await flutterLocalNotificationsPlugin
            .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
            ?.areNotificationsEnabled() ??
        false;
  }

  Future<bool> _requestAndroidNotificationsPermission() async {
    return await flutterLocalNotificationsPlugin
            .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
            ?.requestNotificationsPermission() ??
        false;
  }

  Future<bool> _requestExactAlarmsPermission() async {
    return await flutterLocalNotificationsPlugin
            .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
            ?.requestExactAlarmsPermission() ??
        false;
  }

  Future<bool?> requestPermissions() async {
    if (defaultTargetPlatform == TargetPlatform.iOS) {
      final iOSImplementation = flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<IOSFlutterLocalNotificationsPlugin>();

      return await iOSImplementation?.requestPermissions(
        alert: true,
        badge: true,
        sound: true,
      );
    } else if (defaultTargetPlatform == TargetPlatform.android) {
      final notificationEnabled = await _isAndroidPermissionGranted();
      final requestAlarmEnabled = await _requestExactAlarmsPermission();

      if (!notificationEnabled) {
        final requestNotificationsPermission = await _requestAndroidNotificationsPermission();

        return requestNotificationsPermission && requestAlarmEnabled;
      }

      return notificationEnabled && requestAlarmEnabled;
    } else {
      return false;
    }
  }

  Future<void> showNotification({
    required int id,
    required String title,
    required String body,
    required String payload,
  }) async {
    const androidPlatformChannelSpecifics = AndroidNotificationDetails(
      '1',
      'Simple Notification',
      importance: Importance.max,
      priority: Priority.high,
    );

    const iOSPlatformChannelSpecifics = DarwinNotificationDetails();

    final notificationDetails = NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: iOSPlatformChannelSpecifics,
    );

    await flutterLocalNotificationsPlugin.show(
      id,
      title,
      body,
      notificationDetails,
      payload: payload,
    );
  }

  /// Handle jika aplikasi dibuka saat menekan notifikasi
  Future<void> handleLaunchFromNotificationIfAny() async {
    final details = await flutterLocalNotificationsPlugin.getNotificationAppLaunchDetails();

    if (details?.didNotificationLaunchApp == true) {
      final payload = details!.notificationResponse?.payload;

      if (payload != null) _navigateToDetailFromPayload(payload);
    }
  }

  void notificationTapForeground(NotificationResponse response) {
    final payload = response.payload;

    if (payload != null) _navigateToDetailFromPayload(payload);
  }

  /// **Callback untuk Android saat aplikasi berada di background**
  ///
  /// Navigasi akan diproses saat app kembali ke foreground melalui [handleLaunchFromNotificationIfAny]
  @pragma('vm:entry-point')
  static void notificationTapBackground(NotificationResponse response) {}

  void _navigateToDetailFromPayload(String payload) {
    try {
      final map = jsonDecode(payload) as Map<String, dynamic>;
      debugPrint(map.toString());

      final id = map['id']?.toString();
      debugPrint(id);
      if (id == null) return;

      final navigator = _navigatorKey?.currentState;
      debugPrint((navigator != null).toString());
      if (navigator == null) return;

      navigator.pushNamed(
        Routes.detail,
        arguments: {'id': id},
      );
    } catch (e) {
      debugPrint('Failed to navigate from payload: $e');
    }
  }

  Future<void> cancelNotification(int id) async {
    await flutterLocalNotificationsPlugin.cancel(id);
  }

  /// zoned-schedule: configure the local timezone
  Future<void> configureLocalTimeZone() async {
    tzdata.initializeTimeZones();

    final timezoneInfo = await FlutterTimezone.getLocalTimezone();

    debugPrint("fajri: ${timezoneInfo.identifier}");

    tz.setLocalLocation(tz.getLocation(timezoneInfo.identifier));
  }

  /// zoned-schedule: set the timer, either today or tommorow at [hour] o'clock.
  tz.TZDateTime _nextInstanceOfHour(int hour) {
    final now = tz.TZDateTime.now(tz.local);

    var scheduled = tz.TZDateTime(tz.local, now.year, now.month, now.day, hour);

    if (scheduled.isBefore(now)) {
      scheduled = scheduled.add(Duration(days: 1));
    }

    return scheduled;
  }

  /// zoned-schedule: run the schedule daily notification
  Future<void> scheduleDailyNotification({
    required int id,
    required String title,
    required String body,
    required String payload,
    int? hour,
  }) async {
    const androidPlatformChannelSpecifics = AndroidNotificationDetails(
      '2',
      'Scheduled Notification',
      importance: Importance.max,
      priority: Priority.high,
      ticker: 'ticker',
    );

    const iOSPlatformChannelSpecifics = DarwinNotificationDetails();

    final notificationDetails = NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: iOSPlatformChannelSpecifics,
    );

    final datetimeSchedule = _nextInstanceOfHour(hour ?? 11);

    await flutterLocalNotificationsPlugin.zonedSchedule(
      id,
      title,
      body,
      datetimeSchedule,
      notificationDetails,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      matchDateTimeComponents: DateTimeComponents.time,
      payload: payload,
    );
  }
}
