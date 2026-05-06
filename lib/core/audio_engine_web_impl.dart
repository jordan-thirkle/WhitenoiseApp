import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final audioEngineProvider = Provider<AudioEngineRepository>((ref) => AudioEngineRepository());


class AudioEngineRepository {
  static final AudioEngineRepository _instance = AudioEngineRepository._internal();
  factory AudioEngineRepository() => _instance;
  AudioEngineRepository._internal();

  // soundId -> AudioPlayer to allow multiple instances of same asset
  final Map<String, AudioPlayer> _players = {};

  bool get isInitialized => true;

  Future<void> init() async {
    debugPrint('AudioEngine: Web Fallback (Audioplayers) Initialized');
  }

  Future<void> playSound(String soundId, String assetPath, {double volume = 0.5, double tone = 1.0}) async {
    // If player exists, stop it first
    await _players[soundId]?.stop();

    if (!_players.containsKey(soundId)) {
      final player = AudioPlayer();
      await player.setSource(AssetSource(assetPath.replaceFirst('assets/', '')));
      _players[soundId] = player;
    }

    final player = _players[soundId];
    if (player != null) {
      await player.setVolume(volume);
      await player.setPlaybackRate(tone); // Web tone fallback
      await player.setReleaseMode(ReleaseMode.loop);
      await player.resume();
    }
  }

  void stopSound(String soundId) {
    _players[soundId]?.stop();
  }

  void stopAll() {
    for (final player in _players.values) {
      player.stop();
    }
  }

  void stopAllWithFade(Duration duration) {
    // Web lacks native cross-fade with Audioplayers easily, so immediate stop
    stopAll();
  }

  void updateVolume(String soundId, double volume) {
    _players[soundId]?.setVolume(volume);
  }

  void updateTone(String soundId, String assetPath, double toneFactor) {
    _players[soundId]?.setPlaybackRate(toneFactor);
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
    _players.clear();
  }
}
