class SoundModel {
  final String id;
  final String name;
  final String assetPath;
  final String icon;

  SoundModel({
    required this.id,
    required this.name,
    required this.assetPath,
    required this.icon,
  });
}

final List<SoundModel> availableSounds = [
  SoundModel(
    id: 'rain',
    name: 'Gentle Rain',
    assetPath: 'assets/audio/white_noise.ogg',
    icon: '🌧️',
  ),
  SoundModel(
    id: 'ocean',
    name: 'Ocean Waves',
    assetPath: 'assets/audio/white_noise.ogg',
    icon: '🌊',
  ),
  SoundModel(
    id: 'heartbeat',
    name: 'Heartbeat',
    assetPath: 'assets/audio/heartbeat.ogg',
    icon: '💓',
  ),
  SoundModel(
    id: 'brown_noise',
    name: 'Deep Brown Noise',
    assetPath: 'assets/audio/brown_noise.ogg',
    icon: '🌋',
  ),
];
