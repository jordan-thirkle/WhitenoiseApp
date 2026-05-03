import 'package:flutter/material.dart';
import 'package:murmur/core/murmur_theme.dart';
import 'package:murmur/features/home/home_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../audio/mix_controller.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _controller = PageController();
  int _currentPage = 0;

  final List<OnboardingData> _pages = [
    OnboardingData(
      title: 'SCIENTIFIC SLEEP',
      description: 'Medical-grade ambient audio designed to mask disruptive noise and stabilize sleep cycles.',
      icon: '🧬',
    ),
    OnboardingData(
      title: 'ZERO-DATA PRIVACY',
      description: 'Your sleep is your business. No tracking, no cloud syncing, no data collection. Ever.',
      icon: '🛡️',
    ),
    OnboardingData(
      title: 'PREMIUM ENGINE',
      description: 'Sample-accurate loops and real-time DSP filters powered by a high-performance C++ engine.',
      icon: '⚡',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MurmurTheme.background,
      body: Stack(
        children: [
          PageView.builder(
            controller: _controller,
            itemCount: _pages.length,
            onPageChanged: (idx) => setState(() => _currentPage = idx),
            itemBuilder: (context, idx) => _OnboardingPage(data: _pages[idx]),
          ),
          Positioned(
            bottom: 60,
            left: 24,
            right: 24,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(_pages.length, (idx) => _buildDot(idx)),
                ),
                const SizedBox(height: 40),
                _currentPage == _pages.length - 1
                    ? _buildPaywallButton()
                    : _buildNextButton(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDot(int index) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: const EdgeInsets.symmetric(horizontal: 4),
      height: 8,
      width: _currentPage == index ? 24 : 8,
      decoration: BoxDecoration(
        color: _currentPage == index ? MurmurTheme.accent : Colors.white10,
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }

  Widget _buildNextButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () => _controller.nextPage(
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeOutExpo,
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          padding: const EdgeInsets.symmetric(vertical: 18),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        ),
        child: const Text('CONTINUE', style: TextStyle(fontWeight: FontWeight.bold)),
      ),
    );
  }

  Widget _buildPaywallButton() {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () => _completeOnboarding(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: MurmurTheme.accent,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 18),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            ),
            child: const Text('UNLOCK PREMIUM — \$9.99', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
        ),
        const SizedBox(height: 16),
        TextButton(
          onPressed: () => _completeOnboarding(context),
          child: const Text('OR START FREE TRIAL', style: TextStyle(color: Colors.white30, fontSize: 12)),
        ),
      ],
    );
  }

  void _completeOnboarding(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('onboarding_complete', true);
    if (!mounted) return;
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const HomeScreen()),
    );
  }
}

class _OnboardingPage extends StatelessWidget {
  final OnboardingData data;
  const _OnboardingPage({required this.data});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(40),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(data.icon, style: const TextStyle(fontSize: 80)),
          const SizedBox(height: 40),
          Text(
            data.title,
            style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w900, letterSpacing: -1),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          Text(
            data.description,
            style: TextStyle(fontSize: 16, color: Colors.white.withOpacity(0.5), height: 1.5),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class OnboardingData {
  final String title;
  final String description;
  final String icon;
  OnboardingData({required this.title, required this.description, required this.icon});
}
