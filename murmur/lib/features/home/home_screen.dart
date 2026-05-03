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
import 'package:url_launcher/url_launcher.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
              _buildAppBar(context, ref),
              _buildMixerHeader(context, ref),
              _buildSoundGrid(context, ref),
              const SliverPadding(padding: EdgeInsets.only(bottom: 120)),
            ],
          ),
        ],
      ),
      bottomNavigationBar: _buildBottomBar(context, ref),
    );
  }

  Widget _buildAppBar(BuildContext context, WidgetRef ref) {
    return SliverAppBar(
      backgroundColor: Colors.transparent,
      floating: true,
      centerTitle: false,
      title: Text(
        'Murmur',
        style: TextStyle(
          fontSize: 48,
          fontWeight: FontWeight.w900,
          color: MurmurTheme.accent.withOpacity(0.8),
          letterSpacing: -2,
        ),
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.info_outline_rounded, color: Colors.white70),
          onPressed: () => _showAboutDialog(context),
        ),
        const SizedBox(width: 8),
      ],
    );
  }

  Widget _buildMixerHeader(BuildContext context, WidgetRef ref) {
    final timerState = ref.watch(timerControllerProvider);

    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
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
                  icon: Icon(
                    timerState.isRunning ? Icons.timer_rounded : Icons.timer_outlined,
                    color: timerState.isRunning ? MurmurTheme.accent : Colors.white30,
                  ),
                  onPressed: () => _showTimerSheet(context, ref),
                ),
                IconButton(
                  icon: const Icon(Icons.star_border_rounded, color: Color(0xFF7BA7F5)),
                  onPressed: () => _showFavoritesSheet(context, ref),
                ),
                TextButton.icon(
                  onPressed: () {
                    ref.read(audioEngineProvider).stopAll();
                    ref.read(timerControllerProvider.notifier).cancelTimer();
                  },
                  icon: const Icon(Icons.stop_rounded, size: 16, color: Colors.redAccent),
                  label: const Text(
                    'STOP ALL',
                    style: TextStyle(
                      color: Colors.redAccent,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
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

  Widget _buildSoundGrid(BuildContext context, WidgetRef ref) {
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
            return SoundCard(sound: sound);
          },
          childCount: availableSounds.length,
        ),
      ),
    );
  }

  Widget _buildBottomBar(BuildContext context, WidgetRef ref) {
    return Container(
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
  const SoundCard({super.key, required this.sound});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(soundCardProvider(sound.assetPath));
    final controller = ref.read(soundCardProvider(sound.assetPath).notifier);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeOutExpo,
      decoration: BoxDecoration(
        color: MurmurTheme.surface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: state.isActive ? MurmurTheme.accent.withOpacity(0.5) : Colors.white.withOpacity(0.05),
          width: 2,
        ),
        boxShadow: state.isActive ? [
          BoxShadow(
            color: MurmurTheme.accent.withOpacity(0.15),
            blurRadius: 25,
            spreadRadius: 2,
          )
        ] : [],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: Column(
          children: [
            Expanded(
              child: GestureDetector(
                onTap: () {
                  HapticFeedback.mediumImpact();
                  controller.toggle();
                },
                behavior: HitTestBehavior.opaque,
                child: Container(
                  width: double.infinity,
                  child: Column(
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
                          state.isActive ? Icons.pause_rounded : Icons.power_settings_new_rounded,
                          key: ValueKey(state.isActive),
                          color: state.isActive ? MurmurTheme.accent : Colors.white24,
                          size: 32,
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

    if (widget.isActive) _controller.repeat(reverse: true);
  }

  @override
  void didUpdateWidget(_PulseIcon oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isActive != oldWidget.isActive) {
      if (widget.isActive) {
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

class SettingsDialog extends StatelessWidget {
  const SettingsDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
      child: AlertDialog(
        backgroundColor: MurmurTheme.surface.withOpacity(0.9),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
        title: const Text('Murmur', style: TextStyle(fontWeight: FontWeight.w900)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildLink(context, 'Privacy Policy', 'https://jordan-thirkle-com.vercel.app/murmur/privacy'),
            _buildLink(context, 'Terms of Service', 'https://jordan-thirkle-com.vercel.app/murmur/terms'),
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
