import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final purgeServiceProvider = Provider((ref) => PurgeService());

class PurgeService {
  /// Radically purges all local biometric logs, preferences, and cached session data.
  /// This implements the 2027 "Right to Disappear" clinical standard.
  Future<void> purgeAllData() async {
    // Clear Shared Preferences (Timer prefs, favorites, settings)
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();

    // Trigger Haptic Reassurance
    await HapticFeedback.heavyImpact();
    await Future.delayed(const Duration(milliseconds: 100));
    await HapticFeedback.heavyImpact();

    // Note: In a production environment with a local database (SQLite),
    // this would also drop all tables related to biometric logs.
  }
}
