import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../data/models/workout_model.dart';
import '../../data/models/workout_type.dart';
import '../../core/constants/app_constants.dart';
import '../providers/workouts_provider.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/section_header.dart';
import '../widgets/workout_card.dart';
import '../widgets/glass_card.dart';

class WorkoutsScreen extends ConsumerWidget {
  const WorkoutsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final workouts = ref.watch(workoutsProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: isDark
                ? const [Color(0xFF0A141A), Color(0xFF0E1B23), Color(0xFF122632)]
                : const [Color(0xFFF9F9FF), Color(0xFFEFF6FF)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const CustomAppBar(
                title: 'Workout Log',
                subtitle: 'Track every session',
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: GlassCard(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _SummaryPill(label: 'Total', value: '${workouts.length}'),
                      _SummaryPill(
                        label: 'This Week',
                        value: '${workouts.where((w) => DateTime.now().difference(w.date).inDays < 7).length}',
                      ),
                      _SummaryPill(
                        label: 'Avg',
                        value: workouts.isEmpty
                            ? '0'
                            : '${(workouts.map((e) => e.durationMinutes).reduce((a, b) => a + b) / workouts.length).round()} min',
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: SectionHeader(
                  title: 'Recent Workouts',
                  action: TextButton.icon(
                    onPressed: () => _openLogSheet(context, ref),
                    icon: const Icon(Icons.add),
                    label: const Text('Log workout'),
                    style: TextButton.styleFrom(
                      foregroundColor: AppConstants.primary,
                      textStyle: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Expanded(
                child: workouts.isEmpty
                    ? Center(
                        child: Text(
                          'No workouts yet. Log your first session.',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      )
                    : ListView.separated(
                        padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
                        itemBuilder: (context, index) {
                          final workout = workouts[index];
                          return WorkoutCard(
                            workout: workout,
                            onDelete: () => ref
                                .read(workoutsProvider.notifier)
                                .deleteWorkout(workout.id),
                          );
                        },
                        separatorBuilder: (_, __) => const SizedBox(height: 12),
                        itemCount: workouts.length,
                      ).animate().fadeIn(duration: 500.ms).slideY(begin: 0.1),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _openLogSheet(context, ref),
        icon: const Icon(Icons.add),
        label: const Text('Add Workout'),
        backgroundColor: AppConstants.primary,
      ),
    );
  }

  Future<void> _openLogSheet(BuildContext context, WidgetRef ref) async {
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _WorkoutLogSheet(
        onSave: (workout) => ref.read(workoutsProvider.notifier).addWorkout(workout),
      ),
    );
  }
}

class _SummaryPill extends StatelessWidget {
  const _SummaryPill({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final glow = AppConstants.primary.withValues(alpha: 0.6);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          value,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
                color: isDark ? AppConstants.primary : null,
                shadows: isDark
                    ? [
                        Shadow(
                          color: glow,
                          blurRadius: 14,
                        ),
                      ]
                    : null,
              ),
        ),
        const SizedBox(height: 4),
        Text(label, style: Theme.of(context).textTheme.bodySmall),
      ],
    );
  }
}

class _WorkoutLogSheet extends StatefulWidget {
  const _WorkoutLogSheet({required this.onSave});

  final ValueChanged<WorkoutModel> onSave;

  @override
  State<_WorkoutLogSheet> createState() => _WorkoutLogSheetState();
}

class _WorkoutLogSheetState extends State<_WorkoutLogSheet> {
  final _formKey = GlobalKey<FormState>();
  final _durationController = TextEditingController();
  final _caloriesController = TextEditingController();
  final _notesController = TextEditingController();

  String _selectedType = workoutTypeOptions.first.label;

  @override
  void dispose() {
    _durationController.dispose();
    _caloriesController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return Padding(
      padding: EdgeInsets.only(bottom: bottomInset),
      child: GlassCard(
        borderRadius: 28,
        padding: const EdgeInsets.fromLTRB(20, 24, 20, 16),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Log Workout',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                initialValue: _selectedType,
                decoration: const InputDecoration(labelText: 'Workout Type'),
                items: workoutTypeOptions
                    .map((type) => DropdownMenuItem(
                          value: type.label,
                          child: Text(type.label),
                        ))
                    .toList(),
                onChanged: (value) => setState(() => _selectedType = value ?? _selectedType),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _durationController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Duration (minutes)'),
                validator: (value) => value == null || value.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _caloriesController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Calories burned'),
                validator: (value) => value == null || value.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _notesController,
                decoration: const InputDecoration(labelText: 'Notes'),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: () {
                    if (!_formKey.currentState!.validate()) return;
                    final workout = WorkoutModel(
                      id: DateTime.now().millisecondsSinceEpoch.toString(),
                      type: _selectedType,
                      durationMinutes: int.parse(_durationController.text),
                      calories: int.parse(_caloriesController.text),
                      date: DateTime.now(),
                      notes: _notesController.text,
                    );
                    widget.onSave(workout);
                    Navigator.of(context).pop();
                  },
                  child: const Text('Save workout'),
                ),
              ),
            ],
          ),
        ),
      ),
    ).animate().fadeIn(duration: 400.ms).slideY(begin: 0.2);
  }
}
