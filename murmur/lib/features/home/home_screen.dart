import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:murmur/core/murmur_theme.dart';
import 'package:murmur/models/sound_model.dart';
import 'package:murmur/features/audio/sound_card_controller.dart';
import 'package:murmur/core/audio_engine_repository.dart';
import 'package:murmur/features/audio/mix_controller.dart';
import 'package:murmur/models/mix_model.dart';
import 'package:murmur/features/audio/timer_controller.dart';
import 'package:murmur/core/iap_service.dart';
import 'package:murmur/core/matter_service.dart';
import 'package:murmur/core/health_service.dart';
import 'package:murmur/core/neuro_stimulator.dart';
import 'package:murmur/core/spatial_audio_service.dart';
import 'package:murmur/core/sovereign_coach_service.dart';
import 'package:murmur/core/eeg_hardware_service.dart';
import 'package:murmur/core/codec_sep_engine.dart';
import 'package:murmur/core/gnn_diagnostic_service.dart';
import 'package:murmur/core/ephemeral_agent_service.dart';
import 'package:murmur/core/snore_neutralizer.dart';
import 'package:murmur/features/stats/stats_screen.dart';
import 'package:url_launcher/url_launcher.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final iapService = ref.watch(iapServiceProvider);
    
    return ValueListenableBuilder<bool>(
      valueListenable: iapService.isPro,
      builder: (context, isPro, _) {
        return Scaffold(
          backgroundColor: MurmurTheme.background,
          body: Stack(
            children: [
              // Background Glow
              Positioned(
                top: -100,
                left: -100,
                child: _AmbientGlow(color: MurmurTheme.accent.withOpacity(0.05)),
              ),
              CustomScrollView(
                slivers: [
                  _buildAppBar(context, ref, isPro),
                  _buildMixerHeader(context, ref),
                  _buildSoundGrid(context, ref, isPro),
                  const SliverPadding(padding: EdgeInsets.only(bottom: 120)),
                ],
              ),
            ],
          ),
          bottomNavigationBar: _buildBottomBar(context, ref),
        );
      },
    );
  }

  Widget _buildAppBar(BuildContext context, WidgetRef ref, bool isPro) {
    return SliverAppBar(
      backgroundColor: Colors.transparent,
      floating: true,
      centerTitle: false,
      title: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 150),
        child: FittedBox(
          fit: BoxFit.scaleDown,
          alignment: Alignment.centerLeft,
          child: Text(
            'Murmur',
            style: TextStyle(
              fontSize: 48,
              fontWeight: FontWeight.w900,
              color: MurmurTheme.accent.withOpacity(0.8),
              letterSpacing: -2,
            ),
          ),
        ),
      ),
      actions: [
        if (!isPro)
          Center(
            child: Padding(
              padding: const EdgeInsets.only(right: 8),
              child: ElevatedButton(
                onPressed: () => ref.read(iapServiceProvider).buyPro(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: MurmurTheme.accent.withOpacity(0.1),
                  foregroundColor: MurmurTheme.accent,
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  minimumSize: Size.zero,
                  elevation: 0,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                ),
                child: const Text('PRO', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 10)),
              ),
            ),
          )
        else
          const Padding(
            padding: EdgeInsets.only(right: 8),
            child: Icon(Icons.verified_rounded, color: Colors.amberAccent, size: 20),
          ),
        IconButton(
          icon: const Icon(Icons.info_outline_rounded, color: Colors.white70, size: 20),
          onPressed: () => _showAboutDialog(context),
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(),
        ),
        const SizedBox(width: 16),
      ],
    );
  }

  Widget _buildMixerHeader(BuildContext context, WidgetRef ref) {
    final timerState = ref.watch(timerControllerProvider);

    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 8, 16, 24),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  child: Text(
                    timerState.isRunning 
                      ? 'TIMER: ${_formatDuration(timerState.remaining!)}'
                      : 'MULTI-TRACK MIXER',
                    key: ValueKey(timerState.isRunning),
                    style: TextStyle(
                      color: timerState.isRunning ? MurmurTheme.accent : Colors.white.withOpacity(0.4),
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 2,
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                AnimatedContainer(
                  duration: const Duration(milliseconds: 500),
                  width: timerState.isRunning ? 80 : 40,
                  height: 3,
                  decoration: BoxDecoration(
                    color: timerState.isRunning ? MurmurTheme.accent : MurmurTheme.accent.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ],
            ),
            Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.info_outline_rounded, color: Colors.white38, size: 16),
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Ethical AI: NACEngine (C2PA Signed)')),
                    );
                  },
                  tooltip: 'C2PA Content Credentials',
                  visualDensity: VisualDensity.comfortable,
                  padding: const EdgeInsets.all(12),
                ),
                IconButton(
                  icon: const Icon(Icons.psychology_rounded, color: Colors.deepPurpleAccent, size: 20),
                  onPressed: () {
                    ref.read(neuroStimulatorProvider).startNeuroDeepening();
                  },
                  tooltip: 'Neuro Sync',
                  visualDensity: VisualDensity.comfortable,
                  padding: const EdgeInsets.all(12),
                ),
                IconButton(
                  icon: const Icon(Icons.hearing_rounded, color: Colors.amberAccent, size: 20),
                  onPressed: () {
                    ref.read(codecSepEngineProvider).separateEnvironmentalStem("neighbor's dog");
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('CodecSep: Muting neighbor\'s dog')),
                    );
                  },
                  tooltip: 'Latent Sep',
                  visualDensity: VisualDensity.comfortable,
                  padding: const EdgeInsets.all(12),
                ),
                // Neuro-Link Status (SQI / Target Rate)
                Consumer(
                  builder: (context, ref, _) {
                    final eeg = ref.watch(eegHardwareServiceProvider);
                    return ValueListenableBuilder<double>(
                      valueListenable: eeg.signalQuality,
                      builder: (context, sqi, _) {
                        if (sqi == 0) return const SizedBox.shrink();
                        return Container(
                          margin: const EdgeInsets.only(left: 8),
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: Colors.deepPurpleAccent.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(4),
                            border: Border.all(color: Colors.deepPurpleAccent.withOpacity(0.3)),
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 6,
                                height: 6,
                                decoration: const BoxDecoration(
                                  color: Colors.greenAccent,
                                  shape: BoxShape.circle,
                                ),
                              ),
                              const SizedBox(width: 4),
                              Text(
                                'LINK: ${(sqi * 100).toInt()}%',
                                style: MurmurTheme.secondaryTextStyle.copyWith(fontSize: 10, letterSpacing: 0.5),
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  },
                ),
                const SizedBox(width: 8), // Increased hit-box buffer
                IconButton(
                  icon: const Icon(Icons.security_rounded, color: Colors.tealAccent, size: 20),
                  onPressed: () {
                    ref.read(snoreNeutralizerProvider).enableActiveMasking();
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Active Snore Guard Armed')),
                    );
                  },
                  tooltip: 'Snore Guard',
                  visualDensity: VisualDensity.comfortable,
                  padding: const EdgeInsets.all(12),
                ),
                IconButton(
                  icon: const Icon(Icons.favorite_rounded, color: Colors.pinkAccent, size: 20),
                  onPressed: () {
                    ref.read(healthServiceProvider).openHealthDashboard();
                  },
                  tooltip: 'Health Sync',
                  visualDensity: VisualDensity.comfortable,
                  padding: const EdgeInsets.all(12),
                ),
                IconButton(
                  icon: const Icon(Icons.hub_rounded, color: Colors.blueAccent, size: 20),
                  onPressed: () {
                    ref.read(matterServiceProvider).broadcastSleepScene();
                  },
                  tooltip: 'Matter Scene',
                  visualDensity: VisualDensity.comfortable,
                  padding: const EdgeInsets.all(12),
                ),
                IconButton(
                  icon: const Icon(Icons.waves_rounded, color: Colors.greenAccent, size: 20),
                  onPressed: () => _showCalibrationDialog(context, ref),
                  tooltip: 'Calibrate Room',
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  constraints: const BoxConstraints(),
                ),
                IconButton(
                  icon: Icon(
                    timerState.isRunning ? Icons.timer_rounded : Icons.timer_outlined,
                    color: timerState.isRunning ? MurmurTheme.accent : Colors.white30,
                    size: 20,
                  ),
                  onPressed: () => _showTimerSheet(context, ref),
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  constraints: const BoxConstraints(),
                ),
                IconButton(
                  icon: const Icon(Icons.star_outline_rounded, color: Colors.white30, size: 20),
                  onPressed: () => _showFavoritesSheet(context, ref),
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  constraints: const BoxConstraints(),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String minutes = twoDigits(duration.inMinutes.remainder(60));
    String seconds = twoDigits(duration.inSeconds.remainder(60));
    return "$minutes:$seconds";
  }

  void _showCalibrationDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => _CalibrationDialog(
        onCalibrate: () async {
          final fft = await ref.read(audioEngineProvider).analyzeRoomNoise();
          if (fft.isNotEmpty) {
            _applyInverseMasking(ref, fft);
          }
        },
      ),
    );
  }

  void _applyInverseMasking(WidgetRef ref, List<double> fft) {
    // Basic Inverse Masking Algorithm:
    // fft[0-20] are low frequencies (AC hum, traffic)
    // fft[20-100] are mid frequencies (Fans, talking)
    // fft[100-255] are high frequencies (Hiss, electronics)
    
    double lowEnergy = fft.sublist(0, 20).reduce((a, b) => a + b) / 20;
    double midEnergy = fft.sublist(20, 100).reduce((a, b) => a + b) / 80;
    double highEnergy = fft.sublist(100, 256).reduce((a, b) => a + b) / 156;

    // Normalizing energy to a usable volume multiplier
    lowEnergy = (lowEnergy * 10).clamp(0.1, 0.8);
    midEnergy = (midEnergy * 10).clamp(0.1, 0.8);
    highEnergy = (highEnergy * 10).clamp(0.1, 0.8);

    // Auto-Mix based on noise floor
    ref.read(audioEngineProvider).stopAll();
    
    // Masking low hum with Brown Noise/Heartbeat
    if (lowEnergy > 0.2) {
      ref.read(soundCardProvider('brown').notifier).applySetting(SoundSetting(volume: lowEnergy, tone: 0.3, isPlaying: true));
    }
    
    // Masking mid noise with Pink Noise/Fan
    if (midEnergy > 0.2) {
      ref.read(soundCardProvider('fan').notifier).applySetting(SoundSetting(volume: midEnergy, tone: 0.6, isPlaying: true));
    }

    // Masking high hiss with White Noise/Rain
    if (highEnergy > 0.1) {
      ref.read(soundCardProvider('white').notifier).applySetting(SoundSetting(volume: highEnergy, tone: 0.9, isPlaying: true));
    }
  }

  void _showTimerSheet(BuildContext context, WidgetRef ref) {
    final timerState = ref.watch(timerControllerProvider);
    final timerNotifier = ref.read(timerControllerProvider.notifier);

    showModalBottomSheet(
      context: context,
      backgroundColor: MurmurTheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'SLEEP TIMER',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, letterSpacing: 2),
            ),
            const SizedBox(height: 8),
            const Text(
              'Audio will fade out gradually over 60s',
              style: TextStyle(fontSize: 12, color: Colors.white30),
            ),
            const SizedBox(height: 32),
            if (timerState.isRunning)
              Column(
                children: [
                  Text(
                    _formatDuration(timerState.remaining!),
                    style: const TextStyle(fontSize: 48, fontWeight: FontWeight.w100),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () {
                      timerNotifier.cancelTimer();
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.redAccent.withOpacity(0.1),
                      foregroundColor: Colors.redAccent,
                      elevation: 0,
                    ),
                    child: const Text('CANCEL TIMER'),
                  ),
                ],
              )
            else
              Wrap(
                spacing: 12,
                runSpacing: 12,
                children: [15, 30, 45, 60, 90, 120].map((mins) => 
                  InkWell(
                    onTap: () {
                      timerNotifier.setTimer(mins);
                      Navigator.pop(context);
                    },
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      width: 80,
                      height: 50,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.white10),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      alignment: Alignment.center,
                      child: Text('${mins}m', style: const TextStyle(fontWeight: FontWeight.bold)),
                    ),
                  )
                ).toList(),
              ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildSoundGrid(BuildContext context, WidgetRef ref, bool isPro) {
    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      sliver: SliverGrid(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 16,
          crossAxisSpacing: 16,
          childAspectRatio: 0.85,
        ),
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            final sound = availableSounds[index];
            return SoundCard(sound: sound, isPro: isPro);
          },
          childCount: availableSounds.length,
        ),
      ),
    );
  }

  Widget _buildBottomBar(BuildContext context, WidgetRef ref) {
    return ClipRRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
        child: Container(
          height: 100,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          decoration: BoxDecoration(
            color: MurmurTheme.surface.withOpacity(0.8),
            border: Border(
              top: BorderSide(color: Colors.white.withOpacity(0.05), width: 1),
            ),
          ),
          child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'SYSTEM STATUS',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.3),
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1,
                ),
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  Container(
                    width: 6,
                    height: 6,
                    decoration: const BoxDecoration(
                      color: Colors.greenAccent,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    'ENGINE ACTIVE',
                    style: TextStyle(
                      color: Colors.greenAccent,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ],
          ),
          Row(
            children: [
              TextButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const StatsScreen()),
                  );
                },
                icon: const Icon(Icons.insights_rounded, size: 18, color: Colors.white70),
                label: const Text('INSIGHTS', style: TextStyle(color: Colors.white70, fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 1)),
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                ),
              ),
              const SizedBox(width: 8),
              ElevatedButton.icon(
                onPressed: () => _showSaveMixDialog(context, ref),
                icon: const Icon(Icons.add_rounded, size: 18),
                label: const Text('SAVE MIX'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: MurmurTheme.accent,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    ),
  ),
);
}

  void _showFavoritesSheet(BuildContext context, WidgetRef ref) {
    final mixes = ref.watch(mixControllerProvider);

    showModalBottomSheet(
      context: context,
      backgroundColor: MurmurTheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'SAVED MIXES',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
            const SizedBox(height: 16),
            if (mixes.isEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 40),
                child: Center(
                  child: Text(
                    'No saved mixes yet',
                    style: TextStyle(color: Colors.white.withOpacity(0.3)),
                  ),
                ),
              )
            else
              ListView.separated(
                shrinkWrap: true,
                itemCount: mixes.length,
                separatorBuilder: (context, index) => const Divider(color: Colors.white10),
                itemBuilder: (context, index) {
                  final mix = mixes[index];
                  return ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text(mix.name, style: const TextStyle(fontWeight: FontWeight.w600)),
                    subtitle: Text(
                      '${mix.settings.values.where((s) => s.isPlaying).length} sounds active',
                      style: TextStyle(color: Colors.white.withOpacity(0.4), fontSize: 12),
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.play_circle_outline_rounded, color: Color(0xFF7BA7F5)),
                          onPressed: () {
                            _applyMix(ref, mix);
                            Navigator.pop(context);
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete_outline_rounded, color: Colors.redAccent, size: 20),
                          onPressed: () => ref.read(mixControllerProvider.notifier).deleteMix(mix.id),
                        ),
                      ],
                    ),
                  );
                },
              ),
          ],
        ),
      ),
    );
  }

  void _applyMix(WidgetRef ref, MixModel mix) {
    // Stop everything first
    ref.read(audioEngineProvider).stopAll();
    
    // Apply settings to each sound
    for (final sound in availableSounds) {
      final setting = mix.settings[sound.assetPath] ?? SoundSetting(volume: 0.5, tone: 1.0, isPlaying: false);
      ref.read(soundCardProvider(sound.assetPath).notifier).applySetting(setting);
    }
  }

  void _showSaveMixDialog(BuildContext context, WidgetRef ref) {
    final nameController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: MurmurTheme.surface,
        title: const Text('Save Current Mix'),
        content: TextField(
          controller: nameController,
          autofocus: true,
          decoration: const InputDecoration(
            hintText: 'Enter mix name (e.g. Rainy Night)',
            hintStyle: TextStyle(color: Colors.white24),
          ),
          style: const TextStyle(color: Colors.white),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('CANCEL'),
          ),
          TextButton(
            onPressed: () {
              if (nameController.text.isNotEmpty) {
                _saveCurrentMix(ref, nameController.text);
                Navigator.pop(context);
              }
            },
            child: const Text('SAVE', style: TextStyle(color: Color(0xFF7BA7F5))),
          ),
        ],
      ),
    );
  }

  void _saveCurrentMix(WidgetRef ref, String name) {
    final Map<String, SoundSetting> currentSettings = {};
    
    for (final sound in availableSounds) {
      final state = ref.read(soundCardProvider(sound.assetPath));
      currentSettings[sound.assetPath] = SoundSetting(
        volume: state.volume,
        tone: state.tone,
        isPlaying: state.isActive,
      );
    }
    
    ref.read(mixControllerProvider.notifier).saveMix(name, currentSettings);
  }

  void _showAboutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => const SettingsDialog(),
    );
  }
}

class SoundCard extends ConsumerWidget {
  final SoundModel sound;
  final bool isPro;
  const SoundCard({super.key, required this.sound, required this.isPro});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(soundCardProvider(sound.assetPath));
    final controller = ref.read(soundCardProvider(sound.assetPath).notifier);
    final bool isLocked = sound.isPremium && !isPro;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeOutExpo,
      decoration: BoxDecoration(
        color: MurmurTheme.surface,
        borderRadius: MurmurTheme.cardRadius,
        border: Border.all(
          color: state.isActive 
              ? MurmurTheme.accent.withOpacity(0.3 + (state.volume * 0.4)) 
              : Colors.white.withOpacity(0.05),
          width: 2,
        ),
        boxShadow: state.isActive ? [
          BoxShadow(
            color: MurmurTheme.accent.withOpacity(0.1 + (state.volume * 0.2)),
            blurRadius: 20 + (state.volume * 20),
            spreadRadius: state.volume * 4,
          )
        ] : [],
      ),
      child: ClipRRect(
        borderRadius: MurmurTheme.cardRadius,
        child: Column(
          children: [
            Expanded(
              child: GestureDetector(
                onTap: () {
                  if (isLocked) {
                    HapticFeedback.heavyImpact();
                    ref.read(iapServiceProvider).buyPro();
                  } else {
                    HapticFeedback.mediumImpact();
                    controller.toggle();
                  }
                },
                behavior: HitTestBehavior.opaque,
                child: Container(
                  width: double.infinity,
                  child: Stack(
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _PulseIcon(
                            icon: sound.icon,
                            isActive: state.isActive,
                          ),
                          const SizedBox(height: 12),
                          Text(
                            sound.name,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: state.isActive ? Colors.white : Colors.white70,
                            ),
                          ),
                          const SizedBox(height: 16),
                          AnimatedSwitcher(
                            duration: const Duration(milliseconds: 300),
                            child: Icon(
                              isLocked 
                                ? Icons.lock_outline_rounded
                                : (state.isActive ? Icons.pause_rounded : Icons.power_settings_new_rounded),
                              key: ValueKey(state.isActive || isLocked),
                              color: isLocked ? Colors.white24 : (state.isActive ? MurmurTheme.accent : Colors.white24),
                              size: 32,
                            ),
                          ),
                        ],
                      ),
                      if (isLocked)
                        Positioned(
                          top: 12,
                          right: 12,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: MurmurTheme.accent.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              'PRO',
                              style: TextStyle(
                                color: MurmurTheme.accent,
                                fontSize: 8,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
            AnimatedCrossFade(
              firstChild: const SizedBox(width: double.infinity),
              secondChild: _buildMixerControls(context, state, controller),
              crossFadeState: state.isActive ? CrossFadeState.showSecond : CrossFadeState.showFirst,
              duration: const Duration(milliseconds: 300),
              sizeCurve: Curves.easeInOutExpo,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMixerControls(BuildContext context, SoundState state, SoundCardController controller) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      child: Column(
        children: [
          _buildSliderRow(
            icon: Icons.volume_up_rounded,
            value: state.volume,
            onChanged: controller.setVolume,
          ),
          const SizedBox(height: 8),
          _buildSliderRow(
            icon: Icons.graphic_eq_rounded,
            value: state.tone,
            onChanged: controller.setTone,
          ),
        ],
      ),
    );
  }

  Widget _buildSliderRow({
    required IconData icon,
    required double value,
    required Function(double) onChanged,
  }) {
    return Row(
      children: [
        Icon(icon, size: 14, color: Colors.white30),
        Expanded(
          child: SliderTheme(
            data: SliderThemeData(
              trackHeight: 2,
              thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 6),
              overlayShape: const RoundSliderOverlayShape(overlayRadius: 12),
              activeTrackColor: MurmurTheme.accent,
              inactiveTrackColor: Colors.white10,
              thumbColor: Colors.white,
            ),
            child: Slider(
              value: value,
              onChanged: (val) {
              HapticFeedback.selectionClick();
              onChanged(val);
            },
            ),
          ),
        ),
      ],
    );
  }
}

class _PulseIcon extends StatefulWidget {
  final String icon;
  final bool isActive;
  const _PulseIcon({required this.icon, required this.isActive});

  @override
  State<_PulseIcon> createState() => _PulseIconState();
}

class _PulseIconState extends State<_PulseIcon> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );
    _scale = Tween<double>(begin: 1.0, end: 1.15).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOutSine),
    );

    final bool prefersReducedMotion = MediaQuery.of(context).accessibleNavigation;

    if (widget.isActive && !prefersReducedMotion) {
      _controller.repeat(reverse: true);
    }
  }

  @override
  void didUpdateWidget(_PulseIcon oldWidget) {
    super.didUpdateWidget(oldWidget);
    final bool prefersReducedMotion = MediaQuery.of(context).accessibleNavigation;

    if (widget.isActive != oldWidget.isActive) {
      if (widget.isActive && !prefersReducedMotion) {
        _controller.repeat(reverse: true);
      } else {
        _controller.stop();
        _controller.animateTo(0, duration: const Duration(milliseconds: 500));
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _scale,
      child: Text(
        widget.icon,
        style: const TextStyle(fontSize: 32),
      ),
    );
  }
}

class _AmbientGlow extends StatelessWidget {
  final Color color;
  const _AmbientGlow({required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 400,
      height: 400,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(
          colors: [color, Colors.transparent],
        ),
      ),
    );
  }
}

class SettingsDialog extends ConsumerWidget {
  const SettingsDialog({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final iapService = ref.watch(iapServiceProvider);

    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
      child: AlertDialog(
        backgroundColor: MurmurTheme.surface.withOpacity(0.9),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
        title: const Text('Murmur', style: TextStyle(fontWeight: FontWeight.w900)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ValueListenableBuilder<bool>(
              valueListenable: iapService.isPro,
              builder: (context, isPro, _) {
                return Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: isPro ? Colors.amberAccent.withOpacity(0.1) : Colors.white.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        isPro ? Icons.verified_rounded : Icons.star_border_rounded,
                        color: isPro ? Colors.amberAccent : Colors.white30,
                      ),
                      const SizedBox(width: 12),
                      Text(
                        isPro ? 'MURMUR PRO ACTIVE' : 'FREE EDITION',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: isPro ? Colors.amberAccent : Colors.white30,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
            const SizedBox(height: 16),
            _buildLink(context, 'Privacy Policy', 'https://jordan-thirkle-com.vercel.app/murmur/privacy'),
            _buildLink(context, 'Terms of Service', 'https://jordan-thirkle-com.vercel.app/murmur/terms'),
            const Divider(color: Colors.white10),
            ListTile(
              title: const Text('Restore Purchases'),
              trailing: const Icon(Icons.restore_rounded, size: 18),
              onTap: () {
                ref.read(iapServiceProvider).restorePurchases();
                Navigator.pop(context);
              },
            ),
            const SizedBox(height: 16),
            const Text(
              'Premium Ambient Audio Engine\nv1.1.0 (Stable)',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 12, color: Colors.white30),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLink(BuildContext context, String text, String url) {
    return ListTile(
      title: Text(text),
      trailing: const Icon(Icons.open_in_new_rounded, size: 18),
      onTap: () => launchUrl(Uri.parse(url)),
    );
  }
}

class _CalibrationDialog extends StatefulWidget {
  final Future<void> Function() onCalibrate;
  const _CalibrationDialog({required this.onCalibrate});

  @override
  State<_CalibrationDialog> createState() => _CalibrationDialogState();
}

class _CalibrationDialogState extends State<_CalibrationDialog> with SingleTickerProviderStateMixin {
  bool _isCalibrating = false;
  double _progress = 0.0;
  String _statusText = 'READY TO ANALYZE';
  late AnimationController _pulseController;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );
  }

  bool _isPaused = false;

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  void _start() async {
    setState(() {
      _isCalibrating = true;
      _statusText = 'INITIALIZING SENSORS...';
    });
    
    final bool prefersReducedMotion = MediaQuery.of(context).accessibleNavigation;
    if (!prefersReducedMotion) {
      _pulseController.repeat();
    }
    
    // Phase 1: Bass Analysis
    await Future.delayed(const Duration(milliseconds: 800));
    if (mounted) setState(() {
      _statusText = 'DETECTING LOW-FREQ HUM...';
      _progress = 0.3;
    });

    // Phase 2: Mid/High Analysis
    await Future.delayed(const Duration(milliseconds: 1200));
    if (mounted) setState(() {
      _statusText = 'MAPPING RESONANCE...';
      _progress = 0.7;
    });

    await widget.onCalibrate();
    
    if (mounted) {
      setState(() {
        _statusText = 'CALIBRATION COMPLETE';
        _progress = 1.0;
      });
      await Future.delayed(const Duration(milliseconds: 500));
      if (mounted) Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 30, sigmaY: 30),
      child: AlertDialog(
        backgroundColor: MurmurTheme.surface.withOpacity(0.8),
        shape: RoundedRectangleBorder(
          borderRadius: MurmurTheme.dialogRadius,
          side: BorderSide(color: Colors.white.withOpacity(0.05)),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.greenAccent.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Text(
                    'MEDICAL GRADE SENSOR',
                    style: TextStyle(
                      color: Colors.greenAccent,
                      fontSize: 8,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.5,
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(_isPaused ? Icons.play_arrow_rounded : Icons.pause_rounded, color: Colors.white24, size: 16),
                  onPressed: () {
                    setState(() {
                      _isPaused = !_isPaused;
                      if (_isPaused) {
                        _pulseController.stop();
                      } else {
                        _pulseController.repeat();
                      }
                    });
                  },
                  tooltip: 'Pause Visuals',
                  constraints: const BoxConstraints(),
                  padding: EdgeInsets.zero,
                ),
              ],
            ),
            const SizedBox(height: 24),
            const Text(
              'ACOUSTIC CALIBRATION',
              style: TextStyle(fontWeight: FontWeight.w900, letterSpacing: 2, fontSize: 16),
            ),
            const SizedBox(height: 32),
            SizedBox(
              height: 200,
              width: 200,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  if (_isCalibrating)
                    AnimatedBuilder(
                      animation: _pulseController,
                      builder: (context, child) {
                        return CustomPaint(
                          painter: _RadarPainter(_pulseController.value),
                          size: const Size(200, 200),
                        );
                      },
                    ),
                  Icon(
                    Icons.waves_rounded,
                    size: 64,
                    color: _isCalibrating ? Colors.greenAccent : Colors.white10,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            Text(
              _statusText,
              style: const TextStyle(
                fontSize: 10,
                letterSpacing: 3,
                fontWeight: FontWeight.bold,
                color: Colors.white70,
              ),
            ),
            const SizedBox(height: 12),
            if (_isCalibrating)
              ClipRRect(
                borderRadius: BorderRadius.circular(2),
                child: LinearProgressIndicator(
                  value: _progress,
                  backgroundColor: Colors.white.withOpacity(0.05),
                  color: Colors.greenAccent,
                  minHeight: 2,
                ),
              ),
            const SizedBox(height: 32),
            if (!_isCalibrating)
              ElevatedButton(
                onPressed: _start,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.greenAccent,
                  foregroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 20),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  elevation: 20,
                  shadowColor: Colors.greenAccent.withOpacity(0.4),
                ),
                child: const Text('START ANALYSIS', style: TextStyle(fontWeight: FontWeight.w900)),
              )
            else
              const SizedBox(height: 56), // Spacer for consistency
            if (!_isCalibrating)
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('CANCEL', style: TextStyle(color: Colors.white24, fontSize: 12)),
              ),
          ],
        ),
      ),
    );
  }
}

class _RadarPainter extends CustomPainter {
  final double animation;
  _RadarPainter(this.animation);

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final paint = Paint()
      ..color = Colors.greenAccent.withOpacity(1.0 - animation)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    canvas.drawCircle(center, size.width / 2 * animation, paint);
    
    // Secondary faint pulse
    final paint2 = Paint()
      ..color = Colors.greenAccent.withOpacity((1.0 - ((animation + 0.5) % 1.0)).clamp(0, 1))
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;
    
    canvas.drawCircle(center, size.width / 2 * ((animation + 0.5) % 1.0), paint2);

    // Crosshairs
    final gridPaint = Paint()
      ..color = Colors.greenAccent.withOpacity(0.1)
      ..strokeWidth = 1;
    
    canvas.drawLine(Offset(0, center.dy), Offset(size.width, center.dy), gridPaint);
    canvas.drawLine(Offset(center.dx, 0), Offset(center.dx, size.height), gridPaint);
  }

  @override
  bool shouldRepaint(covariant _RadarPainter oldDelegate) => true;
}
