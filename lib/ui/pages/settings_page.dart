import 'package:flutter/material.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: ListTile(
        leading: Text(
          'Nyalakan Notifikasi',
          style: Theme.of(context)
              .textTheme
              .bodyText1
              ?.copyWith(fontWeight: FontWeight.w700),
        ),
        trailing: StatefulBuilder(
          builder: (context, setState) {
            var isOn = false;

            return Switch(
              value: isOn,
              onChanged: (value) {
                setState(() => isOn = value);
              },
            );
          },
        ),
      ),
    );
  }
}
