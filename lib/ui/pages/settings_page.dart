import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_app/providers/scheduling_provider.dart';
import 'package:restaurant_app/ui/screens/loading_screen.dart';
import 'package:restaurant_app/ui/themes/color_scheme.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<SharedPreferences>(
      future: SharedPreferences.getInstance(),
      builder: ((context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasData) {
            bool? value = snapshot.data!.getBool('switch_key');

            if (value == null) {
              snapshot.data!.setBool('switch_key', false);
            }

            return _buildSwitch(snapshot.data!.getBool('switch_key')!);
          }
        }

        return const LoadingScreen();
      }),
    );
  }

  Padding _buildSwitch(bool value) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: ListTile(
        title: const Text('Notifikasi Restaurant'),
        subtitle: const Text('Akan muncul tiap pukul 11.00 AM'),
        trailing: Builder(
          builder: (context) {
            return Switch(
              activeColor: primaryColor,
              activeTrackColor: secondaryColor,
              value: context.watch<SchedulingProvider>().isScheduled,
              onChanged: (value) async {
                context.read<SchedulingProvider>().scheduledRestaurant(value);
                context.read<SchedulingProvider>().isScheduled = value;

                setSwitchValue(value);
              },
            );
          },
        ),
      ),
    );
  }

  Future<void> setSwitchValue(bool value) async {
    final prefs = await SharedPreferences.getInstance();

    prefs.setBool('switch_key', value);
  }
}
