// Dart imports:
import 'dart:convert';

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:timezone/data/latest_all.dart' as tzdata;
import 'package:timezone/timezone.dart' as tz;
import 'package:workmanager/workmanager.dart';

// Project imports:
import 'package:restaurant_app/common/routes/route_names.dart';

class LocalNotificationService {
  // Singleton pattern
  static final LocalNotificationService instance = LocalNotificationService._internal();

  LocalNotificationService._internal();

  factory LocalNotificationService() => instance;

  // Instance flutter local notifications plugin
  final FlutterLocalNotificationsPlugin _fln = FlutterLocalNotificationsPlugin();

  // Android notification channel
  late AndroidNotificationChannel _channel;

  // Navigator key untuk navigasi dari notifikasi
  GlobalKey<NavigatorState>? _navigatorKey;

  static const String _channelId = 'daily_restaurant_channel';
  static const String _channelName = 'Daily Restaurant Reminder';
  static const String _channelDescription = 'Pengingat harian rekomendasi restoran';

  static const String _dailyTaskUniqueName = 'daily-restaurant-reminder';
  static const String _dailyTaskName = 'daily-restaurant-reminder';

  Future<void> initialize({GlobalKey<NavigatorState>? navigatorKey}) async {
    _navigatorKey = navigatorKey;

    // Konfigurasi local timezone
    tzdata.initializeTimeZones();

    final timezoneInfo = await FlutterTimezone.getLocalTimezone();

    tz.setLocalLocation(tz.getLocation(timezoneInfo.identifier));

    // Init Android and iOS settings
    const initSettingsAndroid = AndroidInitializationSettings('@mipmap/ic_launcher');
    const initSettingsIOS = DarwinInitializationSettings();
    const initSettingsNotification = InitializationSettings(
      android: initSettingsAndroid,
      iOS: initSettingsIOS,
    );

    await _fln.initialize(
      initSettingsNotification,
      onDidReceiveNotificationResponse: _onTapForeground,
      onDidReceiveBackgroundNotificationResponse: notificationTapBackground,
    );

    // Create channel (Android only)
    _channel = AndroidNotificationChannel(
      _channelId,
      _channelName,
      description: _channelDescription,
      importance: Importance.max,
    );

    await _fln
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(_channel);
  }

  /// Handle jika app diluncurkan dari tap notifikasi (terminated)
  Future<void> handleLaunchFromNotificationIfAny() async {
    final details = await _fln.getNotificationAppLaunchDetails();

    if (details?.didNotificationLaunchApp == true) {
      final payload = details!.notificationResponse?.payload;

      if (payload != null) _navigateToDetailFromPayload(payload);
    }
  }

  /// Callback untuk Android saat app on background.
  ///
  /// Navigasi akan diproses saat app kembali ke foreground melalui [handleLaunchFromNotificationIfAny]
  @pragma('vm:entry-point')
  static void notificationTapBackground(NotificationResponse response) {}

  void _onTapForeground(NotificationResponse response) {
    final payload = response.payload;

    if (payload != null) _navigateToDetailFromPayload(payload);
  }

  void _navigateToDetailFromPayload(String payload) {
    try {
      final map = jsonDecode(payload) as Map<String, dynamic>;

      final id = map['restaurantId']?.toString();
      if (id == null) return;

      final navigator = _navigatorKey?.currentState;
      if (navigator == null) return;

      navigator.pushNamed(
        Routes.detail,
        arguments: {'id': id},
      );
    } catch (e) {
      debugPrint('Failed to navigate from payload: $e');
    }
  }

  /// Memulai reminder harian [hour]:[minute] (default: 11:00).
  ///
  /// [interval] dapat digunakan untuk testing, misal. Duration(minutes: 5).
  Future<void> enableDailyReminder({
    int hour = 11,
    int minute = 0,
    Duration? interval,
  }) async {
    // disable first
    await disableDailyReminder();

    if (interval == null) {
      final initialDelay = _computeInitialDelay(hour, minute);

      await Workmanager().registerPeriodicTask(
        _dailyTaskUniqueName,
        _dailyTaskName,
        initialDelay: initialDelay,
        frequency: Duration(hours: 24),
        constraints: Constraints(
          networkType: NetworkType.connected,
        ),
        inputData: {
          'hour': hour,
          'minute': minute,
          'mode': 'daily',
        },
        existingWorkPolicy: ExistingPeriodicWorkPolicy.update,
        backoffPolicy: BackoffPolicy.linear,
        backoffPolicyDelay: Duration(minutes: 5),
      );
    } else {
      // Catatan: Android periodic minimal 15 menit
      if (interval.inMinutes >= 15) {
        await Workmanager().registerPeriodicTask(
          _dailyTaskUniqueName,
          _dailyTaskName,
          frequency: interval,
          constraints: Constraints(
            networkType: NetworkType.connected,
          ),
          inputData: {
            'mode': 'dev_periodic',
            'devMinutes': interval.inMinutes,
          },
          existingWorkPolicy: ExistingPeriodicWorkPolicy.update,
        );
      } else {
        // Jika < 15 menit, gunakan one-off-task.
        await Workmanager().registerOneOffTask(
          _dailyTaskUniqueName,
          _dailyTaskName,
          initialDelay: interval,
          constraints: Constraints(
            networkType: NetworkType.connected,
          ),
          inputData: {
            'mode': 'dev_chain',
            'devMinutes': interval.inMinutes,
          },
          existingWorkPolicy: ExistingWorkPolicy.update,
        );
      }
    }
  }

  Future<void> disableDailyReminder() async {
    await Workmanager().cancelByUniqueName(_dailyTaskUniqueName);

    // Batalkan notifikasi yang mungkin tersisa (opsional)
    await _fln.cancelAll();
  }

  Duration _computeInitialDelay(int hour, int minute) {
    final now = tz.TZDateTime.now(tz.local);

    var next = tz.TZDateTime(tz.local, now.year, now.month, now.day, hour, minute);

    if (!next.isAfter(now)) {
      next = next.add(Duration(days: 1));
    }

    return next.difference(now);
  }

  /// Utility untuk menampilkan notifikasi (dipakai di worker).
  Future<void> showSimpleNotification({
    required int id,
    required String title,
    required String body,
    required String payload,
  }) async {
    final androidNotificationDetails = AndroidNotificationDetails(
      _channelId,
      _channel.name,
      channelDescription: _channel.description,
      importance: Importance.max,
      priority: Priority.high,
      styleInformation: BigTextStyleInformation(''),
    );
    final iosNotificationDetails = DarwinNotificationDetails();
    final notificationDetails = NotificationDetails(
      android: androidNotificationDetails,
      iOS: iosNotificationDetails,
    );

    await _fln.show(
      id,
      title,
      body,
      notificationDetails,
      payload: payload,
    );
  }
}
