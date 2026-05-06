import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:health/health.dart';
import 'package:murmur/core/health_service.dart';
import 'package:murmur/models/stats_model.dart';

final statsControllerProvider = StateNotifierProvider<StatsController, BiometricStats>((ref) {
  return StatsController(ref.read(healthServiceProvider));
});

class StatsController extends StateNotifier<BiometricStats> {
  final HealthService _healthService;

  StatsController(this._healthService) : super(BiometricStats()) {
    refresh();
  }

  Future<void> refresh() async {
    final hasPerm = await _healthService.hasPermissionsCheck();
    if (!hasPerm) {
      state = state.copyWith(hasPermissions: false, isLoaded: true);
      return;
    }

    final data = await _healthService.fetchHealthData();
    if (data.isEmpty) {
      state = state.copyWith(isLoaded: true, hasPermissions: true);
      return;
    }

    // Process Heart Rate
    final hrPoints = data.where((p) => p.type == HealthDataType.HEART_RATE).toList();
    double avgHR = 0;
    if (hrPoints.isNotEmpty) {
      avgHR = hrPoints.map((e) => double.tryParse(e.value.toString()) ?? 0).reduce((a, b) => a + b) / hrPoints.length;
    }

    // Process Sleep
    final sleepPoints = data.where((p) => [
      HealthDataType.SLEEP_ASLEEP,
      HealthDataType.SLEEP_AWAKE,
      HealthDataType.SLEEP_DEEP,
      HealthDataType.SLEEP_REM,
    ].contains(p.type)).toList();

    Duration totalSleep = Duration.zero;
    Duration totalAwake = Duration.zero;
    List<SleepPhasePoint> phases = [];

    for (var point in sleepPoints) {
      final diff = point.dateTo.difference(point.dateFrom);
      
      double depth = 0.5;
      if (point.type == HealthDataType.SLEEP_DEEP) {
        depth = 1.0;
        totalSleep += diff;
      } else if (point.type == HealthDataType.SLEEP_REM) {
        depth = 0.7;
        totalSleep += diff;
      } else if (point.type == HealthDataType.SLEEP_ASLEEP) {
        depth = 0.5;
        totalSleep += diff;
      } else if (point.type == HealthDataType.SLEEP_AWAKE) {
        depth = 0.1;
        totalAwake += diff;
      }

      phases.add(SleepPhasePoint(
        time: point.dateFrom,
        depth: depth,
        type: point.typeString,
      ));
    }

    // Sort phases by time
    phases.sort((a, b) => a.time.compareTo(b.time));

    // Calculate real efficiency: Asleep / (Asleep + Awake)
    final totalTimeInBed = totalSleep + totalAwake;
    final calculatedEfficiency = totalTimeInBed.inSeconds > 0 
        ? totalSleep.inSeconds / totalTimeInBed.inSeconds 
        : 0.0;

    state = BiometricStats(
      averageHeartRate: avgHR,
      totalSleepTime: totalSleep,
      efficiency: calculatedEfficiency,
      sleepPhases: phases,
      hasPermissions: true,
      isLoaded: true,
    );
  }

  Future<void> requestAuthorization() async {
    final success = await _healthService.requestAuthorization();
    if (success) {
      refresh();
    }
  }
}
