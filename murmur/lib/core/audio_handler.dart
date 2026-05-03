import 'package:audio_service/audio_service.dart';
import 'package:flutter/foundation.dart';
import 'audio_engine_repository.dart';

class MurmurAudioHandler extends BaseAudioHandler {
  final AudioEngineRepository _repository = AudioEngineRepository();

  MurmurAudioHandler() {
    _init();
  }

  void _init() {
    playbackState.add(PlaybackState(
      controls: [
        MediaControl.stop,
      ],
      systemActions: const {
        MediaAction.stop,
      },
      processingState: AudioProcessingState.ready,
      playing: false,
    ));

    mediaItem.add(const MediaItem(
      id: 'murmur_session',
      album: 'Murmur',
      title: 'Premium Ambient Mixer',
      artist: 'Murmur Sleep',
      duration: null, // Indefinite
    ));
  }

  @override
  Future<void> play() async {
    // This doesn't trigger audio (SoLoud handles individual tracks)
    // But it updates the OS state
    playbackState.add(playbackState.value.copyWith(
      playing: true,
      controls: [MediaControl.stop],
    ));
  }

  @override
  Future<void> stop() async {
    _repository.stopAll();
    playbackState.add(playbackState.value.copyWith(
      playing: false,
      processingState: AudioProcessingState.idle,
    ));
  }
}
