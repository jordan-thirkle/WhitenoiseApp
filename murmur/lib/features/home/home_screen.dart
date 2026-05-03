import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:murmur/core/murmur_theme.dart';
import 'package:murmur/models/sound_model.dart';
import 'package:murmur/features/audio/sound_card_controller.dart';
import 'package:url_launcher/url_launcher.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: MurmurTheme.backgroundColor,
      body: Stack(
        children: [
          // Background Gradient (Optimized for OLED)
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  MurmurTheme.backgroundColor,
                  Color(0xFF0A0C11),
                ],
              ),
            ),
          ),
          
          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(context),
                const Expanded(
                  child: SoundGrid(),
                ),
                _buildMasterControl(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "Murmur",
            style: Theme.of(context).textTheme.displayLarge?.copyWith(
              color: MurmurTheme.accentColor,
              letterSpacing: -1,
              fontWeight: FontWeight.w800,
            ),
          ),
          IconButton(
            onPressed: () => _showAboutDialog(context),
            icon: const Icon(Icons.info_outline, color: MurmurTheme.textSecondary),
            tooltip: 'About Murmur',
          ),
        ],
      ),
    );
  }

  Widget _buildMasterControl() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: MurmurTheme.surfaceColor.withOpacity(0.4),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
        border: Border.all(color: Colors.white.withOpacity(0.03)),
      ),
      child: Row(
        children: [
          const Expanded(
            child: Text(
              "MULTI-TRACK MIXER",
              style: TextStyle(
                color: MurmurTheme.textSecondary,
                fontSize: 10,
                fontWeight: FontWeight.w900,
                letterSpacing: 2.0,
              ),
            ),
          ),
          TextButton.icon(
            onPressed: () {
              // TODO: Implement "Stop All"
            },
            icon: const Icon(Icons.stop_rounded, size: 16, color: Colors.redAccent),
            label: const Text("STOP ALL", style: TextStyle(color: Colors.redAccent, fontSize: 10)),
          ),
        ],
      ),
    );
  }

  void _showAboutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => const SettingsDialog(),
    );
  }
}

class SoundGrid extends StatelessWidget {
  const SoundGrid({super.key});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 16,
        crossAxisSpacing: 16,
        childAspectRatio: 0.85, // Taller for sliders
      ),
      itemCount: availableSounds.length,
      itemBuilder: (context, index) {
        return SoundCard(sound: availableSounds[index]);
      },
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

    return GestureDetector(
      onTap: controller.toggle,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        decoration: BoxDecoration(
          color: state.isActive 
              ? MurmurTheme.surfaceColor.withOpacity(0.7) 
              : MurmurTheme.surfaceColor.withOpacity(0.3),
          borderRadius: BorderRadius.circular(28),
          border: Border.all(
            color: state.isActive 
                ? MurmurTheme.accentColor.withOpacity(0.3) 
                : Colors.white.withOpacity(0.04),
            width: 1.5,
          ),
          boxShadow: state.isActive ? [
            BoxShadow(
              color: MurmurTheme.accentColor.withOpacity(0.1),
              blurRadius: 20,
              spreadRadius: -5,
            )
          ] : [],
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Icon & Title
              Row(
                children: [
                  Text(sound.icon, style: const TextStyle(fontSize: 24)),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      sound.name,
                      style: TextStyle(
                        color: state.isActive ? MurmurTheme.textPrimary : MurmurTheme.textSecondary,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              
              // Sliders (Mini-Mixer)
              if (state.isActive) ...[
                _buildSliderRow(
                  icon: Icons.volume_up_rounded,
                  value: state.volume,
                  onChanged: controller.setVolume,
                  color: MurmurTheme.accentColor,
                ),
                _buildSliderRow(
                  icon: Icons.graphic_eq_rounded,
                  value: state.tone,
                  onChanged: controller.setTone,
                  color: Colors.amberAccent.withOpacity(0.7),
                ),
              ] else ...[
                const Expanded(
                  child: Center(
                    child: Icon(
                      Icons.power_settings_new_rounded,
                      color: MurmurTheme.textSecondary,
                      size: 32,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSliderRow({
    required IconData icon,
    required double value,
    required ValueChanged<double> onChanged,
    required Color color,
  }) {
    return Row(
      children: [
        Icon(icon, size: 14, color: MurmurTheme.textSecondary.withOpacity(0.5)),
        Expanded(
          child: SliderTheme(
            data: SliderThemeData(
              trackHeight: 2,
              thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 6),
              overlayShape: const RoundSliderOverlayShape(overlayRadius: 12),
              activeTrackColor: color,
              inactiveTrackColor: Colors.white.withOpacity(0.05),
              thumbColor: Colors.white,
            ),
            child: Slider(
              value: value,
              onChanged: onChanged,
            ),
          ),
        ),
      ],
    );
  }
}

class SettingsDialog extends StatelessWidget {
  const SettingsDialog({super.key});

  Future<void> _launchURL(String urlString) async {
    final Uri url = Uri.parse(urlString);
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      throw Exception('Could not launch $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
      child: AlertDialog(
        backgroundColor: MurmurTheme.surfaceColor.withOpacity(0.9),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: const Text(
          "About Murmur",
          style: TextStyle(color: MurmurTheme.textPrimary, fontWeight: FontWeight.bold),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              "Premium white noise for the whole family. No tracking, no data collection, just sleep.",
              style: TextStyle(color: MurmurTheme.textSecondary),
            ),
            const SizedBox(height: 24),
            _buildLink(context, "Privacy Policy", "https://jordan-thirkle-com.vercel.app/murmur/privacy"),
            _buildLink(context, "Terms of Service", "https://jordan-thirkle-com.vercel.app/murmur/terms"),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Close", style: TextStyle(color: MurmurTheme.accentColor)),
          ),
        ],
      ),
    );
  }

  Widget _buildLink(BuildContext context, String title, String url) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      title: Text(title, style: const TextStyle(color: MurmurTheme.accentColor)),
      trailing: const Icon(Icons.open_in_new, color: MurmurTheme.accentColor, size: 18),
      onTap: () => _launchURL(url),
    );
  }
}
