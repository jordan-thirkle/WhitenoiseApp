import 'dart:async';
import 'dart:math' as math;
import 'package:flutter_soloud/flutter_soloud.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../main.dart'; // To access global audioHandler

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
      
      // Initialize Master Safety Limiter
      _soloud.filters.limiterFilter.activate();
      _soloud.filters.limiterFilter.threshold.value = -3.0;
      _soloud.filters.limiterFilter.outputCeiling.value = -0.1;

      // Prepare Audio Capture for Room Calibration
      await _soloud.audioCapture.init();
      
      debugPrint('SoLoud Audio Engine Initialized with Master Safety Limiter and Capture Interface');
    } catch (e) {
      debugPrint('Failed to initialize SoLoud: $e');
    }
  }

  /// Performs a 5-second capture of room noise floor and returns the FFT spectrum
  Future<List<double>> analyzeRoomNoise() async {
    if (!isInitialized) return [];
    
    try {
      // Start capturing from microphone
      _soloud.audioCapture.start();
      
      // Accumulate FFT data for 3 seconds to average out transients
      List<double> averageFft = List.filled(256, 0.0);
      int samples = 0;
      
      final startTime = DateTime.now();
      while (DateTime.now().difference(startTime).inSeconds < 3) {
        final currentFft = _soloud.audioCapture.getFft();
        for (int i = 0; i < 256; i++) {
          averageFft[i] += currentFft[i];
        }
        samples++;
        await Future.delayed(const Duration(milliseconds: 100));
      }
      
      _soloud.audioCapture.stop();
      
      // Calculate mean spectrum
      return averageFft.map((val) => val / samples).toList();
    } catch (e) {
      debugPrint('Error during room analysis: $e');
      return [];
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
      // In 4.x, play is synchronous
      final handle = _soloud.play(source, volume: volume, looping: true);
      _activeHandles[assetPath] = handle;
      _updateTone(source, handle, tone);
      audioHandler.play(); // Sync with OS
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
    
    if (_activeHandles.isEmpty) {
      audioHandler.stop(); // Sync with OS
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
    audioHandler.stop(); // Sync with OS
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

  void applyGlobalToneShelf(double toneFactor) {
    for (final assetPath in _activeHandles.keys) {
      updateTone(assetPath, toneFactor);
    }
  }

  void updateVolume(String assetPath, double volume) {
    final handle = _activeHandles[assetPath];
    if (handle != null) {
      _soloud.setVolume(handle, volume);
    }
  }

  void updateTone(String assetPath, double toneFactor) {
    final source = _loadedSources[assetPath];
    final handle = _activeHandles[assetPath];
    if (source != null && handle != null) {
      _updateTone(source, handle, toneFactor);
    }
  }

  void _updateTone(AudioSource source, SoundHandle handle, double toneFactor) {
    try {
      // Logarithmic mapping for natural frequency attenuation (400Hz to 16000Hz)
      // Human hearing perceives frequency on a log scale.
      final double minFreq = 400.0;
      final double maxFreq = 16000.0;
      final double freq = minFreq * math.pow(maxFreq / minFreq, toneFactor);
      
      // Butterworth Filter: Q = 0.707 for maximally flat passband
      _soloud.filters.biquadFilter.activateOnSource(source);
      _soloud.filters.biquadFilter.frequency(source).value = freq;
      _soloud.filters.biquadFilter.resonance(source).value = 0.707;
      _soloud.filters.biquadFilter.type(source).value = BiquadResonantFilterType.lowpass;
    } catch (e) {
      debugPrint('Error updating tone DSP: $e');
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
