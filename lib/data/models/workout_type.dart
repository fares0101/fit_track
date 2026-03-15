import 'package:flutter/material.dart';

class WorkoutTypeInfo {
  final String label;
  final IconData icon;
  final Color color;

  const WorkoutTypeInfo(this.label, this.icon, this.color);
}

const workoutTypeOptions = <WorkoutTypeInfo>[
  WorkoutTypeInfo('Running', Icons.directions_run, Color(0xFF6C63FF)),
  WorkoutTypeInfo('Walking', Icons.directions_walk, Color(0xFF22C55E)),
  WorkoutTypeInfo('Cycling', Icons.pedal_bike, Color(0xFF38BDF8)),
  WorkoutTypeInfo('Gym', Icons.fitness_center, Color(0xFFF59E0B)),
  WorkoutTypeInfo('Yoga', Icons.self_improvement, Color(0xFFEC4899)),
  WorkoutTypeInfo('Swimming', Icons.pool, Color(0xFF06B6D4)),
];

WorkoutTypeInfo workoutInfoByLabel(String label) {
  return workoutTypeOptions.firstWhere(
    (item) => item.label == label,
    orElse: () => workoutTypeOptions.first,
  );
}
