import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'core/audio_engine_repository.dart';
import 'features/home/home_screen.dart';
import 'features/audio/mix_controller.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Shared Preferences
  final prefs = await SharedPreferences.getInstance();
  
  // Initialize Audio Engine
  final repository = AudioEngineRepository();
  await repository.init();

  runApp(
    ProviderScope(
      overrides: [
        sharedPrefsProvider.overrideWithValue(prefs),
      ],
      child: const MurmurApp(),
    ),
  );
}

class MurmurApp extends StatelessWidget {
  const MurmurApp({super.key});

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
      home: const HomeScreen(),
    );
  }
}
