// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:provider/provider.dart';

// Project imports:
import 'package:restaurant_app/common/extensions/text_style_extension.dart';
import 'package:restaurant_app/providers/local_notification_providers/local_notification_provider.dart';
import 'package:restaurant_app/providers/prefs_providers/is_daily_reminder_enabled_provider.dart';
import 'package:restaurant_app/providers/prefs_providers/is_dark_mode_enabled_provider.dart';
import 'package:restaurant_app/providers/prefs_providers/is_restaurant_recommendation_enabled_provider.dart';
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
            Consumer<IsDarkModeEnabledProvider>(
              builder: (context, provider, _) {
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
            Consumer2<IsDailyReminderEnabledProvider, LocalNotificationProvider>(
              builder: (context, isDailyReminderEnabledProvider, localNotificationProvider, _) {
                return buildSwitch(
                  context: context,
                  title: 'Daily Reminder',
                  subtitle: 'Pengingat makan siang tiap pukul 11 AM',
                  value: isDailyReminderEnabledProvider.value,
                  onChanged: (value) async {
                    isDailyReminderEnabledProvider.setValue(value);

                    if (value) {
                      await localNotificationProvider.requestPermissions();

                      if (!context.mounted) return;

                      if (localNotificationProvider.permission != null && localNotificationProvider.permission!) {
                        localNotificationProvider.scheduleDailyNotification(14); // ganti sesuai keinginan
                      }
                    } else {
                      localNotificationProvider.cancelNotification(localNotificationProvider.notificationId);
                    }
                  },
                );
              },
            ),
            Consumer2<IsRestaurantRecommendationEnabledProvider, LocalNotificationProvider>(
              builder: (context, isRestaurantRecommendationEnabledProvider, localNotificationProvider, child) {
                return buildSwitch(
                  context: context,
                  title: 'Notifikasi Rekomendasi Restoran',
                  subtitle: 'Pemberitahuan rekomendasi restoran tiap beberapa saat',
                  value: isRestaurantRecommendationEnabledProvider.value,
                  onChanged: (value) async {
                    isRestaurantRecommendationEnabledProvider.setValue(value);

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
