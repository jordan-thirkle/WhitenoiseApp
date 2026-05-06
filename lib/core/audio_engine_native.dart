import 'dart:async';
import 'dart:math' as math;
import 'package:flutter_soloud/flutter_soloud.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../main.dart';
import '../models/sound_model.dart';

final audioEngineProvider = Provider<AudioEngineRepository>((ref) => AudioEngineRepository());


class AudioEngineRepository {
  static final AudioEngineRepository _instance = AudioEngineRepository._internal();
  factory AudioEngineRepository() => _instance;
  AudioEngineRepository._internal();

  final SoLoud _soloud = SoLoud.instance;
  
  // Isolate sources by soundId to allow independent filtering/tone
  final Map<String, AudioSource> _loadedSources = {}; // soundId -> source
  final Map<String, SoundHandle> _activeHandles = {}; // soundId -> handle

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

  Future<void> _loadSoundForId(String soundId, String assetPath) async {
    try {
      final source = await _soloud.loadAsset(assetPath);
      _loadedSources[soundId] = source;
    } catch (e) {
      debugPrint('Error loading sound $soundId ($assetPath): $e');
    }
  }

  Future<void> playSound(String soundId, String assetPath, {double volume = 0.5, double tone = 1.0}) async {
    if (!isInitialized) await init();
    
    // Ensure existing handle is cleaned up
    stopSound(soundId);
    
    // Ensure source is loaded for this specific ID
    if (!_loadedSources.containsKey(soundId)) {
      await _loadSoundForId(soundId, assetPath);
    }
    
    final source = _loadedSources[soundId];
    if (source == null) return;

    try {
      final handle = _soloud.play(source, volume: volume, looping: true);
      _activeHandles[soundId] = handle;
      _updateTone(source, handle, tone);
      
      if (!kIsWeb) audioHandler.play();
    } catch (e) {
      debugPrint('Error playing sound $soundId ($assetPath): $e');
    }
  }

  void stopSound(String soundId) {
    final handle = _activeHandles[soundId];
    if (handle != null) {
      _soloud.stop(handle);
      _activeHandles.remove(soundId);
    }
    
    if (_activeHandles.isEmpty && !kIsWeb) {
      audioHandler.stop();
    }
  }

  void stopAll() {
    for (final handle in _activeHandles.values) {
      _soloud.stop(handle);
    }
    _activeHandles.clear();
    if (!kIsWeb) audioHandler.stop();
  }

  void stopAllWithFade(Duration duration) {
    for (final handle in _activeHandles.values) {
      _soloud.fadeVolume(handle, 0.0, duration);
      _soloud.scheduleStop(handle, duration);
    }
    Timer(duration, () => _activeHandles.clear());
    if (!kIsWeb) audioHandler.stop();
  }

  void updateVolume(String soundId, double volume) {
    final handle = _activeHandles[soundId];
    if (handle != null) {
      _soloud.setVolume(handle, volume);
    }
  }

  void updateTone(String soundId, String assetPath, double toneFactor) {
    final source = _loadedSources[soundId];
    final handle = _activeHandles[soundId];
    if (source != null && handle != null) {
      _updateTone(source, handle, toneFactor);
    }
  }

  void _updateTone(AudioSource source, SoundHandle handle, double toneFactor) {
    try {
      final double minFreq = 300.0;
      final double maxFreq = 14000.0;
      final double freq = minFreq * math.pow(maxFreq / minFreq, toneFactor);
      
      source.filters.biquadFilter.activate();
      source.filters.biquadFilter.type(soundHandle: handle).value = 0.0; // Lowpass
      source.filters.biquadFilter.frequency(soundHandle: handle).value = freq;
    } catch (e) {
      debugPrint('Error updating tone DSP: $e');
    }
  }

  void applyGlobalToneShelf(double toneFactor) {
    for (final sound in availableSounds) {
      if (_activeHandles.containsKey(sound.id)) {
        updateTone(sound.id, sound.assetPath, toneFactor);
      }
    }
  }

  void dispose() {
    stopAll();
    _soloud.deinit();
  }
}
