import 'package:flutter/foundation.dart';
import 'package:murmur/models/sound_model.dart';
import 'package:murmur/models/mix_model.dart';
import 'package:murmur/core/audio_engine_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SoundState {
  final String id;
  final String assetPath;
  final String name;
  final double volume;
  final double tone;
  final bool isActive;
  final bool isLoading;

  SoundState({
    required this.id,
    required this.assetPath,
    required this.name,
    this.volume = 0.5,
    this.tone = 1.0,
    this.isActive = false,
    this.isLoading = false,
  });

  SoundState copyWith({
    double? volume,
    double? tone,
    bool? isActive,
    bool? isLoading,
  }) {
    return SoundState(
      id: id,
      assetPath: assetPath,
      name: name,
      volume: volume ?? this.volume,
      tone: tone ?? this.tone,
      isActive: isActive ?? this.isActive,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

class SoundCardController extends FamilyNotifier<SoundState, String> {
  AudioEngineRepository get _repository => ref.read(audioEngineProvider);

  @override
  SoundState build(String arg) {
    // Look up the sound model by ID
    final sound = availableSounds.firstWhere((s) => s.id == arg);
    return SoundState(
      id: sound.id,
      assetPath: sound.assetPath,
      name: sound.name,
    );
  }

  Future<void> toggle() async {
    if (state.isLoading) return; // Prevent rapid toggle race condition

    final currentState = state;
    if (currentState.isActive) {
      state = currentState.copyWith(isLoading: true);
      _repository.stopSound(currentState.id);
      state = state.copyWith(isActive: false, isLoading: false);
    } else {
      state = currentState.copyWith(isLoading: true);
      try {
        await _repository.playSound(
          currentState.id, 
          currentState.assetPath, 
          volume: currentState.volume, 
          tone: currentState.tone
        );
        state = state.copyWith(isActive: true, isLoading: false);
      } catch (e) {
        state = state.copyWith(isLoading: false);
        debugPrint('Error toggling sound: $e');
      }
    }
  }

  void setVolume(double value) {
    final currentState = state;
    state = currentState.copyWith(volume: value);
    if (state.isActive) {
      _repository.updateVolume(state.id, value);
    }
  }

  void setTone(double value) {
    final currentState = state;
    state = currentState.copyWith(tone: value);
    if (state.isActive) {
      _repository.updateTone(state.id, state.assetPath, value);
    }
  }

  Future<void> applySetting(SoundSetting setting) async {
    final currentState = state;
    state = currentState.copyWith(
      volume: setting.volume,
      tone: setting.tone,
      isActive: setting.isPlaying,
    );

    final updatedState = state;
    if (updatedState.isActive) {
      await _repository.playSound(updatedState.id, updatedState.assetPath, volume: updatedState.volume, tone: updatedState.tone);
    } else {
      _repository.stopSound(updatedState.id);
    }
  }
}

final soundCardProvider = NotifierProvider.family<SoundCardController, SoundState, String>(() {
  return SoundCardController();
});
