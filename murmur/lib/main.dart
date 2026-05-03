import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:audio_service/audio_service.dart';
import 'core/audio_engine_repository.dart';
import 'core/audio_handler.dart';
import 'features/home/home_screen.dart';
import 'features/onboarding/onboarding_screen.dart';
import 'features/audio/mix_controller.dart';

// Global audio handler
late AudioHandler audioHandler;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Shared Preferences
  final prefs = await SharedPreferences.getInstance();
  final bool onboardingComplete = prefs.getBool('onboarding_complete') ?? false;
  
  // Initialize Audio Engine
  final repository = AudioEngineRepository();
  await repository.init();

  // Initialize Audio Service (OS Integration)
  audioHandler = await AudioService.init(
    builder: () => MurmurAudioHandler(),
    config: const AudioServiceConfig(
      androidNotificationChannelId: 'com.jordanthirkle.murmur.channel.audio',
      androidNotificationChannelName: 'Murmur Playback',
      androidNotificationOngoing: true,
      androidStopForegroundOnPause: true,
    ),
  );

  runApp(
    ProviderScope(
      overrides: [
        sharedPrefsProvider.overrideWithValue(prefs),
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
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF0D0F14),
        textTheme: GoogleFonts.interTextTheme(
          ThemeData.dark().textTheme,
        ),
        useMaterial3: true,
      ),
      home: startScreen,
    );
  }
}
