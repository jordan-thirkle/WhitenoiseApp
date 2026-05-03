import 'dart:async';
import 'package:flutter_soloud/flutter_soloud.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AudioEngineRepository {
  static final AudioEngineRepository _instance = AudioEngineRepository._internal();
  factory AudioEngineRepository() => _instance;
  AudioEngineRepository._internal();

  final SoLoud _soloud = SoLoud.instance;
  final Map<String, AudioSource> _loadedSources = {};
  final Map<String, SoundHandle> _activeHandles = {};
  
  bool get isInitialized => _soloud.isInitialized;

  Future<void> init() async {
    if (isInitialized) return;
    try {
      await _soloud.init();
      
      // Initialize Master Safety Limiter to prevent clipping during multi-track mixing
      _soloud.filters.limiterFilter.activate();
      _soloud.filters.limiterFilter.threshold.value = -3.0;
      _soloud.filters.limiterFilter.outputCeiling.value = -0.1;
      
      debugPrint('SoLoud Audio Engine Initialized with Master Safety Limiter');
    } catch (e) {
      debugPrint('Failed to initialize SoLoud: $e');
    }
  }

  Future<void> loadSound(String assetPath) async {
    if (_loadedSources.containsKey(assetPath)) return;
    try {
      final source = await _soloud.loadAsset(assetPath);
      
      // Activate Biquad filter on the source level to enable per-handle control
      source.filters.biquadFilter.activate();
      
      _loadedSources[assetPath] = source;
    } catch (e) {
      debugPrint('Error loading sound $assetPath: $e');
    }
  }

  Future<void> playSound(String assetPath, {double volume = 1.0, double tone = 1.0}) async {
    if (!isInitialized) await init();
    
    if (!_loadedSources.containsKey(assetPath)) {
      await loadSound(assetPath);
    }

    final source = _loadedSources[assetPath];
    if (source == null) return;

    stopSound(assetPath);

    try {
      final handle = _soloud.play(source, volume: volume, looping: true);
      _activeHandles[assetPath] = handle;
      _updateTone(source, handle, tone);
    } catch (e) {
      debugPrint('Error playing sound $assetPath: $e');
    }
  }

  void stopSound(String assetPath) {
    final handle = _activeHandles[assetPath];
    if (handle != null) {
      _soloud.stop(handle);
      _activeHandles.remove(assetPath);
    }
  }

  void stopAll() {
    for (final handle in _activeHandles.values) {
      try {
        _soloud.stop(handle);
      } catch (e) {
        debugPrint('Error stopping handle during stopAll: $e');
      }
    }
    _activeHandles.clear();
  }

  void stopAllWithFade(Duration duration) {
    for (final handle in _activeHandles.values) {
      try {
        _soloud.fadeVolume(handle, 0.0, duration);
        _soloud.scheduleStop(handle, duration);
      } catch (e) {
        debugPrint('Error fading handle: $e');
      }
    }
    Timer(duration, () => _activeHandles.clear());
  }

  void updateVolume(String assetPath, double volume) {
    final handle = _activeHandles[assetPath];
    if (handle != null) {
      _soloud.setVolume(handle, volume);
    }
  }

  void updateTone(String assetPath, double tone) {
    final handle = _activeHandles[assetPath];
    final source = _loadedSources[assetPath];
    if (handle != null && source != null) {
      _updateTone(source, handle, tone);
    }
  }

  void _updateTone(AudioSource source, SoundHandle handle, double tone) {
    try {
      // In 4.0.3, use the object-oriented filter API
      source.filters.biquadFilter.type(soundHandle: handle).value = 0; // Low-pass
      
      // Range: 10Hz to 16000Hz
      final frequency = 10.0 + (tone * 15990.0);
      source.filters.biquadFilter.frequency(soundHandle: handle).value = frequency;
      
      // Resonance (standard 0.1 to 20 range)
      source.filters.biquadFilter.resonance(soundHandle: handle).value = 0.1;
    } catch (e) {
      debugPrint('Error updating tone filter: $e');
    }
  }
  
  void dispose() {
    try {
      _soloud.deinit();
    } catch (e) {
      debugPrint('Error during SoLoud shutdown: $e');
    }
  }
}

final audioEngineProvider = Provider((ref) => AudioEngineRepository());
