import 'package:hive/hive.dart';

import '../../core/constants/app_constants.dart';
import '../models/progress_model.dart';

class ProgressRepository {
  Box<ProgressModel> get _box =>
      Hive.box<ProgressModel>(AppConstants.hiveBoxProgress);

  List<ProgressModel> getProgress() {
    final items = _box.values.toList();
    if (items.isNotEmpty) {
      items.sort((a, b) => a.date.compareTo(b.date));
      return items;
    }

    final now = DateTime.now();
    return List.generate(7, (index) {
      final date = now.subtract(Duration(days: 6 - index));
      return ProgressModel(
        date: date,
        weight: 70 - index * 0.2,
        caloriesBurned: 420 + index * 30,
        activeMinutes: 40 + index * 5,
        steps: 7000 + index * 400,
      );
    });
  }

  Future<void> addProgress(ProgressModel progress) async {
    await _box.add(progress);
  }
}
