import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:in_app_update/in_app_update.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PlayServicesHelper {
  static final InAppReview _inAppReview = InAppReview.instance;

  /// Checks for and triggers an in-app update on Android.
  static Future<void> checkForUpdates() async {
    if (kIsWeb || !Platform.isAndroid) return;

    try {
      final updateInfo = await InAppUpdate.checkForUpdate();
      if (updateInfo.updateAvailability == UpdateAvailability.updateAvailable) {
        if (updateInfo.immediateUpdateAllowed) {
          await InAppUpdate.performImmediateUpdate();
        } else if (updateInfo.flexibleUpdateAllowed) {
          await InAppUpdate.startFlexibleUpdate();
          await InAppUpdate.completeFlexibleUpdate();
        }
      }
    } catch (e) {
      debugPrint('PlayServices: Update check failed: $e');
    }
  }

  /// Triggers an in-app review if certain usage conditions are met.
  /// Premium Utility Rule: Don't annoy the user. Only ask after 5 sessions.
  static Future<void> requestReviewIfAppropriate() async {
    if (kIsWeb) return;

    try {
      final prefs = await SharedPreferences.getInstance();
      final sessions = prefs.getInt('completed_sleep_sessions') ?? 0;
      final lastReviewVersion = prefs.getString('last_review_version') ?? '';
      
      // Get current version from some source or hardcode for now
      const currentVersion = '1.1.0'; 

      if (sessions >= 5 && lastReviewVersion != currentVersion) {
        if (await _inAppReview.isAvailable()) {
          await _inAppReview.requestReview();
          await prefs.setString('last_review_version', currentVersion);
        }
      }
    } catch (e) {
      debugPrint('PlayServices: Review request failed: $e');
    }
  }

  /// Verifies device integrity before sensitive operations (like P2P Sync).
  /// Note: Real implementation requires play_integrity plugin and backend verification.
  static Future<bool> verifyDeviceIntegrity() async {
    if (kIsWeb) return true;
    if (!Platform.isAndroid) return true;

    try {
      debugPrint('PlayServices: Verifying device integrity...');
      // In a real production app, we would request a token here:
      // final token = await PlayIntegrity.requestIntegrityToken(nonce: ...);
      // And verify it against our backend.
      return true; // Simulation for now
    } catch (e) {
      debugPrint('PlayServices: Integrity check failed: $e');
      return false;
    }
  }

  /// Increments the session counter for review logic.
  static Future<void> incrementSessionCount() async {
    final prefs = await SharedPreferences.getInstance();
    final sessions = prefs.getInt('completed_sleep_sessions') ?? 0;
    await prefs.setInt('completed_sleep_sessions', sessions + 1);
  }
}
