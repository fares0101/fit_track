import 'package:hive/hive.dart';

import '../../core/constants/app_constants.dart';
import '../models/workout_model.dart';

class WorkoutsRepository {
  Box<WorkoutModel> get _box =>
      Hive.box<WorkoutModel>(AppConstants.hiveBoxWorkouts);

  List<WorkoutModel> getWorkouts() {
    return _box.values.toList()
      ..sort((a, b) => b.date.compareTo(a.date));
  }

  Future<void> addWorkout(WorkoutModel workout) async {
    await _box.put(workout.id, workout);
  }

  Future<void> deleteWorkout(String id) async {
    await _box.delete(id);
  }
}
