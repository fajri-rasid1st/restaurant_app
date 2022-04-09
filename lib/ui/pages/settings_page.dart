import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_app/common/result_state.dart';
import 'package:restaurant_app/providers/scheduling_provider.dart';
import 'package:restaurant_app/ui/screens/loading_screen.dart';
import 'package:restaurant_app/ui/themes/color_scheme.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<SchedulingProvider>(
      builder: (context, schedulingProvider, child) {
        if (schedulingProvider.state == ResultState.loading) {
          return const LoadingScreen();
        }

        return _buildSwitch(schedulingProvider);
      },
    );
  }

  /// Untuk membuat widget switch
  Padding _buildSwitch(SchedulingProvider schedulingProvider) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: ListTile(
        title: const Text('Notifikasi Restaurant'),
        subtitle: const Text('Akan muncul tiap pukul 11.00 AM'),
        trailing: Switch(
          activeColor: primaryColor,
          activeTrackColor: secondaryColor,
          value: schedulingProvider.isScheduled,
          onChanged: (value) async {
            await schedulingProvider.scheduledRestaurant(value);
            await schedulingProvider.setSwitchValue(value);
          },
        ),
      ),
    );
  }
}
