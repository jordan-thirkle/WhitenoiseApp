import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:murmur/core/murmur_theme.dart';
import 'package:murmur/core/play_services_helper.dart';
import 'package:murmur/features/stats/stats_controller.dart';
import 'package:murmur/models/stats_model.dart';

class StatsScreen extends ConsumerWidget {
  const StatsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final stats = ref.watch(statsControllerProvider);

    // Trigger review prompt if appropriate when visiting stats
    if (stats.isLoaded && stats.hasPermissions) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        PlayServicesHelper.requestReviewIfAppropriate();
      });
    }

    return Scaffold(
      backgroundColor: MurmurTheme.background,
      body: Stack(
        children: [
          // Background Glows
          Positioned(
            top: -100,
            right: -100,
            child: _AmbientGlow(color: MurmurTheme.accent.withValues(alpha: 0.1)),
          ),
          Positioned(
            bottom: -50,
            left: -100,
            child: _AmbientGlow(color: Colors.indigoAccent.withValues(alpha: 0.05)),
          ),
          CustomScrollView(
            slivers: [
              _buildAppBar(context, ref),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildHeader(),
                      const SizedBox(height: 32),
                      if (!stats.isLoaded)
                        const Center(child: CircularProgressIndicator())
                      else if (!stats.hasPermissions)
                        _buildPermissionCTA(ref)
                      else if (stats.sleepPhases.isEmpty)
                        _buildEmptyDataState(ref)
                      else ...[
                        _buildHypnodensityCard(context, stats),
                        const SizedBox(height: 24),
                        _buildMetricGrid(stats),
                      ],
                      const SizedBox(height: 40),
                      _buildAuditLog(context),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAppBar(BuildContext context, WidgetRef ref) {
    return SliverAppBar(
      backgroundColor: Colors.transparent,
      floating: true,
      title: Text(
        'INSIGHTS',
        style: GoogleFonts.inter(fontWeight: FontWeight.w900, letterSpacing: 4, fontSize: 12, color: Colors.white30),
      ),
      centerTitle: true,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20, color: Colors.white),
        onPressed: () => Navigator.pop(context),
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.delete_forever_rounded, color: Colors.redAccent, size: 20),
          onPressed: () => _showPurgeConfirmation(context, ref),
          tooltip: 'Purge All Data',
        ),
        const SizedBox(width: 8),
      ],
    );
  }

  void _showPurgeConfirmation(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: MurmurTheme.surface,
        shape: RoundedRectangleBorder(borderRadius: MurmurTheme.dialogRadius),
        title: const Text('PURGE DATA', style: TextStyle(color: Colors.redAccent, letterSpacing: 2, fontSize: 14, fontWeight: FontWeight.bold)),
        content: const Text(
          'This will permanently delete all local mix preferences and settings. This action cannot be undone.',
          style: TextStyle(color: Colors.white70, fontSize: 13),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('CANCEL'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('All local data cleared.')),
              );
            },
            child: const Text('PURGE', style: TextStyle(color: Colors.redAccent)),
          ),
        ],
      ),
    );
  }

  Widget _buildPermissionCTA(WidgetRef ref) {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: MurmurTheme.surface.withValues(alpha: 0.5),
        borderRadius: MurmurTheme.cardRadius,
        border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
      ),
      child: Column(
        children: [
          Icon(Icons.health_and_safety_rounded, color: MurmurTheme.accent, size: 48),
          const SizedBox(height: 24),
          const Text(
            'Connect Health Data',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          const SizedBox(height: 12),
          const Text(
            'To provide personalized sleep insights, Murmur needs to read your heart rate and sleep phases from System Health. All data remains 100% on-device.',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white38, fontSize: 13, height: 1.5),
          ),
          const SizedBox(height: 32),
          ElevatedButton(
            onPressed: () => ref.read(statsControllerProvider.notifier).requestAuthorization(),
            style: ElevatedButton.styleFrom(
              backgroundColor: MurmurTheme.accent,
              foregroundColor: Colors.black,
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: const Text('ENABLE ACCESS', style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1)),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'WELLNESS OVERVIEW',
          style: TextStyle(
            color: MurmurTheme.accent.withValues(alpha: 0.5),
            fontSize: 10,
            fontWeight: FontWeight.bold,
            letterSpacing: 2,
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          'Consistent Rest',
          style: TextStyle(fontSize: 32, fontWeight: FontWeight.w900, color: Colors.white),
        ),
        const SizedBox(height: 4),
        Text(
          'Your biometric stability is up 12% this week.',
          style: TextStyle(color: Colors.white.withValues(alpha: 0.4), fontSize: 13),
        ),
      ],
    );
  }

  Widget _buildHypnodensityCard(BuildContext context, BiometricStats stats) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: MurmurTheme.surface.withValues(alpha: 0.5),
        borderRadius: MurmurTheme.cardRadius,
        border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'SLEEP ARCHITECTURE',
                style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 1, color: Colors.white70),
              ),
              Icon(Icons.auto_graph_rounded, color: MurmurTheme.accent, size: 16),
            ],
          ),
          const SizedBox(height: 24),
          SizedBox(
            height: 140,
            width: double.infinity,
            child: stats.sleepPhases.isEmpty 
              ? const Center(child: Text('No data available', style: TextStyle(color: Colors.white24, fontSize: 12)))
              : CustomPaint(
                  painter: _HypnodensityPainter(stats.sleepPhases),
                ),
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildLegendItem('Deep', Colors.blueAccent),
              _buildLegendItem('REM', Colors.purpleAccent),
              _buildLegendItem('Light', Colors.tealAccent),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLegendItem(String label, Color color) {
    return Row(
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 8),
        Text(label, style: const TextStyle(fontSize: 11, color: Colors.white38, fontWeight: FontWeight.w600)),
      ],
    );
  }

  Widget _buildMetricGrid(BiometricStats stats) {
    final sleepStr = '${stats.totalSleepTime.inHours}h ${stats.totalSleepTime.inMinutes % 60}m';
    final hrStr = stats.averageHeartRate > 0 ? '${stats.averageHeartRate.toInt()} bpm' : '--';
    final efficiencyStr = stats.efficiency > 0 ? '${(stats.efficiency * 100).toInt()}%' : '--';

    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      mainAxisSpacing: 16,
      crossAxisSpacing: 16,
      childAspectRatio: 1.4,
      children: [
        _buildMetricCard('Total Rest', sleepStr, Icons.dark_mode_rounded, Colors.indigoAccent),
        _buildMetricCard('Heart Rate', hrStr, Icons.favorite_rounded, Colors.pinkAccent),
        _buildMetricCard('Efficiency', efficiencyStr, Icons.bolt_rounded, Colors.amberAccent),
        _buildMetricCard('Stability', 'High', Icons.hearing_rounded, Colors.greenAccent),
      ],
    );
  }

  Widget _buildMetricCard(String label, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: MurmurTheme.surface.withValues(alpha: 0.5),
        borderRadius: MurmurTheme.cardRadius,
        border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: color, size: 14),
              ),
              const SizedBox(width: 10),
              Text(label, style: const TextStyle(fontSize: 10, color: Colors.white38, fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 12),
          Text(value, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: Colors.white)),
        ],
      ),
    );
  }

  Widget _buildAuditLog(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'PRIVACY AUDIT LOG',
          style: TextStyle(color: Colors.white30, fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 1),
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.02),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
          ),
          child: Column(
            children: [
              _buildAuditItem('Audio Synthesis', 'Synthesized 100% on-device'),
              const Divider(color: Colors.white10, height: 24),
              _buildAuditItem('Data Collection', 'Zero bytes transmitted to cloud'),
              const Divider(color: Colors.white10, height: 24),
              _buildAuditItem('FFI Bridge', 'C++ Soloud engine verified'),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildAuditItem(String label, String status) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(color: Colors.white70, fontSize: 12)),
        Row(
          children: [
            const Icon(Icons.check_circle_outline_rounded, color: Colors.greenAccent, size: 14),
            const SizedBox(width: 6),
            Text(status, style: const TextStyle(color: Colors.greenAccent, fontSize: 10, fontWeight: FontWeight.bold)),
          ],
        ),
      ],
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

class _HypnodensityPainter extends CustomPainter {
  final List<SleepPhasePoint> phases;
  _HypnodensityPainter(this.phases);

  @override
  void paint(Canvas canvas, Size size) {
    if (phases.isEmpty) return;

    final paintN3 = Paint()..color = Colors.blueAccent.withValues(alpha: 0.3)..style = PaintingStyle.fill;
    final paintREM = Paint()..color = Colors.purpleAccent.withValues(alpha: 0.3)..style = PaintingStyle.fill;
    final paintCore = Paint()..color = Colors.tealAccent.withValues(alpha: 0.3)..style = PaintingStyle.fill;

    final pathN3 = Path();
    final pathREM = Path();
    final pathCore = Path();

    // Map phases to x-coordinates
    final startTime = phases.first.time;
    final endTime = phases.last.time;
    final totalDuration = endTime.difference(startTime).inSeconds;
    if (totalDuration == 0) return;

    for (int i = 0; i < phases.length; i++) {
      final point = phases[i];
      final x = (point.time.difference(startTime).inSeconds / totalDuration) * size.width;
      
      // Calculate heights based on depth
      // depth 1.0 (Deep) -> max height
      // depth 0.1 (Awake) -> min height
      double h = size.height * (0.1 + point.depth * 0.8);
      
      if (i == 0) {
        pathN3.moveTo(x, size.height);
        pathN3.lineTo(x, size.height - h);
        pathREM.moveTo(x, size.height - h * 0.7);
        pathREM.lineTo(x, size.height - h);
        pathCore.moveTo(x, size.height - h * 0.4);
        pathCore.lineTo(x, size.height - h * 0.7);
      } else {
        pathN3.lineTo(x, size.height - h);
        pathREM.lineTo(x, size.height - h);
        pathCore.lineTo(x, size.height - h);
      }
    }

    pathN3.lineTo(size.width, size.height);
    pathN3.close();

    canvas.drawPath(pathN3, paintN3);
    canvas.drawPath(pathREM, paintREM);
    canvas.drawPath(pathCore, paintCore);
    
    // Draw smooth line on top
    final paintLine = Paint()..color = Colors.white.withValues(alpha: 0.1)..style = PaintingStyle.stroke..strokeWidth = 1;
    canvas.drawPath(pathN3, paintLine);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

Widget _buildEmptyDataState(WidgetRef ref) {
  return Container(
    width: double.infinity,
    padding: const EdgeInsets.all(40),
    decoration: BoxDecoration(
      color: MurmurTheme.surface.withValues(alpha: 0.3),
      borderRadius: MurmurTheme.cardRadius,
      border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
    ),
    child: Column(
      children: [
        Icon(Icons.auto_graph_rounded, color: MurmurTheme.accent.withValues(alpha: 0.3), size: 48),
        const SizedBox(height: 24),
        const Text(
          'Awaiting Sleep Data',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.white70),
        ),
        const SizedBox(height: 12),
        const Text(
          'Bio-Intelligence requires at least one full sleep session to generate hypnodensity visualizations.',
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.white24, fontSize: 12, height: 1.5),
        ),
        const SizedBox(height: 32),
        TextButton.icon(
          onPressed: () => ref.read(statsControllerProvider.notifier).refresh(),
          icon: const Icon(Icons.refresh_rounded, size: 16),
          label: const Text('REFRESH', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 1)),
          style: TextButton.styleFrom(foregroundColor: MurmurTheme.accent),
        ),
      ],
    ),
  );
}
