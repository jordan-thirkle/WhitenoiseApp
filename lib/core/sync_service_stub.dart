import 'package:flutter_riverpod/flutter_riverpod.dart';

// Web stub: Sync/pairing features require native FFI (spake2plus + nsd)
// and are not available on web. All calls are no-ops.

final syncServiceProvider = Provider<SyncService>((ref) => SyncService());

class SyncService {
  Future<void> start() async {}
  Future<void> stop() async {}
  Future<void> broadcastMix(String mixJson) async {}
}
