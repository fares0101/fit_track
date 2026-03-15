import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/services/health_service.dart';

final healthServiceProvider = Provider<HealthService>(
  (ref) => HealthService(),
);

class HealthNotifier extends StateNotifier<AsyncValue<HealthMetrics>> {
  HealthNotifier(this._service) : super(const AsyncValue.loading()) {
    load();
  }

  final HealthService _service;

  Future<void> load() async {
    state = const AsyncValue.loading();
    final authorized = await _service.requestPermissions();
    if (!authorized) {
      state = const AsyncValue.data(
        HealthMetrics(
          steps: 0,
          calories: 0,
          activeMinutes: 0,
          distanceKm: 0,
          heartRate: 0,
        ),
      );
      return;
    }

    final metrics = await _service.fetchTodayMetrics();
    state = AsyncValue.data(metrics);
  }
}

final healthProvider =
    StateNotifierProvider<HealthNotifier, AsyncValue<HealthMetrics>>(
  (ref) => HealthNotifier(ref.watch(healthServiceProvider)),
);
