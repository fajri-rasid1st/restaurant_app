// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:provider/provider.dart';

// Project imports:
import 'package:restaurant_app/common/extensions/text_style_extension.dart';
import 'package:restaurant_app/providers/local_notification_providers/local_notification_provider.dart';
import 'package:restaurant_app/providers/prefs_providers/daily_reminder_provider.dart';
import 'package:restaurant_app/providers/prefs_providers/dark_mode_provider.dart';
import 'package:restaurant_app/providers/prefs_providers/restaurant_recommendation_provider.dart';
import 'package:restaurant_app/services/notifications/work_manager_service.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return NestedScrollView(
      physics: NeverScrollableScrollPhysics(),
      headerSliverBuilder: (context, innerBoxIsScrolled) {
        return [
          SliverAppBar(
            pinned: true,
            title: Text('Pengaturan'),
            titleSpacing: 0,
            titleTextStyle: Theme.of(context).textTheme.titleLarge!.bold,
            leading: Icon(
              Icons.settings,
              size: 30,
            ),
          ),
        ];
      },
      body: Padding(
        padding: EdgeInsets.symmetric(
          vertical: 8,
          horizontal: 16,
        ),
        child: Column(
          children: [
            Consumer<DarkModeProvider>(
              builder: (context, provider, child) {
                final isActive = provider.value;

                return buildSwitch(
                  context: context,
                  title: 'Mode Gelap',
                  subtitle: isActive ? 'Aktif' : 'Nonaktif',
                  value: isActive,
                  onChanged: (value) => provider.setValue(value),
                );
              },
            ),
            Consumer2<DailyReminderProvider, LocalNotificationProvider>(
              builder: (context, dailyReminderProvider, localNotificationProvider, child) {
                return buildSwitch(
                  context: context,
                  title: 'Daily Reminder',
                  subtitle: 'Pengingat makan siang tiap pukul 11:00 AM',
                  value: dailyReminderProvider.value,
                  onChanged: (value) async {
                    dailyReminderProvider.setValue(value);

                    if (value) {
                      await localNotificationProvider.requestPermissions();

                      if (!context.mounted) return;

                      if (localNotificationProvider.permission != null && localNotificationProvider.permission!) {
                        localNotificationProvider.scheduleDailyNotification();
                      }
                    } else {
                      localNotificationProvider.cancelNotification(localNotificationProvider.notificationId);
                    }
                  },
                );
              },
            ),
            Consumer2<RestaurantRecommendationProvider, LocalNotificationProvider>(
              builder: (context, restaurantRecommendationProvider, localNotificationProvider, child) {
                return buildSwitch(
                  context: context,
                  title: 'Notifikasi Rekomendasi Restoran',
                  subtitle: 'Muncul tiap satu jam setelah pengingat makan siang',
                  value: restaurantRecommendationProvider.value,
                  onChanged: (value) async {
                    restaurantRecommendationProvider.setValue(value);

                    if (value) {
                      await localNotificationProvider.requestPermissions();

                      if (!context.mounted) return;

                      if (localNotificationProvider.permission != null && localNotificationProvider.permission!) {
                        context.read<WorkmanagerService>().runPeriodicTask();
                      }
                    } else {
                      context.read<WorkmanagerService>().cancelAllTask();
                    }
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  /// Widget untuk membuat switch
  Widget buildSwitch({
    required BuildContext context,
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      title: Text(title),
      titleTextStyle: Theme.of(context).textTheme.bodyLarge!.bold,
      subtitle: Text(subtitle),
      subtitleTextStyle: Theme.of(context).textTheme.bodySmall!.colorOnSurfaceVariant(context),
      trailing: Switch(
        value: value,
        onChanged: onChanged,
      ),
    );
  }
}
