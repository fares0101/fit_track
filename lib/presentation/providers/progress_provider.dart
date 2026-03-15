import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/models/progress_model.dart';
import '../../data/repositories/progress_repository.dart';

final progressRepositoryProvider = Provider<ProgressRepository>(
  (ref) => ProgressRepository(),
);

final progressProvider = Provider<List<ProgressModel>>(
  (ref) => ref.watch(progressRepositoryProvider).getProgress(),
);
