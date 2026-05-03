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
  // NATURE CATEGORY
  SoundModel(id: 'rain', name: 'Gentle Rain', assetPath: 'assets/audio/white_noise.ogg', icon: '🌧️'),
  SoundModel(id: 'ocean', name: 'Ocean Waves', assetPath: 'assets/audio/white_noise.ogg', icon: '🌊'),
  SoundModel(id: 'thunder', name: 'Distant Thunder', assetPath: 'assets/audio/brown_noise.ogg', icon: '⚡'),
  SoundModel(id: 'wind', name: 'Arctic Wind', assetPath: 'assets/audio/pink_noise.ogg', icon: '🌬️'),
  
  // BIOLOGICAL CATEGORY
  SoundModel(id: 'heartbeat', name: 'Heartbeat', assetPath: 'assets/audio/heartbeat.ogg', icon: '💓'),
  SoundModel(id: 'womb', name: 'Safe Womb', assetPath: 'assets/audio/brown_noise.ogg', icon: '🤰'),
  
  // INDUSTRIAL CATEGORY
  SoundModel(id: 'fan', name: 'Electric Fan', assetPath: 'assets/audio/pink_noise.ogg', icon: '🌀'),
  SoundModel(id: 'train', name: 'Night Train', assetPath: 'assets/audio/brown_noise.ogg', icon: '🚂'),
  SoundModel(id: 'plane', name: 'Cabin Hum', assetPath: 'assets/audio/white_noise.ogg', icon: '✈️'),
  
  // SYNTHETIC CATEGORY (Scientific)
  SoundModel(id: 'white', name: 'Pure White', assetPath: 'assets/audio/white_noise.ogg', icon: '⚪'),
  SoundModel(id: 'pink', name: 'Deep Pink', assetPath: 'assets/audio/pink_noise.ogg', icon: '🌸'),
  SoundModel(id: 'brown', name: 'Sub Brown', assetPath: 'assets/audio/brown_noise.ogg', icon: '🟤'),
];
