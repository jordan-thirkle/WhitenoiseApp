import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final matterServiceProvider = Provider<MatterService>((ref) => MatterService());

class MatterHeader {
  final int messageFlags;
  final int securityFlags;
  final int messageId;

  MatterHeader({
    this.messageFlags = 0x00,
    this.securityFlags = 0x00,
    required this.messageId,
  });

  Uint8List toBytes() => Uint8List(0);
}

class MatterService {
  Future<void> init() async {
    debugPrint('Matter: Web Mock Initialized (Native networking disabled)');
  }

  Future<void> broadcastSleepScene() async {
    debugPrint('Matter: Web Mock - Simulation Sleep Scene Triggered');
  }

  void dispose() {}
}
