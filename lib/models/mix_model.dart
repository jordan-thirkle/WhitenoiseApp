

class SoundSetting {
  final double volume;
  final double tone;
  final bool isPlaying;

  SoundSetting({
    required this.volume,
    required this.tone,
    required this.isPlaying,
  });

  Map<String, dynamic> toJson() => {
    'volume': volume,
    'tone': tone,
    'isPlaying': isPlaying,
  };

  factory SoundSetting.fromJson(Map<String, dynamic> json) => SoundSetting(
    volume: (json['volume'] as num).toDouble(),
    tone: (json['tone'] as num).toDouble(),
    isPlaying: json['isPlaying'] as bool,
  );
}

class MixModel {
  final String id;
  final String name;
  final Map<String, SoundSetting> settings; // soundId -> settings

  MixModel({
    required this.id,
    required this.name,
    required this.settings,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'settings': settings.map((key, value) => MapEntry(key, value.toJson())),
  };

  factory MixModel.fromJson(Map<String, dynamic> json) => MixModel(
    id: json['id'] as String,
    name: json['name'] as String,
    settings: (json['settings'] as Map<String, dynamic>).map(
      (key, value) => MapEntry(key, SoundSetting.fromJson(value as Map<String, dynamic>)),
    ),
  );
}
