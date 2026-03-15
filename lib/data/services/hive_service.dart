import 'package:hive_flutter/hive_flutter.dart';

import '../../core/constants/app_constants.dart';
import '../models/goal_model.dart';
import '../models/progress_model.dart';
import '../models/user_model.dart';
import '../models/workout_model.dart';

class HiveService {
  static Future<void> init() async {
    await Hive.initFlutter();

    if (!Hive.isAdapterRegistered(1)) {
      Hive.registerAdapter(WorkoutModelAdapter());
    }
    if (!Hive.isAdapterRegistered(2)) {
      Hive.registerAdapter(UserModelAdapter());
    }
    if (!Hive.isAdapterRegistered(3)) {
      Hive.registerAdapter(GoalModelAdapter());
    }
    if (!Hive.isAdapterRegistered(4)) {
      Hive.registerAdapter(ProgressModelAdapter());
    }

    await Future.wait([
      Hive.openBox<WorkoutModel>(AppConstants.hiveBoxWorkouts),
      Hive.openBox<UserModel>(AppConstants.hiveBoxUser),
      Hive.openBox<GoalModel>(AppConstants.hiveBoxGoals),
      Hive.openBox<ProgressModel>(AppConstants.hiveBoxProgress),
    ]);
  }
}
