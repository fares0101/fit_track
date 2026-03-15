import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../screens/dashboard_screen.dart';
import '../screens/main_shell.dart';
import '../screens/profile_screen.dart';
import '../screens/progress_screen.dart';
import '../screens/workouts_screen.dart';

final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/',
    routes: [
      ShellRoute(
        builder: (context, state, child) => MainShell(child: child),
        routes: [
          GoRoute(
            path: '/',
            pageBuilder: (context, state) => _buildTransitionPage(
              state.pageKey,
              const DashboardScreen(),
            ),
          ),
          GoRoute(
            path: '/workouts',
            pageBuilder: (context, state) => _buildTransitionPage(
              state.pageKey,
              const WorkoutsScreen(),
            ),
          ),
          GoRoute(
            path: '/progress',
            pageBuilder: (context, state) => _buildTransitionPage(
              state.pageKey,
              const ProgressScreen(),
            ),
          ),
          GoRoute(
            path: '/profile',
            pageBuilder: (context, state) => _buildTransitionPage(
              state.pageKey,
              const ProfileScreen(),
            ),
          ),
        ],
      ),
    ],
  );
});

CustomTransitionPage<void> _buildTransitionPage(LocalKey key, Widget child) {
  return CustomTransitionPage<void>(
    key: key,
    child: child,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      return FadeThroughTransition(
        animation: animation,
        secondaryAnimation: secondaryAnimation,
        child: child,
      );
    },
  );
}
