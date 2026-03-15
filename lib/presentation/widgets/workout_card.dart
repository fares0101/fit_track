import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../data/models/workout_model.dart';
import '../../data/models/workout_type.dart';
import '../../core/utils/formatters.dart';
import 'glass_card.dart';

class WorkoutCard extends StatelessWidget {
  const WorkoutCard({
    super.key,
    required this.workout,
    this.onDelete,
  });

  final WorkoutModel workout;
  final VoidCallback? onDelete;

  @override
  Widget build(BuildContext context) {
    final info = workoutInfoByLabel(workout.type);
    final glow = info.color.withValues(alpha: 0.6);

    return GlassCard(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: info.color.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: glow,
                  blurRadius: 18,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Icon(info.icon, color: info.color),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  workout.type,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        shadows: [
                          Shadow(
                            color: glow,
                            blurRadius: 12,
                          ),
                        ],
                      ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${workout.durationMinutes} min · ${workout.calories} kcal',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                const SizedBox(height: 6),
                Text(
                  Formatters.fullDate(workout.date),
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).textTheme.bodySmall?.color,
                      ),
                ),
              ],
            ),
          ),
          if (onDelete != null)
            IconButton(
              icon: const Icon(Icons.delete_outline),
              onPressed: onDelete,
            ),
        ],
      ).animate().fadeIn(duration: 500.ms).slideX(begin: 0.2),
    );
  }
}
