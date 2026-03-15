import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/constants/app_constants.dart';
import '../../core/utils/formatters.dart';
import '../../data/models/progress_model.dart';
import '../../data/models/workout_model.dart';
import '../../data/models/workout_type.dart';
import '../providers/goals_provider.dart';
import '../providers/health_provider.dart';
import '../providers/progress_provider.dart';
import '../providers/workouts_provider.dart';
import '../widgets/glass_card.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final goals = ref.watch(goalsProvider);
    final workouts = ref.watch(workoutsProvider);
    final progress = ref.watch(progressProvider);
    final healthAsync = ref.watch(healthProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isDark
              ? const [Color(0xFF0A141A), Color(0xFF0E1B23), Color(0xFF122632)]
              : const [Color(0xFFF6F4FF), Color(0xFFEFF6FF)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 28),
          child: healthAsync.when(
            data: (metrics) {
              final stepsProgress = goals.stepsGoal == 0
                  ? 0.0
                  : (metrics.steps / goals.stepsGoal).clamp(0.0, 1.0);
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _HeaderRow(
                    date: DateTime.now(),
                    title: 'Dashboard',
                  ),
                  const SizedBox(height: 16),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 6,
                        child: _StepsCard(
                          steps: metrics.steps,
                          goal: goals.stepsGoal,
                          progress: stepsProgress,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        flex: 4,
                        child: Column(
                          children: [
                            _MiniStatCard(
                              title: 'Calories Burned',
                              value: '${metrics.calories} kcal',
                              icon: Icons.local_fire_department,
                              iconColor: AppConstants.secondary,
                            ),
                            const SizedBox(height: 12),
                            _MiniStatCard(
                              title: 'Active Time',
                              value: '${metrics.activeMinutes} mins',
                              icon: Icons.timer_outlined,
                              iconColor: AppConstants.primary,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  _WeeklyProgressCard(data: progress),
                  const SizedBox(height: 18),
                  Text(
                    'Recent Activities',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                  ),
                  const SizedBox(height: 12),
                  if (workouts.isEmpty)
                    Text(
                      'No activities yet. Log your first workout.',
                      style: Theme.of(context).textTheme.bodyMedium,
                    )
                  else
                    Column(
                      children: workouts
                          .take(2)
                          .map((workout) => Padding(
                                padding: const EdgeInsets.only(bottom: 12),
                                child: _RecentActivityCard(workout: workout),
                              ))
                          .toList(),
                    ),
                ],
              ).animate().fadeIn(duration: 500.ms).slideY(begin: 0.05);
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (error, stack) => const Center(
              child: Text('Unable to load health data.'),
            ),
          ),
        ),
      ),
    );
  }
}

class _HeaderRow extends StatelessWidget {
  const _HeaderRow({required this.date, required this.title});

  final DateTime date;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppConstants.primary.withValues(alpha: 0.2),
                border: Border.all(
                  color: AppConstants.primary.withValues(alpha: 0.8),
                  width: 1.2,
                ),
              ),
              child: const Icon(Icons.person, color: AppConstants.primary),
            ),
            const SizedBox(width: 12),
            Text(
              title,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
            ),
          ],
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              Formatters.fullDate(date),
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const SizedBox(height: 2),
            Text(
              Formatters.time(date),
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppConstants.primary.withValues(alpha: 0.9),
                    fontWeight: FontWeight.w600,
                  ),
            ),
          ],
        ),
      ],
    );
  }
}

class _StepsCard extends StatelessWidget {
  const _StepsCard({
    required this.steps,
    required this.goal,
    required this.progress,
  });

  final int steps;
  final int goal;
  final double progress;

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Steps Today',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
          ),
          const SizedBox(height: 12),
          Center(
            child: SizedBox(
              height: 130,
              width: 130,
              child: TweenAnimationBuilder<double>(
                tween: Tween<double>(begin: 0, end: progress),
                duration: const Duration(milliseconds: 1200),
                curve: Curves.easeOutCubic,
                builder: (context, value, child) {
                  return Stack(
                    alignment: Alignment.center,
                    children: [
                      SizedBox(
                        height: 120,
                        width: 120,
                        child: ShaderMask(
                          shaderCallback: (rect) {
                            return const SweepGradient(
                              colors: [
                                AppConstants.primary,
                                AppConstants.secondary,
                              ],
                            ).createShader(rect);
                          },
                          child: CircularProgressIndicator(
                            value: value,
                            strokeWidth: 10,
                            backgroundColor:
                                Colors.white.withValues(alpha: 0.08),
                            valueColor:
                                const AlwaysStoppedAnimation(Colors.white),
                          ),
                        ),
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            Formatters.compactInt(steps),
                            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                  fontWeight: FontWeight.w700,
                                ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '/ ${Formatters.compactInt(goal)}',
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ],
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
          const SizedBox(height: 10),
          Text(
            '${Formatters.compactInt(steps)} steps',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: AppConstants.primary,
                  fontWeight: FontWeight.w700,
                ),
          ),
        ],
      ),
    );
  }
}

class _MiniStatCard extends StatelessWidget {
  const _MiniStatCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.iconColor,
  });

  final String title;
  final String value;
  final IconData icon;
  final Color iconColor;

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      padding: const EdgeInsets.all(14),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Colors.white70,
                      ),
                ),
                const SizedBox(height: 6),
                Text(
                  value,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: iconColor,
                      ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: iconColor.withValues(alpha: 0.18),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: iconColor.withValues(alpha: 0.5)),
            ),
            child: Icon(icon, color: iconColor),
          ),
        ],
      ),
    );
  }
}

class _WeeklyProgressCard extends StatelessWidget {
  const _WeeklyProgressCard({required this.data});

  final List<ProgressModel> data;

  @override
  Widget build(BuildContext context) {
    final stepsSpots = data
        .asMap()
        .entries
        .map((entry) => FlSpot(
              entry.key.toDouble(),
              entry.value.steps / 20,
            ))
        .toList();

    final calorieSpots = data
        .asMap()
        .entries
        .map((entry) => FlSpot(
              entry.key.toDouble(),
              entry.value.caloriesBurned.toDouble(),
            ))
        .toList();

    final maxSteps = data.map((e) => e.steps / 20).fold<double>(0, (a, b) => a > b ? a : b);
    final maxCalories = data.map((e) => e.caloriesBurned.toDouble()).fold<double>(0, (a, b) => a > b ? a : b);

    return GlassCard(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Workout Progress (Week)',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              _LegendDot(color: AppConstants.primary, label: 'Workouts'),
              const SizedBox(width: 12),
              _LegendDot(color: AppConstants.secondary, label: 'Steps'),
            ],
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 180,
            child: LineChart(
              LineChartData(
                minX: 0,
                maxX: 6,
                minY: 0,
                maxY: (maxSteps > maxCalories ? maxSteps : maxCalories) + 80,
                gridData: FlGridData(show: false),
                titlesData: FlTitlesData(
                  leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      interval: 1,
                      getTitlesWidget: (value, meta) {
                        const labels = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
                        if (value.toInt() < 0 || value.toInt() >= labels.length) {
                          return const SizedBox.shrink();
                        }
                        return Text(
                          labels[value.toInt()],
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: Colors.white60,
                              ),
                        );
                      },
                    ),
                  ),
                ),
                lineBarsData: [
                  LineChartBarData(
                    spots: calorieSpots,
                    isCurved: true,
                    color: AppConstants.primary,
                    barWidth: 3,
                    dotData: FlDotData(show: true),
                    belowBarData: BarAreaData(
                      show: true,
                      color: AppConstants.primary.withValues(alpha: 0.1),
                    ),
                  ),
                  LineChartBarData(
                    spots: stepsSpots,
                    isCurved: true,
                    color: AppConstants.secondary,
                    barWidth: 3,
                    dotData: FlDotData(show: true),
                    belowBarData: BarAreaData(
                      show: true,
                      color: AppConstants.secondary.withValues(alpha: 0.1),
                    ),
                  ),
                ],
                borderData: FlBorderData(show: false),
              ),
              duration: const Duration(milliseconds: 900),
            ),
          ),
        ],
      ),
    );
  }
}

class _LegendDot extends StatelessWidget {
  const _LegendDot({required this.color, required this.label});

  final Color color;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 6),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Colors.white70,
              ),
        ),
      ],
    );
  }
}

class _RecentActivityCard extends StatelessWidget {
  const _RecentActivityCard({required this.workout});

  final WorkoutModel workout;

  @override
  Widget build(BuildContext context) {
    final info = workoutInfoByLabel(workout.type);

    return GlassCard(
      padding: const EdgeInsets.all(14),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [info.color.withValues(alpha: 0.9), info.color.withValues(alpha: 0.3)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              shape: BoxShape.circle,
            ),
            child: Icon(info.icon, color: Colors.white),
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
                      ),
                ),
                const SizedBox(height: 4),
                Text(
                  Formatters.fullDate(workout.date),
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Colors.white70,
                      ),
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    _ActivityChip(
                      icon: Icons.timer_outlined,
                      label: '${workout.durationMinutes} min',
                    ),
                    const SizedBox(width: 8),
                    _ActivityChip(
                      icon: Icons.local_fire_department,
                      label: '${workout.calories} kcal',
                    ),
                  ],
                ),
              ],
            ),
          ),
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: AppConstants.secondary.withValues(alpha: 0.4),
              ),
              gradient: LinearGradient(
                colors: [
                  AppConstants.secondary.withValues(alpha: 0.12),
                  AppConstants.primary.withValues(alpha: 0.08),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: const Icon(Icons.map_outlined, color: Colors.white70),
          ),
        ],
      ),
    );
  }
}

class _ActivityChip extends StatelessWidget {
  const _ActivityChip({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Icon(icon, size: 14, color: AppConstants.secondary),
          const SizedBox(width: 4),
          Text(
            label,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Colors.white70,
                ),
          ),
        ],
      ),
    );
  }
}
