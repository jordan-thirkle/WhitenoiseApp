import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:health/health.dart';

final healthServiceProvider = Provider((ref) => HealthService());

class HealthService {
  final Health _health = Health();
  
  HealthService();

  List<HealthDataType> get _types => [
    HealthDataType.HEART_RATE,
    HealthDataType.SLEEP_ASLEEP,
    HealthDataType.SLEEP_AWAKE,
    HealthDataType.SLEEP_DEEP,
    HealthDataType.SLEEP_REM,
  ];

  List<HealthDataAccess> get _permissions => _types.map((e) => HealthDataAccess.READ).toList();

  Future<bool> hasPermissionsCheck() async {
    try {
      return await _health.hasPermissions(_types, permissions: _permissions) ?? false;
    } catch (e) {
      debugPrint('Wellness: Error checking permissions: $e');
      return false;
    }
  }

  Future<bool> requestAuthorization() async {
    try {
      return await _health.requestAuthorization(_types, permissions: _permissions);
    } catch (e) {
      debugPrint('Wellness: Error requesting authorization: $e');
      return false;
    }
  }

  /// Fetches biometric data for the last 7 days.
  Future<List<HealthDataPoint>> fetchHealthData() async {
    final now = DateTime.now();
    final yesterday = now.subtract(const Duration(days: 7));
    
    final types = [
      HealthDataType.HEART_RATE,
      HealthDataType.SLEEP_ASLEEP,
      HealthDataType.SLEEP_AWAKE,
      HealthDataType.SLEEP_DEEP,
      HealthDataType.SLEEP_REM,
    ];

    final permissions = types.map((e) => HealthDataAccess.READ).toList();

    try {
      bool hasPermission = await _health.hasPermissions(types, permissions: permissions) ?? false;
      if (!hasPermission) {
        hasPermission = await _health.requestAuthorization(types, permissions: permissions);
      }

      if (hasPermission) {
        return await _health.getHealthDataFromTypes(
          startTime: yesterday,
          endTime: now,
          types: types,
        );
      }
    } catch (e) {
      debugPrint('Wellness: Error fetching health data: $e');
    }
    return [];
  }

  /// Synchronizes sleep duration with the system health app.
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
    if (kIsWeb) return;

    final Uri healthUri = Uri.parse('x-apple-health://');
    try {
      if (await canLaunchUrl(healthUri)) {
        await launchUrl(healthUri);
      } else {
        // Only log if it's actually a supported platform where we expect it to work (iOS)
        if (defaultTargetPlatform == TargetPlatform.iOS) {
          debugPrint('Wellness: Unable to launch System Health app.');
        }
      }
    } catch (e) {
      debugPrint('Wellness: Error launching health dashboard: $e');
    }
  }
}
