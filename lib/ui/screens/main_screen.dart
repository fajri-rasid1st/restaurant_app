// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:provider/provider.dart';

// Project imports:
import 'package:restaurant_app/common/extensions/text_style_extension.dart';
import 'package:restaurant_app/common/routes/route_names.dart';
import 'package:restaurant_app/common/utilities/navigator_key.dart';
import 'package:restaurant_app/providers/app_providers/nav_bar_index_provider.dart';
import 'package:restaurant_app/ui/pages/discover_page.dart';
import 'package:restaurant_app/ui/pages/settings_page.dart';
import 'package:restaurant_app/ui/widgets/scaffold_safe_area.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const pages = [
      DiscoverPage(),
      SettingsPage(),
    ];

    return Consumer<NavBarIndexProvider>(
      builder: (context, provider, child) {
        final selectedIndex = provider.value;

        return PopScope(
          canPop: selectedIndex == 0,
          onPopInvokedWithResult: (didPop, result) {
            if (didPop) return;

            provider.value = 0;
          },
          child: ScaffoldSafeArea(
            body: pages[selectedIndex],
            bottomNavigationBar: NavigationBar(
              height: 72,
              selectedIndex: selectedIndex,
              onDestinationSelected: (index) => provider.value = index,
              destinations: [
                NavigationDestination(
                  icon: Icon(Icons.explore_outlined),
                  selectedIcon: Icon(Icons.explore),
                  label: 'Jelajahi',
                ),
                NavigationDestination(
                  icon: Icon(Icons.settings_outlined),
                  selectedIcon: Icon(Icons.settings),
                  label: 'Pengaturan',
                ),
              ],
              labelTextStyle: WidgetStateProperty.fromMap({
                WidgetState.selected: Theme.of(context).textTheme.labelMedium!.bold.colorOnSurface(context),
                WidgetState.any: Theme.of(context).textTheme.labelMedium!.bold.colorOnSurfaceVariant(context),
              }),
            ),
            floatingActionButton: selectedIndex == 0
                ? FloatingActionButton(
                    elevation: 4,
                    focusElevation: 6,
                    hoverElevation: 6,
                    highlightElevation: 6,
                    heroTag: 'favorites_fab',
                    tooltip: 'Favorit',
                    onPressed: () => navigatorKey.currentState!.pushNamed(Routes.favorites),
                    child: Icon(
                      Icons.favorite_rounded,
                      size: 26,
                    ),
                  )
                : null,
          ),
        );
      },
    );
  }
}
