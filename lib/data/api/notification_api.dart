import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:restaurant_app/data/models/restaurant.dart';
import 'package:restaurant_app/utilities/utilities.dart';
import 'package:rxdart/rxdart.dart';

final selectNotificationSubject = BehaviorSubject<String>();

class NotificationApi {
  static NotificationApi? _notificationApi;

  NotificationApi._internal() {
    _notificationApi = this;
  }

  factory NotificationApi() => _notificationApi ?? NotificationApi._internal();

  Future<void> initNotifications(
    FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin,
  ) async {
    const initSettingsAndroid = AndroidInitializationSettings('app_icon');

    const initSettingsIOS = IOSInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
    );

    const initSettings = InitializationSettings(
      android: initSettingsAndroid,
      iOS: initSettingsIOS,
    );

    await flutterLocalNotificationsPlugin.initialize(
      initSettings,
      onSelectNotification: (String? payload) async {
        selectNotificationSubject.add(payload ?? 'empty payload');
      },
    );
  }

  Future<void> showNotification(
    FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin,
    Restaurant restaurant,
  ) async {
    const _channelId = '1';
    const _channelName = 'channel_01';
    const _channelDescription = 'restaurant_channel';

    const androidPlatformChannelSpecifics = AndroidNotificationDetails(
      _channelId,
      _channelName,
      channelDescription: _channelDescription,
      importance: Importance.max,
      priority: Priority.high,
      ticker: 'ticker',
      styleInformation: DefaultStyleInformation(true, true),
    );

    const iOSPlatformChannelSpecifics = IOSNotificationDetails();

    const platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: iOSPlatformChannelSpecifics,
    );

    final title = '<b>${restaurant.name}</b>';
    const body = 'Rekomendasi restaurant untukmu. Klik untuk melihat detail.';

    await flutterLocalNotificationsPlugin.show(
      0,
      title,
      body,
      platformChannelSpecifics,
      payload: jsonEncode(restaurant.toMap()),
    );
  }

  void configureSelectNotificationSubject(BuildContext context) {
    selectNotificationSubject.stream.listen((String payload) {
      final result = jsonDecode(payload);
      final restaurant = Restaurant.fromMap(result);

      Utilities.navigateToDetailScreen(
        context: context,
        restaurant: restaurant,
      );
    });
  }
}
