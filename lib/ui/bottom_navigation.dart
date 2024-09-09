import 'package:flutter/material.dart';

class BottomNavigation extends StatelessWidget {
  final int pageIndex;
  final List<NavigationDestination> items;
  final Function(int) onSelectTab;

  const BottomNavigation({super.key, required this.items, this.pageIndex = 0, required this.onSelectTab});

  @override
  Widget build(BuildContext context) {
    ColorScheme colorScheme = Theme.of(context).colorScheme;

    return NavigationBar(
      destinations: items,
      selectedIndex: pageIndex,
      backgroundColor: Color(colorScheme.surface.value).withOpacity(0.5),
      elevation: 1,
      onDestinationSelected: (int index) => onSelectTab(index),
    );
  }
}
