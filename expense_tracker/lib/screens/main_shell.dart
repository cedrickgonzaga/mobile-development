import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import 'about_screen.dart';
import 'expense_list_screen.dart';
import 'home_screen.dart';

/// Holds the three top-level tabs.
///
/// The body is built from a plain switch rather than an IndexedStack so that
/// switching tabs recreates the screen and re-reads its data from SQLite.
class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _index = 0;

  void _selectTab(int index) {
    if (index == _index) return;
    setState(() => _index = index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: switch (_index) {
        0 => HomeScreen(onViewAll: () => _selectTab(1)),
        1 => const ExpenseListScreen(),
        _ => const AboutScreen(),
      },
      bottomNavigationBar: DecoratedBox(
        decoration: const BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: AppColors.charcoal08,
              blurRadius: 20,
              offset: Offset(0, -4),
            ),
          ],
        ),
        child: NavigationBar(
          selectedIndex: _index,
          onDestinationSelected: _selectTab,
          destinations: const [
            NavigationDestination(
              icon: Icon(Icons.space_dashboard_outlined),
              selectedIcon: Icon(Icons.space_dashboard_rounded),
              label: 'Home',
            ),
            NavigationDestination(
              icon: Icon(Icons.receipt_long_outlined),
              selectedIcon: Icon(Icons.receipt_long_rounded),
              label: 'Expenses',
            ),
            NavigationDestination(
              icon: Icon(Icons.info_outline_rounded),
              selectedIcon: Icon(Icons.info_rounded),
              label: 'About',
            ),
          ],
        ),
      ),
    );
  }
}
