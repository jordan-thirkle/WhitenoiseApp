import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../main.dart';

final audioEngineProvider = Provider<AudioEngineRepository>((ref) => AudioEngineRepository());


class AudioEngineRepository {
  static final AudioEngineRepository _instance = AudioEngineRepository._internal();
  factory AudioEngineRepository() => _instance;
  AudioEngineRepository._internal();

  final Map<String, AudioPlayer> _players = {};

  bool get isInitialized => true;

  Future<void> init() async {
    debugPrint('AudioEngine: Web Fallback (Audioplayers) Initialized');
  }

  Future<void> loadSound(String assetPath) async {
    if (_players.containsKey(assetPath)) return;
    final player = AudioPlayer();
    await player.setSource(AssetSource(assetPath.replaceFirst('assets/', '')));
    _players[assetPath] = player;
  }

  void playSound(String assetPath, {double volume = 0.5, double tone = 1.0}) {
    final player = _players[assetPath];
    if (player != null) {
      player.setVolume(volume);
      player.setReleaseMode(ReleaseMode.loop);
      player.resume();
      audioHandler.play();
    }
  }

  void stopSound(String assetPath) {
    final player = _players[assetPath];
    if (player != null) {
      player.stop();
    }
    
    if (!_players.values.any((p) => p.state == PlayerState.playing)) {
      audioHandler.stop();
    }
  }

  void stopAll() {
    for (final player in _players.values) {
      player.stop();
    }
    audioHandler.stop();
  }

  void stopAllWithFade(Duration duration) {
    // Basic stop for web (fade is complex with audioplayers on web)
    stopAll();
  }

  void updateVolume(String assetPath, double volume) {
    _players[assetPath]?.setVolume(volume);
  }

  void updateTone(String assetPath, double toneFactor) {
    // Tone control (playback rate) as a fallback for web
    _players[assetPath]?.setPlaybackRate(toneFactor);
  }

  void applyGlobalToneShelf(double toneFactor) {
    for (final player in _players.values) {
      player.setPlaybackRate(toneFactor);
    }
  }

  void dispose() {
    for (final player in _players.values) {
      player.dispose();
    }
  }
}
