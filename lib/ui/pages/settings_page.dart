// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:restaurant_app/common/extensions/text_style_extension.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return NestedScrollView(
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
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
      ),
    );
  }
}
