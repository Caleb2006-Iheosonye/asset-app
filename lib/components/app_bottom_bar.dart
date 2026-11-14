import 'package:flutter/material.dart';
import 'package:asset_app/components/bottom_bar_item.dart';
class AppBottomBar extends StatelessWidget {
  const AppBottomBar({
    super.key,
    required this.currentIndex,
    required this.onTabSelected,
    
  });

  final int currentIndex;
  final ValueChanged<int> onTabSelected;
  
  @override
  Widget build(BuildContext context) {
      final colors = Theme.of(context).colorScheme;
      surfaceTintColor: Colors.transparent;
    return BottomAppBar(
      shape: const CircularNotchedRectangle(),
      notchMargin: 6.0,
      color: colors.surface,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
         Expanded(child: BottomBarItem(
            icon: Icons.home_outlined,
            label: 'Home',
            isSelected: currentIndex == 0,
            onTap: () => onTabSelected(0),
          )),
           Expanded(child: BottomBarItem(
            icon: Icons.grid_view_outlined,
            label: 'Assets',
            isSelected: currentIndex == 1,
            onTap: () => onTabSelected(1),
          )),
          const SizedBox(width: 48), // Space for the floating action button
            Expanded(child: BottomBarItem(
            icon: Icons.pie_chart_outline,
            label: 'Reports',
            isSelected: currentIndex == 2,
            onTap: () => onTabSelected(2),
          )),
             Expanded(child: BottomBarItem(
            icon: Icons.person_outline,
            label: 'Profile',
            isSelected: currentIndex == 3,
            onTap: () => onTabSelected(3),
          )),
        ],
      ),
    );
  }
}