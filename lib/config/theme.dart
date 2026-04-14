import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Centralized app theme configuration for Qotton Shop.
class AppTheme {
  // Prevent instantiation
  AppTheme._();

  // ── Brand Colors ──────────────────────────────────────────────────────
  static const Color qottonBrown = Color(0xFF8A5A44);
  static const Color lightBrown = Color(0xFF9C6644);
  static const Color backgroundBrown = Color(0xFFB08968);
  static const Color deepDarkBrown = Color(0xFF351C10);

  // ── Dark Theme (primary) ──────────────────────────────────────────────
  static ThemeData get darkTheme {
    return ThemeData.dark().copyWith(
      colorScheme: ColorScheme.fromSeed(
        brightness: Brightness.dark,
        seedColor: qottonBrown,
        primary: qottonBrown,
        surface: lightBrown,
        onSurface: Colors.white,
      ),
      scaffoldBackgroundColor: backgroundBrown,
      textTheme: GoogleFonts.cairoTextTheme(
        const TextTheme(
          bodyLarge: TextStyle(color: Colors.white),
          bodyMedium: TextStyle(color: Colors.white70),
          titleLarge: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          headlineMedium: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          labelLarge: TextStyle(color: Colors.white),
        ),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: backgroundBrown,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        titleTextStyle: GoogleFonts.cairo(
          color: Colors.white,
          fontSize: 22,
          fontWeight: FontWeight.bold,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: qottonBrown,
          foregroundColor: Colors.white,
          elevation: 5,
          padding: const EdgeInsets.symmetric(vertical: 16),
          textStyle: GoogleFonts.cairo(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: lightBrown,
        labelStyle: GoogleFonts.cairo(color: Colors.white70),
        hintStyle: GoogleFonts.cairo(color: Colors.white54),
        prefixIconColor: Colors.white70,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: qottonBrown, width: 2),
        ),
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: deepDarkBrown,
        contentTextStyle: GoogleFonts.cairo(color: Colors.white),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  // ── Light Theme (fallback) ────────────────────────────────────────────
  static ThemeData get lightTheme {
    return ThemeData(
      colorScheme: ColorScheme.fromSeed(
        seedColor: qottonBrown,
        primary: qottonBrown,
      ),
      textTheme: GoogleFonts.cairoTextTheme(),
      useMaterial3: true,
    );
  }
}
