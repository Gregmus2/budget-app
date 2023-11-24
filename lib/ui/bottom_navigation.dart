import 'package:flutter/material.dart';

class BottomNavigation extends StatelessWidget {
  final int pageIndex;
  final List<BottomNavigationBarItem> items;
  final Function(int) onSelectTab;

  const BottomNavigation({super.key, required this.items, this.pageIndex = 0, required this.onSelectTab});

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      items: items,
      currentIndex: pageIndex,
      selectedItemColor: Colors.white,
      unselectedItemColor: Colors.white.withOpacity(0.5),
      backgroundColor: const Color.fromRGBO(42, 45, 66, 0.5),
      elevation: 1,
      onTap: (int index) => onSelectTab(index),
    );
  }
}
