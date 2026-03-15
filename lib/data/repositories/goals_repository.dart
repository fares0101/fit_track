import 'package:hive/hive.dart';

import '../../core/constants/app_constants.dart';
import '../models/goal_model.dart';

class GoalsRepository {
  Box<GoalModel> get _box => Hive.box<GoalModel>(AppConstants.hiveBoxGoals);

  GoalModel getGoals() {
    return _box.get('goals') ??
        const GoalModel(stepsGoal: 10000, caloriesGoal: 600, workoutsGoal: 1);
  }

  Future<void> saveGoals(GoalModel goals) async {
    await _box.put('goals', goals);
  }
}
