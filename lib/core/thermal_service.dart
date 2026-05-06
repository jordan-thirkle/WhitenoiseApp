import 'dart:async';
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'audio_engine_repository.dart';

enum ThermalState {
  optimal,
  fair,
  serious,
  critical,
}

final thermalServiceProvider = StateNotifierProvider<ThermalService, ThermalState>((ref) {
  final repository = ref.watch(audioEngineProvider);
  return ThermalService(repository);
});

class ThermalService extends StateNotifier<ThermalState> {
  static const MethodChannel _channel = MethodChannel('com.jordanthirkle.murmur/thermal');
  final AudioEngineRepository _repository;
  Timer? _timer;

  ThermalService(this._repository) : super(ThermalState.optimal) {
    _startMonitoring();
  }

  void _startMonitoring() {
    // Check every 30 seconds to minimize CPU impact (Premium Utility constraint)
    _timer = Timer.periodic(const Duration(seconds: 30), (_) => _checkThermalState());
    _checkThermalState();
  }

  Future<void> _checkThermalState() async {
    if (kIsWeb) {
      // Simulation for Web Demo: Randomly oscillate between Optimal and Fair
      state = (DateTime.now().second % 60 > 45) ? ThermalState.fair : ThermalState.optimal;
      return;
    }
    
    try {
      final int? result = await _channel.invokeMethod<int>('getThermalState');
      if (result != null) {
        final newState = _mapIntToState(result);
        if (newState != state) {
          state = newState;
          _handleStateChange(newState);
        }
      }
    } on PlatformException catch (_) {
      state = ThermalState.optimal;
    }
  }

  void _handleStateChange(ThermalState newState) {
    if (newState == ThermalState.critical) {
      debugPrint('THERMAL CRITICAL: Emergency Audio Cutoff triggered.');
      _repository.stopAll();
    }
  }

  ThermalState _mapIntToState(int value) {
    switch (value) {
      case 0: return ThermalState.optimal;
      case 1: return ThermalState.fair;
      case 2: return ThermalState.serious;
      case 3: return ThermalState.critical;
      default: return ThermalState.optimal;
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
