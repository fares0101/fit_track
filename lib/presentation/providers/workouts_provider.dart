import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/models/workout_model.dart';
import '../../data/repositories/workouts_repository.dart';

final workoutsRepositoryProvider = Provider<WorkoutsRepository>(
  (ref) => WorkoutsRepository(),
);

class WorkoutsNotifier extends StateNotifier<List<WorkoutModel>> {
  WorkoutsNotifier(this._repository) : super(const []) {
    load();
  }

  final WorkoutsRepository _repository;

  void load() {
    state = _repository.getWorkouts();
  }

  Future<void> addWorkout(WorkoutModel workout) async {
    await _repository.addWorkout(workout);
    load();
  }

  Future<void> deleteWorkout(String id) async {
    await _repository.deleteWorkout(id);
    load();
  }
}

final workoutsProvider =
    StateNotifierProvider<WorkoutsNotifier, List<WorkoutModel>>(
  (ref) => WorkoutsNotifier(ref.watch(workoutsRepositoryProvider)),
);
