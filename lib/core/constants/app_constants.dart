import 'package:flutter/material.dart';

class AppConstants {
  static const String appName = 'FitTrack Pro';
  static const String hiveBoxWorkouts = 'workouts_box';
  static const String hiveBoxUser = 'user_box';
  static const String hiveBoxGoals = 'goals_box';
  static const String hiveBoxProgress = 'progress_box';

  static const Color primary = Color(0xFFB7FF3C);
  static const Color secondary = Color(0xFF20E7D2);
  static const Color darkSurface = Color(0xFF0B141A);
  static const Color lightSurface = Color(0xFFF7F8FC);
  static const Color darkCard = Color(0xFF17232C);
  static const Color darkCardAlt = Color(0xFF121B22);

  static const Gradient accentGradient = LinearGradient(
    colors: [Color(0xFFB7FF3C), Color(0xFF20E7D2)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const List<String> workoutTypes = <String>[
    'Running',
    'Walking',
    'Cycling',
    'Gym',
    'Yoga',
    'Swimming',
  ];
}
