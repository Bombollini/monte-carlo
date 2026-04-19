import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static const Color background = Color(0xFF050506);
  static const Color surface = Color(0xFF121214);
  static const Color neonGreen = Color(0xFF00E676);
  static const Color vibrantRed = Color(0xFFFF5252);
  static const Color digitalGold = Color(0xFFFFD600);
  
  static ThemeData get darkTheme {
    return ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: background,
      primaryColor: digitalGold,
      colorScheme: const ColorScheme.dark(
        primary: digitalGold,
        surface: surface,
        background: background,
      ),
      textTheme: GoogleFonts.interTextTheme(ThemeData.dark().textTheme).copyWith(
        displayLarge: GoogleFonts.jetBrainsMono(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
        displayMedium: GoogleFonts.jetBrainsMono(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
        bodyLarge: const TextStyle(color: Colors.white),
      ),
      cardTheme: CardThemeData(
        color: surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: Colors.white.withOpacity(0.05), width: 1),
        ),
        elevation: 0,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
      ),
    );
  }
}
