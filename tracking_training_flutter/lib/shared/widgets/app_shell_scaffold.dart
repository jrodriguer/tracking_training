import 'package:flutter/material.dart';

import '../utils/breakpoints.dart';

class AppShellScaffold extends StatelessWidget {
  const AppShellScaffold({
    required this.title,
    required this.currentIndex,
    required this.onDestinationSelected,
    required this.child,
    super.key,
  });

  final String title;
  final int currentIndex;
  final ValueChanged<int> onDestinationSelected;
  final Widget child;

  static const _destinations = [
    (
      label: 'Routines',
      icon: Icons.calendar_today_outlined,
      selectedIcon: Icons.calendar_today,
    ),
    (
      label: 'Workouts',
      icon: Icons.fitness_center_outlined,
      selectedIcon: Icons.fitness_center,
    ),
    (
      label: 'Progress',
      icon: Icons.show_chart_outlined,
      selectedIcon: Icons.show_chart,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final breakpoint = breakpointForWidth(constraints.maxWidth);

        return switch (breakpoint) {
          AppBreakpoint.phone => _buildPhoneLayout(context),
          AppBreakpoint.tablet ||
          AppBreakpoint.desktop => _buildWideLayout(context, breakpoint),
        };
      },
    );
  }

  Widget _buildPhoneLayout(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: SafeArea(child: child),
      bottomNavigationBar: NavigationBar(
        selectedIndex: currentIndex,
        onDestinationSelected: onDestinationSelected,
        destinations: [
          for (final destination in _destinations)
            NavigationDestination(
              icon: Icon(destination.icon),
              selectedIcon: Icon(destination.selectedIcon),
              label: destination.label,
            ),
        ],
      ),
    );
  }

  Widget _buildWideLayout(BuildContext context, AppBreakpoint breakpoint) {
    final maxContentWidth = breakpoint == AppBreakpoint.desktop
        ? 1200.0
        : 900.0;

    return Scaffold(
      body: SafeArea(
        child: Row(
          children: [
            NavigationRail(
              selectedIndex: currentIndex,
              onDestinationSelected: onDestinationSelected,
              labelType: NavigationRailLabelType.all,
              destinations: [
                for (final destination in _destinations)
                  NavigationRailDestination(
                    icon: Icon(destination.icon),
                    selectedIcon: Icon(destination.selectedIcon),
                    label: Text(destination.label),
                  ),
              ],
            ),
            const VerticalDivider(width: 1),
            Expanded(
              child: Align(
                alignment: Alignment.topCenter,
                child: ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: maxContentWidth),
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: Theme.of(context).textTheme.headlineMedium,
                        ),
                        const SizedBox(height: 16),
                        Expanded(child: child),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
