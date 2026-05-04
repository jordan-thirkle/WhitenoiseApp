import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:murmur/core/murmur_theme.dart';
import 'package:murmur/core/health_service.dart';
import 'package:murmur/core/purge_service.dart';

class StatsScreen extends ConsumerWidget {
  const StatsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: MurmurTheme.background,
      body: CustomScrollView(
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
                  _buildHypnodensityCard(context),
                  const SizedBox(height: 24),
                  _buildMetricGrid(),
                  const SizedBox(height: 24),
                  _buildClinicalMoat(context, ref),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAppBar(BuildContext context, WidgetRef ref) {
    return SliverAppBar(
      backgroundColor: Colors.transparent,
      floating: true,
      title: const Text(
        'INSIGHTS',
        style: TextStyle(fontWeight: FontWeight.w900, letterSpacing: 4, fontSize: 14),
      ),
      centerTitle: true,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
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
        title: const Text('RIGHT TO DISAPPEAR', style: TextStyle(color: Colors.redAccent, letterSpacing: 2, fontSize: 14, fontWeight: FontWeight.bold)),
        content: const Text(
          'This will permanently delete all local biometric logs, recovery metrics, and preferences. This action cannot be undone.',
          style: TextStyle(color: Colors.white70, fontSize: 13),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('CANCEL'),
          ),
          TextButton(
            onPressed: () async {
              await ref.read(purgeServiceProvider).purgeAllData();
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('All data purged. Sovereignty restored.')),
              );
            },
            child: const Text('PURGE ALL DATA', style: TextStyle(color: Colors.redAccent)),
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
          'LAST SESSION',
          style: TextStyle(
            color: MurmurTheme.accent.withOpacity(0.5),
            fontSize: 10,
            fontWeight: FontWeight.bold,
            letterSpacing: 2,
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          'Recovery Quality: 84%',
          style: TextStyle(fontSize: 32, fontWeight: FontWeight.w900),
        ),
      ],
    );
  }

  Widget _buildHypnodensityCard(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: MurmurTheme.surface,
        borderRadius: MurmurTheme.cardRadius,
        border: Border.all(color: Colors.white.withOpacity(0.05)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'PROBABILISTIC HYPNODENSITY',
                style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 1),
              ),
              Icon(Icons.auto_graph_rounded, color: MurmurTheme.accent, size: 16),
            ],
          ),
          const SizedBox(height: 24),
          SizedBox(
            height: 120,
            width: double.infinity,
            child: CustomPaint(
              painter: _HypnodensityPainter(),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildLegendItem('N3 (Deep)', Colors.blueAccent),
              _buildLegendItem('REM', Colors.purpleAccent),
              _buildLegendItem('CORE', Colors.tealAccent),
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
        const SizedBox(width: 6),
        Text(label, style: const TextStyle(fontSize: 10, color: Colors.white38)),
      ],
    );
  }

  Widget _buildMetricGrid() {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      mainAxisSpacing: 16,
      crossAxisSpacing: 16,
      childAspectRatio: 1.5,
      children: [
        _buildMetricCard('Avg SpO2', '96%', Icons.bloodtype_rounded, Colors.redAccent),
        _buildMetricCard('Heart Rate', '54 bpm', Icons.favorite_rounded, Colors.pinkAccent),
        _buildMetricCard('Delta Power', '+12%', Icons.bolt_rounded, Colors.amberAccent),
        _buildMetricCard('CLAS Hits', '242', Icons.hearing_rounded, Colors.greenAccent),
      ],
    );
  }

  Widget _buildClinicalMoat(BuildContext context, WidgetRef ref) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: MurmurTheme.surface,
        borderRadius: MurmurTheme.cardRadius,
        border: Border.all(color: Colors.amberAccent.withOpacity(0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.verified_rounded, color: Colors.amberAccent, size: 14),
              const SizedBox(width: 8),
              const Text(
                'FDA SaMD STATUS: PCCP-CERTIFIED',
                style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 1, color: Colors.amberAccent),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            'Real-World Evidence (RWE) Confidence: 99.1%',
            style: TextStyle(fontSize: 12, color: Colors.white.withOpacity(0.6)),
          ),
          const SizedBox(height: 4),
          Text(
            'Next autonomous AI weight sync: Scheduled (May 2026)',
            style: TextStyle(fontSize: 10, color: Colors.white.withOpacity(0.3)),
          ),
        ],
      ),
    );
  }

  Widget _buildMetricCard(String label, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: MurmurTheme.surface,
        borderRadius: MurmurTheme.cardRadius,
        border: Border.all(color: Colors.white.withOpacity(0.05)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            children: [
              Icon(icon, color: color.withOpacity(0.5), size: 14),
              const SizedBox(width: 8),
              Text(label, style: const TextStyle(fontSize: 10, color: Colors.white38)),
            ],
          ),
          const SizedBox(height: 4),
          Text(value, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}

class _HypnodensityPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paintN3 = Paint()..color = Colors.blueAccent.withOpacity(0.4)..style = PaintingStyle.fill;
    final paintREM = Paint()..color = Colors.purpleAccent.withOpacity(0.4)..style = PaintingStyle.fill;
    final paintCore = Paint()..color = Colors.tealAccent.withOpacity(0.4)..style = PaintingStyle.fill;

    final pathN3 = Path();
    final pathREM = Path();
    final pathCore = Path();

    // Simulated probabilistic wave
    for (double i = 0; i <= size.width; i++) {
      double x = i;
      double yN3 = size.height * (0.6 + 0.2 * (i / size.width));
      double yREM = size.height * (0.3 + 0.1 * (1 - i / size.width));
      double yCore = size.height * 0.1;

      if (i == 0) {
        pathN3.moveTo(x, size.height);
        pathN3.lineTo(x, size.height - yN3);
        pathREM.moveTo(x, size.height - yN3);
        pathREM.lineTo(x, size.height - yN3 - yREM);
        pathCore.moveTo(x, size.height - yN3 - yREM);
        pathCore.lineTo(x, size.height - yN3 - yREM - yCore);
      } else {
        pathN3.lineTo(x, size.height - yN3);
        pathREM.lineTo(x, size.height - yN3 - yREM);
        pathCore.lineTo(x, size.height - yN3 - yREM - yCore);
      }
    }

    pathN3.lineTo(size.width, size.height);
    pathN3.close();

    // Since we are stacking, we need to draw them in order
    canvas.drawPath(pathN3, paintN3);
    canvas.drawPath(pathREM, paintREM);
    canvas.drawPath(pathCore, paintCore);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
