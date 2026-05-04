import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

final healthServiceProvider = Provider((ref) => HealthService(ref));

class HealthService {
  final Ref _ref;
  HealthService(this._ref);

  /// Synchronizes sleep duration with the system health app.
  /// This is a wellness-focused feature to help users track their rest goals.
  Future<void> syncSleepSession(Duration duration) async {
    debugPrint('Wellness: Syncing sleep duration ($duration) to System Health...');
    // In production, this calls health.writeHealthData()
    // focusing exclusively on Sleep Duration (Wellness category).
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
