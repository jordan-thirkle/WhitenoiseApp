import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:murmur/features/audio/sound_card_controller.dart';
import 'package:murmur/core/audio_engine_repository.dart';
import 'package:murmur/models/sound_model.dart';
import 'package:mocktail/mocktail.dart';

class MockAudioEngine extends Mock implements AudioEngineRepository {}

void main() {
  late ProviderContainer container;
  late MockAudioEngine mockEngine;

  setUp(() {
    mockEngine = MockAudioEngine();
    container = ProviderContainer(
      overrides: [
        audioEngineProvider.overrideWithValue(mockEngine),
      ],
    );
  });

  tearDown(() {
    container.dispose();
  });

  test('SoundCardController toggles sound and calls engine', () async {
    final soundId = availableSounds.first.id;
    final assetPath = availableSounds.first.assetPath;
    
    when(() => mockEngine.playSound(any(), any(), volume: any(named: 'volume'), tone: any(named: 'tone')))
        .thenAnswer((_) async {});
    when(() => mockEngine.stopSound(any())).thenReturn(null);

    final controller = container.read(soundCardProvider(soundId).notifier);
    
    // Initial state
    expect(container.read(soundCardProvider(soundId)).isActive, false);

    // Toggle on
    await controller.toggle();
    expect(container.read(soundCardProvider(soundId)).isActive, true);
    verify(() => mockEngine.playSound(soundId, assetPath, volume: any(named: 'volume'), tone: any(named: 'tone'))).called(1);

    // Toggle off
    await controller.toggle();
    expect(container.read(soundCardProvider(soundId)).isActive, false);
    verify(() => mockEngine.stopSound(soundId)).called(1);
  });
}
