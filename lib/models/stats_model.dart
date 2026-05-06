class BiometricStats {
  final double averageHeartRate;
  final Duration totalSleepTime;
  final double efficiency;
  final List<SleepPhasePoint> sleepPhases;
  final bool hasPermissions;
  final bool isLoaded;

  BiometricStats({
    this.averageHeartRate = 0.0,
    this.totalSleepTime = Duration.zero,
    this.efficiency = 0.0,
    this.sleepPhases = const [],
    this.hasPermissions = true,
    this.isLoaded = false,
  });

  BiometricStats copyWith({
    double? averageHeartRate,
    Duration? totalSleepTime,
    double? efficiency,
    List<SleepPhasePoint>? sleepPhases,
    bool? hasPermissions,
    bool? isLoaded,
  }) {
    return BiometricStats(
      averageHeartRate: averageHeartRate ?? this.averageHeartRate,
      totalSleepTime: totalSleepTime ?? this.totalSleepTime,
      efficiency: efficiency ?? this.efficiency,
      sleepPhases: sleepPhases ?? this.sleepPhases,
      hasPermissions: hasPermissions ?? this.hasPermissions,
      isLoaded: isLoaded ?? this.isLoaded,
    );
  }
}

class SleepPhasePoint {
  final DateTime time;
  final double depth; // 0.0 to 1.0 (Deep to Light/Awake)
  final String type;

  SleepPhasePoint({required this.time, required this.depth, required this.type});
}
