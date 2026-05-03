import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:murmur/core/audio_engine_repository.dart';

class SoundState {
  final String assetPath;
  final String name;
  final double volume;
  final double tone;
  final bool isActive;

  SoundState({
    required this.assetPath,
    required this.name,
    this.volume = 0.5,
    this.tone = 1.0,
    this.isActive = false,
  });

  SoundState copyWith({
    double? volume,
    double? tone,
    bool? isActive,
  }) {
    return SoundState(
      assetPath: assetPath,
      name: name,
      volume: volume ?? this.volume,
      tone: tone ?? this.tone,
      isActive: isActive ?? this.isActive,
    );
  }
}

class SoundCardController extends FamilyNotifier<SoundState, String> {
  final AudioEngineRepository _repository = AudioEngineRepository();

  @override
  SoundState build(String arg) {
    // We should ideally pass the name too, but for simplicity we'll find it or use arg
    return SoundState(assetPath: arg, name: _getNameFromPath(arg));
  }

  String _getNameFromPath(String path) {
    return path.split('/').last.split('.').first.replaceAll('_', ' ').toUpperCase();
  }

  void toggle() {
    if (state.isActive) {
      _repository.stopSound(state.assetPath);
      state = state.copyWith(isActive: false);
    } else {
      _repository.playSound(state.assetPath, volume: state.volume, tone: state.tone);
      state = state.copyWith(isActive: true);
    }
  }

  void setVolume(double value) {
    state = state.copyWith(volume: value);
    if (state.isActive) {
      _repository.updateVolume(state.assetPath, value);
    }
  }

  void setTone(double value) {
    state = state.copyWith(tone: value);
    if (state.isActive) {
      _repository.updateTone(state.assetPath, value);
    }
  }
}

final soundCardProvider = NotifierProvider.family<SoundCardController, SoundState, String>(() {
  return SoundCardController();
});
