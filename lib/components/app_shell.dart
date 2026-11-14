
import 'package:flutter/material.dart';
import 'package:asset_app/screens/pages/home_page.dart';
import 'package:asset_app/screens/pages/assets_page.dart';
import 'package:asset_app/screens/pages/reports_page.dart';
import 'package:asset_app/screens/pages/profile_page.dart';
import 'app_bottom_bar.dart';

class AppShell extends StatefulWidget {
  const AppShell({super.key, this.initialIndex = 0});

  final int initialIndex; // which tab to open on

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  late int currentIndex; // the one place that remembers the active tab

  @override
  void initState() {
    super.initState();
    currentIndex = widget.initialIndex; // `widget` is only available here
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Scaffold(
      // IndexedStack keeps all four pages alive, so tabs keep their state.
      body: IndexedStack(
        index: currentIndex,
        children: const [
          HomeScreen(),    // 0
          AssetsScreen(),  // 1
          ReportsScreen(), // 2
          ProfileScreen(), // 3
        ],
      ),
      bottomNavigationBar: AppBottomBar(
        currentIndex: currentIndex,
        onTabSelected: (index) => setState(() => currentIndex = index),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // T  onPressed: () {
        // Navigate to the add asset page
       // context.go('/add-asset');
        Navigator.pushNamed(context, '/add_asset');
      },
      
        backgroundColor: colors.primary,
        foregroundColor: colors.onPrimary,
        shape: const CircleBorder(),
        child: const Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}