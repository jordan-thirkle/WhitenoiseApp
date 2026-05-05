import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:health/health.dart';

final healthServiceProvider = Provider((ref) => HealthService(ref));

class HealthService {
  final Ref _ref;
  final Health _health = Health();
  
  HealthService(this._ref);

  /// Synchronizes sleep duration with the system health app.
  /// This is a wellness-focused feature to help users track their rest goals.
  Future<void> syncSleepSession(Duration duration) async {
    debugPrint('Wellness: Attempting to sync sleep duration ($duration) to System Health...');
    
    final types = [HealthDataType.SLEEP_ASLEEP];
    final permissions = [HealthDataAccess.WRITE];

    try {
      bool hasPermission = await _health.hasPermissions(types, permissions: permissions) ?? false;
      if (!hasPermission) {
        hasPermission = await _health.requestAuthorization(types, permissions: permissions);
      }

      if (hasPermission) {
        final now = DateTime.now();
        final startTime = now.subtract(duration);
        
        bool success = await _health.writeHealthData(
          value: duration.inMinutes.toDouble(),
          type: HealthDataType.SLEEP_ASLEEP,
          startTime: startTime,
          endTime: now,
          unit: HealthDataUnit.MINUTE,
        );

        if (success) {
          debugPrint('Wellness: Sleep session synced successfully.');
        } else {
          debugPrint('Wellness: Failed to write health data.');
        }
      }
    } catch (e) {
      debugPrint('Wellness: Error during health sync: $e');
    }
  }

  /// Deep-links to the system health dashboard so users can manage their rest data.
  Future<void> openHealthDashboard() async {
    final Uri healthUri = Uri.parse('x-apple-health://');
    if (await canLaunchUrl(healthUri)) {
      await launchUrl(healthUri);
    } else {
      debugPrint('Wellness: Unable to launch System Health app.');
    }
  }
}
