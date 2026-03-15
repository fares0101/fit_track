import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/models/goal_model.dart';
import '../../data/repositories/goals_repository.dart';

final goalsRepositoryProvider = Provider<GoalsRepository>(
  (ref) => GoalsRepository(),
);

class GoalsNotifier extends StateNotifier<GoalModel> {
  GoalsNotifier(this._repository) : super(const GoalModel(stepsGoal: 0, caloriesGoal: 0, workoutsGoal: 0)) {
    load();
  }

  final GoalsRepository _repository;

  void load() {
    state = _repository.getGoals();
  }

  Future<void> updateGoals(GoalModel goals) async {
    await _repository.saveGoals(goals);
    load();
  }
}

final goalsProvider = StateNotifierProvider<GoalsNotifier, GoalModel>(
  (ref) => GoalsNotifier(ref.watch(goalsRepositoryProvider)),
);
