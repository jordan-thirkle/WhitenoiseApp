import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final syncServiceProvider = Provider<SyncService>((ref) => SyncService());

class SyncService {
  final _messageController = StreamController<String>.broadcast();
  Stream<String> get messages => _messageController.stream;

  Future<void> start() async {
    debugPrint('Sync Service: Web Mock Initialized (Local networking disabled)');
  }

  Future<void> broadcastMix(String mixJson) async {
    debugPrint('Sync Service: Web Mock - Simulation Broadcast Mix: $mixJson');
  }

  Future<void> stop() async {}
}
