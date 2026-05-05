import 'dart:async';
import 'dart:math' as math;
import 'package:flutter_soloud/flutter_soloud.dart';
import 'package:flutter/foundation.dart';
import '../main.dart';

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
      _soloud.filters.limiterFilter.activate();
      _soloud.filters.limiterFilter.threshold.value = -3.0;
      _soloud.filters.limiterFilter.outputCeiling.value = -0.1;
      debugPrint('SoLoud Audio Engine Initialized (Native)');
    } catch (e) {
      debugPrint('Failed to initialize SoLoud: $e');
    }
  }

  Future<void> loadSound(String assetPath) async {
    if (_loadedSources.containsKey(assetPath)) return;
    try {
      final source = await _soloud.loadAsset(assetPath);
      _loadedSources[assetPath] = source;
    } catch (e) {
      debugPrint('Error loading sound $assetPath: $e');
    }
  }

  void playSound(String assetPath, {double volume = 0.5, double tone = 1.0}) {
    if (!isInitialized) return;
    final source = _loadedSources[assetPath];
    if (source == null) return;

    try {
      final handle = _soloud.play(source, volume: volume, looping: true);
      _activeHandles[assetPath] = handle;
      _updateTone(source, handle, tone);
      audioHandler.play();
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
    if (_activeHandles.isEmpty) audioHandler.stop();
  }

  void stopAll() {
    for (final handle in _activeHandles.values) {
      _soloud.stop(handle);
    }
    _activeHandles.clear();
    audioHandler.stop();
  }

  void stopAllWithFade(Duration duration) {
    for (final handle in _activeHandles.values) {
      _soloud.fadeVolume(handle, 0.0, duration);
      _soloud.scheduleStop(handle, duration);
    }
    Timer(duration, () => _activeHandles.clear());
  }

  void updateVolume(String assetPath, double volume) {
    final handle = _activeHandles[assetPath];
    if (handle != null) _soloud.setVolume(handle, volume);
  }

  void updateTone(String assetPath, double toneFactor) {
    final source = _loadedSources[assetPath];
    final handle = _activeHandles[assetPath];
    if (source != null && handle != null) _updateTone(source, handle, toneFactor);
  }

  void _updateTone(AudioSource source, SoundHandle handle, double toneFactor) {
    try {
      final double minFreq = 400.0;
      final double maxFreq = 16000.0;
      final double freq = minFreq * math.pow(maxFreq / minFreq, toneFactor);
      source.filters.biquadFilter.activate();
      source.filters.biquadFilter.frequency(soundHandle: handle).value = freq;
      source.filters.biquadFilter.type(soundHandle: handle).value = 0.0;
    } catch (e) {
      debugPrint('Error updating tone DSP: $e');
    }
  }

  void applyGlobalToneShelf(double toneFactor) {
    for (final assetPath in _activeHandles.keys) {
      updateTone(assetPath, toneFactor);
    }
  }

  void dispose() => _soloud.deinit();
}
