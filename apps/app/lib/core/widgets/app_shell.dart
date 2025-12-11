import 'package:app/core/routing/app_routes.dart';
import 'package:app/core/routing/route_paths.dart';
import 'package:app/core/widgets/responsive_builder.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AppShell extends StatelessWidget {
  final Widget child;

  const AppShell({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final location = GoRouterState.of(context).uri.toString();
    final device = ResponsiveBuilder.getDeviceSize(context);

    final int currentIndex = _getCurrentIndex(location);

    if (device == DeviceSize.desktop || device == DeviceSize.tablet) {
      return Scaffold(
        body: Row(
          children: [
            _DesktopRail(currentIndex: currentIndex),
            const VerticalDivider(width: 1),
            Expanded(child: child),
          ],
        ),
      );
    }

    return Scaffold(
      body: child,
      bottomNavigationBar: _BottomNav(
        currentIndex: currentIndex,
      ),
    );
  }

  int _getCurrentIndex(String location) {
    if (location.startsWith(RoutePaths.projects)) return 0;
    if (location.startsWith(RoutePaths.myWork)) return 1;
    if (location.startsWith(RoutePaths.settings)) return 2;
    return 0;
  }
}

// ───────────────── Desktop Rail ─────────────────

class _DesktopRail extends StatelessWidget {
  final int currentIndex;

  const _DesktopRail({required this.currentIndex});

  @override
  Widget build(BuildContext context) {
    return NavigationRail(
      selectedIndex: currentIndex,
      labelType: NavigationRailLabelType.all,
      onDestinationSelected: (i) => _goTo(context, i),
      destinations: const [
        NavigationRailDestination(
          icon: Icon(Icons.dashboard_outlined),
          selectedIcon: Icon(Icons.dashboard),
          label: Text('Projects'),
        ),
        NavigationRailDestination(
          icon: Icon(Icons.check_circle_outline),
          selectedIcon: Icon(Icons.check_circle),
          label: Text('My Work'),
        ),
        NavigationRailDestination(
          icon: Icon(Icons.settings_outlined),
          selectedIcon: Icon(Icons.settings),
          label: Text('Settings'),
        ),
      ],
    );
  }
}

// ───────────────── Bottom Nav ─────────────────

class _BottomNav extends StatelessWidget {
  final int currentIndex;

  const _BottomNav({required this.currentIndex});

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: (i) => _goTo(context, i),
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.dashboard_outlined),
          label: 'Projects',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.check_circle_outline),
          label: 'My Work',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.settings_outlined),
          label: 'Settings',
        ),
      ],
    );
  }
}

void _goTo(BuildContext context, int index) {
  switch (index) {
    case 0:
      context.goNamed(AppRouteNames.projects);
      break;
    case 1:
      context.goNamed(AppRouteNames.myWork);
      break;
    case 2:
      context.goNamed(AppRouteNames.settings);
      break;
  }
}
