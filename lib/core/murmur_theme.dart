import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MurmurTheme {
  static const Color backgroundColor = Color(0xFF0D0F14);
  static const Color surfaceColor = Color(0xFF161A23);
  static const Color accentColor = Color(0xFF7BA7F5);
  static const Color textPrimary = Color(0xDEFFFFFF); // 0.87 opacity
  static const Color textSecondary = Color(0x99FFFFFF); // 0.60 opacity

  static Color get background => backgroundColor;
  static Color get surface => surfaceColor;
  static Color get accent => accentColor;
  static const Color secondaryText = textSecondary;
  static final TextStyle secondaryTextStyle = GoogleFonts.inter(color: textSecondary);

  static const double baseRadius = 28.0;
  static final BorderRadius cardRadius = BorderRadius.circular(24.0);
  static final BorderRadius dialogRadius = BorderRadius.circular(28.0);
  static final BorderRadius innerRadius = BorderRadius.circular(16.0);

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: backgroundColor,
      colorScheme: const ColorScheme.dark(
        primary: accentColor,
        secondary: accentColor,
        surface: surfaceColor,
        onSurface: textPrimary,
      ),
      textTheme: GoogleFonts.interTextTheme(
        ThemeData.dark().textTheme.copyWith(
          displayLarge: const TextStyle(color: textPrimary, fontWeight: FontWeight.bold),
          bodyLarge: const TextStyle(color: textPrimary),
          bodyMedium: const TextStyle(color: textSecondary),
        ),
      ),
      cardTheme: CardThemeData(
        color: surfaceColor,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: backgroundColor,
        elevation: 0,
        titleTextStyle: TextStyle(
          color: textPrimary,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
