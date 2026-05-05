import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nsd/nsd.dart';
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
    _registration = await register(Service(
      name: 'Murmur-$deviceName',
      type: serviceType,
      port: 5555,
    ));
    
    _discovery = await startDiscovery(serviceType);
    _discovery?.addServiceListener((service, status) {
      if (status == ServiceStatus.found) {
        debugPrint('Found Murmur device: ${service.name}');
        _connectToPeer(service);
      }
    });

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
    final sessionKey = await _pairingService.establishSecureSession(
      passcode: 'murmur-2026',
      salt: service.name ?? 'default-salt',
      iterations: 1000,
    );

    if (sessionKey != null) {
      debugPrint('Secure Session Established with ${service.name}');
    }
  }

  Future<void> broadcastMix(String mixJson) async {}

  Future<void> stop() async {
    if (_registration != null) {
      await unregister(_registration!);
    }
    if (_discovery != null) {
      await stopDiscovery(_discovery!);
    }
  }
}
