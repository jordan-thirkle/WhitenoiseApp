import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nsd/nsd.dart';
import 'package:cryptography/cryptography.dart';
import 'pairing_service.dart';

final syncServiceProvider = Provider<SyncService>((ref) => SyncService());

class SyncService {
  static const String serviceType = '_murmur-sync._tcp';
  final String deviceName = Platform.localHostname;
  final PairingService _pairingService = PairingService();
  
  Registration? _registration;
  Discovery? _discovery;
  
  final _messageController = StreamController<String>.broadcast();
  Stream<String> get messages => _messageController.stream;

  Future<void> start() async {
    // 1. Register this device on the local network
    _registration = await register(Service(
      name: 'Murmur-$deviceName',
      type: serviceType,
      port: 5555,
    ));
    
    // 2. Start discovery for other Murmur devices
    _discovery = await startDiscovery(serviceType);
    _discovery?.addServiceListener((service, status) {
      if (status == ServiceStatus.found) {
        debugPrint('Found Murmur device: ${service.name}');
        _connectToPeer(service);
      }
    });

    // 3. Start local TCP server to receive sync data
    final server = await ServerSocket.bind(InternetAddress.anyIPv4, 5555);
    server.listen(_handleConnection);
    
    debugPrint('Sync Service started on port 5555 as Murmur-$deviceName');
  }

  void _handleConnection(Socket client) {
    client.listen((data) {
      final message = utf8.decode(data);
      _messageController.add(message);
      debugPrint('Received sync data: $message');
    });
  }

  Future<void> _connectToPeer(Service service) async {
    // 2026 Zero-Knowledge P2P Foundation
    // Initiate SPAKE2+ PASE handshake with discovered peer
    final sessionKey = await _pairingService.establishSecureSession(
      passcode: 'murmur-2026', // Standard local-first default
      salt: service.name ?? 'default-salt',
      iterations: 1000,
    );

    if (sessionKey != null) {
      debugPrint('Secure Session Established with ${service.name}');
      // Proceed to encrypted TCP sync...
    }
  }

  Future<void> broadcastMix(String mixJson) async {
    // Broadcast updated mix to all discovered peers
  }

  Future<void> stop() async {
    if (_registration != null) {
      await unregister(_registration!);
    }
    if (_discovery != null) {
      await stopDiscovery(_discovery!);
    }
  }
}
