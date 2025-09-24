// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:provider/provider.dart';

// Project imports:
import 'package:restaurant_app/common/extensions/text_style_extension.dart';
import 'package:restaurant_app/providers/prefs_providers/is_daily_reminder_actived_provider.dart';
import 'package:restaurant_app/providers/prefs_providers/is_dark_mode_actived_provider.dart';

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
            Consumer<IsDarkModeActivedProvider>(
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
            Consumer<IsDailyReminderActivedProvider>(
              builder: (context, provider, child) {
                final isActive = provider.value;

                return buildSwitch(
                  context: context,
                  title: 'Notifikasi Restoran',
                  subtitle: 'Akan muncul setiap pukul 11.00 AM',
                  value: isActive,
                  onChanged: (value) => provider.setValue(value),
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
