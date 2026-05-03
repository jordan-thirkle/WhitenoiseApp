import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../models/mix_model.dart';

class MixController extends StateNotifier<List<MixModel>> {
  final SharedPreferences? _prefs;
  static const String _storageKey = 'murmur_favorites';

  MixController(this._prefs) : super([]) {
    _loadFromPrefs();
  }

  void _loadFromPrefs() {
    if (_prefs == null) return;
    final jsonString = _prefs!.getString(_storageKey);
    if (jsonString != null) {
      final List<dynamic> decoded = json.decode(jsonString);
      state = decoded.map((item) => MixModel.fromJson(item)).toList();
    }
  }

  Future<void> saveMix(String name, Map<String, SoundSetting> currentSettings) async {
    final newMix = MixModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: name,
      settings: currentSettings,
    );
    
    state = [...state, newMix];
    await _syncToPrefs();
  }

  Future<void> deleteMix(String id) async {
    state = state.where((mix) => mix.id != id).toList();
    await _syncToPrefs();
  }

  Future<void> _syncToPrefs() async {
    if (_prefs == null) return;
    final jsonString = json.encode(state.map((mix) => mix.toJson()).toList());
    await _prefs!.setString(_storageKey, jsonString);
  }
}

final sharedPrefsProvider = Provider<SharedPreferences?>((ref) => throw UnimplementedError());

final mixControllerProvider = StateNotifierProvider<MixController, List<MixModel>>((ref) {
  final prefs = ref.watch(sharedPrefsProvider);
  return MixController(prefs);
});
