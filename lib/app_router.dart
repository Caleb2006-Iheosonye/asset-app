/*import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';

import 'screens/pages/home_page.dart';
import 'screens/pages/assets_page.dart';
import 'screens/pages/profile_page.dart';
import 'screens/pages/reports_page.dart';
import 'screens/auth/login_screen.dart';
import 'components/app_shell.dart';
final GoRouter router = GoRouter(
  initialLocation: '/login',
  routes: [
    GoRoute(
      path: '/login',
      builder: (BuildContext context, GoRouterState state) {
        return const LoginScreen();
      },
    ),
   // The shell: wraps the tabs
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) {
        return AppShell(navigationShell: navigationShell);
      },
      branches: [
        // Branch 0
        StatefulShellBranch(
          routes: [
    GoRoute(
      path: '/home_page',
      builder: (context, state) => const HomeScreen(),
    ),

    GoRoute(
      path: '/assets_page',
     builder: (context, state) => const AssetsScreen(),
    ),
    GoRoute(
      path: '/profile_page',
      builder: (context, state) => const ProfileScreen(),
    ),
    GoRoute(
      path: '/reports_page',
      builder: (context, state) => const ReportsScreen(),
      
      
    )
          ]
        )
      ]
    ),
  ],
);
*/