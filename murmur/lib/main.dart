import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:murmur/core/audio_engine_repository.dart';
import 'package:murmur/core/murmur_theme.dart';
import 'package:murmur/features/home/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize the C++ Audio Engine
  final repository = AudioEngineRepository();
  await repository.init();

  runApp(
    const ProviderScope(
      child: MurmurApp(),
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
      theme: MurmurTheme.darkTheme,
      home: const HomeScreen(),
    );
  }
}
