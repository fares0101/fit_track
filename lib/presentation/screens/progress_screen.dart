import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/constants/app_constants.dart';
import '../../data/models/progress_model.dart';
import '../providers/progress_provider.dart';
import '../widgets/chart_card.dart';
import '../widgets/custom_app_bar.dart';

class ProgressScreen extends ConsumerWidget {
  const ProgressScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final data = ref.watch(progressProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: isDark
                ? const [Color(0xFF0D1016), Color(0xFF1B2130)]
                : const [Color(0xFFF8FAFF), Color(0xFFF0F4FF)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const CustomAppBar(
                  title: 'Progress',
                  subtitle: 'Visualize your journey',
                ),
                ChartCard(
                  title: 'Weekly Workouts',
                  child: _WeeklyWorkoutsChart(data: data),
                ),
                const SizedBox(height: 16),
                ChartCard(
                  title: 'Calories Burned',
                  child: _CaloriesChart(data: data),
                ),
                const SizedBox(height: 16),
                ChartCard(
                  title: 'Weight Progress',
                  child: _WeightChart(data: data),
                ),
                const SizedBox(height: 16),
                ChartCard(
                  title: 'Active Minutes',
                  child: _ActiveMinutesChart(data: data),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _WeeklyWorkoutsChart extends StatelessWidget {
  const _WeeklyWorkoutsChart({required this.data});

  final List<ProgressModel> data;

  @override
  Widget build(BuildContext context) {
    final barGroups = data.asMap().entries.map((entry) {
      final index = entry.key.toDouble();
      final workouts = (entry.value.activeMinutes / 20).round().clamp(0, 6);
      return BarChartGroupData(
        x: index.toInt(),
        barRods: [
          BarChartRodData(
            toY: workouts.toDouble(),
            color: AppConstants.primary,
            borderRadius: BorderRadius.circular(6),
            width: 14,
          ),
        ],
      );
    }).toList();

    return BarChart(
      BarChartData(
        barGroups: barGroups,
        gridData: FlGridData(show: false),
        titlesData: FlTitlesData(
          leftTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          rightTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          topTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) {
                const labels = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];
                if (value.toInt() < 0 || value.toInt() >= labels.length) {
                  return const SizedBox.shrink();
                }
                return Text(labels[value.toInt()]);
              },
            ),
          ),
        ),
        borderData: FlBorderData(show: false),
      ),
    );
  }
}

class _CaloriesChart extends StatelessWidget {
  const _CaloriesChart({required this.data});

  final List<ProgressModel> data;

  @override
  Widget build(BuildContext context) {
    final spots = data
        .asMap()
        .entries
        .map(
          (entry) => FlSpot(
            entry.key.toDouble(),
            entry.value.caloriesBurned.toDouble(),
          ),
        )
        .toList();

    return LineChart(
      LineChartData(
        gridData: FlGridData(show: false),
        titlesData: FlTitlesData(
          leftTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          rightTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          topTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              interval: 1,
              getTitlesWidget: (value, meta) {
                const labels = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];
                if (value.toInt() < 0 || value.toInt() >= labels.length) {
                  return const SizedBox.shrink();
                }
                return Text(labels[value.toInt()]);
              },
            ),
          ),
        ),
        lineBarsData: [
          LineChartBarData(
            spots: spots,
            isCurved: true,
            color: const Color(0xFFFF8A00),
            barWidth: 3,
            belowBarData: BarAreaData(
              show: true,
              color: const Color(0xFFFF8A00).withValues(alpha: 0.2),
            ),
            dotData: FlDotData(show: false),
          ),
        ],
        borderData: FlBorderData(show: false),
      ),
    );
  }
}

class _WeightChart extends StatelessWidget {
  const _WeightChart({required this.data});

  final List<ProgressModel> data;

  @override
  Widget build(BuildContext context) {
    final spots = data
        .asMap()
        .entries
        .map((entry) => FlSpot(entry.key.toDouble(), entry.value.weight))
        .toList();

    return LineChart(
      LineChartData(
        gridData: FlGridData(show: false),
        titlesData: FlTitlesData(
          leftTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          rightTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          topTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              interval: 1,
              getTitlesWidget: (value, meta) {
                const labels = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];
                if (value.toInt() < 0 || value.toInt() >= labels.length) {
                  return const SizedBox.shrink();
                }
                return Text(labels[value.toInt()]);
              },
            ),
          ),
        ),
        lineBarsData: [
          LineChartBarData(
            spots: spots,
            isCurved: true,
            color: const Color(0xFF22C55E),
            barWidth: 3,
            belowBarData: BarAreaData(
              show: true,
              color: const Color(0xFF22C55E).withValues(alpha: 0.2),
            ),
            dotData: FlDotData(show: false),
          ),
        ],
        borderData: FlBorderData(show: false),
      ),
    );
  }
}

class _ActiveMinutesChart extends StatelessWidget {
  const _ActiveMinutesChart({required this.data});

  final List<ProgressModel> data;

  @override
  Widget build(BuildContext context) {
    final barGroups = data.asMap().entries.map((entry) {
      final index = entry.key.toDouble();
      return BarChartGroupData(
        x: index.toInt(),
        barRods: [
          BarChartRodData(
            toY: entry.value.activeMinutes.toDouble(),
            color: const Color(0xFF38BDF8),
            borderRadius: BorderRadius.circular(6),
            width: 14,
          ),
        ],
      );
    }).toList();

    return BarChart(
      BarChartData(
        barGroups: barGroups,
        gridData: FlGridData(show: false),
        titlesData: FlTitlesData(
          leftTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          rightTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          topTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) {
                const labels = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];
                if (value.toInt() < 0 || value.toInt() >= labels.length) {
                  return const SizedBox.shrink();
                }
                return Text(labels[value.toInt()]);
              },
            ),
          ),
        ),
        borderData: FlBorderData(show: false),
      ),
    );
  }
}
