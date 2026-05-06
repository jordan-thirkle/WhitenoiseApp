import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:audio_service/audio_service.dart';
import 'package:quick_actions/quick_actions.dart';
import 'core/murmur_theme.dart';
import 'core/audio_engine_repository.dart';
import 'core/audio_handler.dart';
import 'features/home/home_screen.dart';
import 'features/onboarding/onboarding_screen.dart';
import 'features/audio/mix_controller.dart';
import 'core/iap_service.dart';
import 'core/play_services_helper.dart';

// Global audio handler
late AudioHandler audioHandler;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // 2026 Premium Utility: Edge-to-Edge / Android 16 Compliance
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    systemNavigationBarColor: Colors.transparent,
    statusBarColor: Colors.transparent,
    systemNavigationBarDividerColor: Colors.transparent,
    systemNavigationBarIconBrightness: Brightness.light,
    statusBarIconBrightness: Brightness.light,
  ));
  await SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);

  // Initialize Shared Preferences
  final prefs = await SharedPreferences.getInstance();
  final bool onboardingComplete = prefs.getBool('onboarding_complete') ?? false;
  
  // Initialize Intelligence Layer (native only — no web implementations)
  final iapService = IapService();
  
  try {
    if (!kIsWeb) {
      iapService.init(prefs);
      // Play Store Hardening: Check for updates on launch
      PlayServicesHelper.checkForUpdates();
    }
  } catch (e) {
    debugPrint('Critical: Service initialization failed: $e');
  }

  // Initialize Audio Engine
  final repository = AudioEngineRepository();
  await repository.init();

  // Initialize Audio Service (OS Integration — native only)
  if (!kIsWeb) {
    audioHandler = await AudioService.init(
      builder: () => MurmurAudioHandler(),
      config: const AudioServiceConfig(
        androidNotificationChannelId: 'com.jordanthirkle.murmur.channel.audio',
        androidNotificationChannelName: 'Murmur Playback',
        androidNotificationOngoing: true,
        androidStopForegroundOnPause: true,
      ),
    );
  }

  // Initialize Quick Actions (native only — no web support)
  if (!kIsWeb) {
    const QuickActions quickActions = QuickActions();
    quickActions.initialize((type) {
      if (type == 'action_rain') {
        repository.playSound('rain', 'assets/audio/pink_noise.ogg', volume: 0.6, tone: 0.4);
      }
    });
    quickActions.setShortcutItems(<ShortcutItem>[
      const ShortcutItem(type: 'action_rain', localizedTitle: 'Deep Rain', icon: 'icon_main'),
      const ShortcutItem(type: 'action_sleep', localizedTitle: 'Sleep Now', icon: 'icon_main'),
    ]);
  }

  runApp(
    ProviderScope(
      overrides: [
        sharedPrefsProvider.overrideWithValue(prefs),
        iapServiceProvider.overrideWithValue(iapService),
      ],
      child: MurmurApp(startScreen: onboardingComplete ? const HomeScreen() : const OnboardingScreen()),
    ),
  );
}

class MurmurApp extends StatelessWidget {
  final Widget startScreen;
  const MurmurApp({super.key, required this.startScreen});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Murmur',
      debugShowCheckedModeBanner: false,
      theme: MurmurTheme.darkTheme,
      home: startScreen,
    );
  }
}
