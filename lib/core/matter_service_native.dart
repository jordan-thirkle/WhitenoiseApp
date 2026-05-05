import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final matterServiceProvider = Provider<MatterService>((ref) => MatterService());

/// Represents a Matter Message Header for local orchestration.
class MatterHeader {
  final int messageFlags;
  final int securityFlags;
  final int messageId;

  MatterHeader({
    this.messageFlags = 0x00,
    this.securityFlags = 0x00,
    required this.messageId,
  });

  Uint8List toBytes() {
    final builder = BytesBuilder();
    builder.addByte(messageFlags);
    builder.addByte(securityFlags);
    final mId = ByteData(4)..setUint32(0, messageId, Endian.little);
    builder.add(mId.buffer.asUint8List());
    return builder.toBytes();
  }
}

class MatterService {
  static const int matterPort = 5540;
  RawDatagramSocket? _socket;

  Future<void> init() async {
    _socket = await RawDatagramSocket.bind(InternetAddress.anyIPv6, 0);
    _socket?.listen((event) {
      if (event == RawSocketEvent.read) {
        final datagram = _socket?.receive();
        if (datagram != null) {
          debugPrint('Matter: Received packet from ${datagram.address.address}');
        }
      }
    });
    debugPrint('Matter: Local Orchestration Layer Initialized');
  }

  /// Sends a manual Matter command to a local node (e.g., smart lighting).
  Future<void> sendCommand(InternetAddress address, Uint8List payload) async {
    final header = MatterHeader(
      messageId: DateTime.now().millisecondsSinceEpoch & 0xFFFFFFFF,
    );

    final packet = BytesBuilder();
    packet.add(header.toBytes());
    packet.add(payload);

    _socket?.send(packet.toBytes(), address, matterPort);
  }

  /// Broadcasts a 'Sleep Scene' to local smart lights to create a wellness environment.
  Future<void> broadcastSleepScene() async {
    // Standard Scene recall for local smart-home environment setup
    final payload = BytesBuilder();
    payload.addByte(0x01); // Frame Type: Cluster Specific
    payload.addByte(0x05); // Command ID: RecallScene
    
    final sId = ByteData(2)..setUint16(0, 0x0001, Endian.little);
    payload.add(sId.buffer.asUint8List());

    final multicastAddress = InternetAddress('ff02::1');
    await sendCommand(multicastAddress, payload.toBytes());
    
    debugPrint('Matter: Wellness Environment Scene Triggered');
  }

  void dispose() {
    _socket?.close();
  }
}
