import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Pastel Palette
  static const Color background = Color(0xFFF4F6FD); // Soft Blue-White
  static const Color surface = Colors.white;

  static const Color primary = Color(0xFF8B80F9); // Soft Periwinkle
  static const Color secondary = Color(0xFFFFC3A0); // Soft Peach
  static const Color tertiary = Color(0xFFA0E7E5); // Minty Blue

  static const Color accentYellow = Color(0xFFFFE5B4); // Creamy Yellow
  static const Color accentPink = Color(0xFFFF9AA2); // Soft Pink
  static const Color accentGreen = Color(0xFFB5EAD7); // Soft Mint

  static const List<Color> accountGradient = [
    Color(0xFFE0F7FA), // Very light Cyan
    Color(0xFFF3E5F5), // Very light Purple
    Color(0xFFFFF3E0), // Very light Orange
  ];

  static const Color textPrimary = Color(0xFF2D3142); // Dark Blue-Grey
  static const Color textSecondary = Color(0xFF9C9EB9); // Light Grey-Blue

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: background,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primary,

        surface: surface,
        primary: primary,
        secondary: secondary,
        tertiary: tertiary,
      ),
      textTheme: GoogleFonts.quicksandTextTheme().apply(
        bodyColor: textPrimary,
        displayColor: textPrimary,
      ),
      // CardTheme removed due to type mismatch issues
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
          color: textPrimary,
          fontSize: 22,
          fontWeight: FontWeight.bold,
          fontFamily: 'Quicksand',
        ),
        iconTheme: IconThemeData(color: textPrimary),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primary,
          foregroundColor: Colors.white,
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: primary,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: surface,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: Colors.transparent),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: primary, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 16,
        ),
        hintStyle: TextStyle(color: textSecondary.withValues(alpha: 0.7)),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: surface,
        elevation: 10,
        shadowColor: Colors.black.withValues(alpha: 0.1),
        indicatorColor: primary.withValues(alpha: 0.2),
        labelTextStyle: WidgetStateProperty.all(
          const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }

  // Dark Mode Palette
  static const Color darkBackground = Color(0xFF1A1C29); // Deep Navy
  static const Color darkSurface = Color(0xFF252836); // Slightly lighter Navy
  static const Color darkPrimary = Color(0xFF9B8FFF); // Brighter Periwinkle
  static const Color darkSecondary = Color(0xFFFFD4B8); // Warm Peach
  static const Color darkTertiary = Color(0xFFB0F0ED); // Bright Mint

  static const Color darkTextPrimary = Color(0xFFE8EAF6); // Soft White
  static const Color darkTextSecondary = Color(0xFF9FA2B4); // Muted Grey

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: darkBackground,
      colorScheme: ColorScheme.fromSeed(
        seedColor: darkPrimary,
        brightness: Brightness.dark,
        surface: darkSurface,
        primary: darkPrimary,
        secondary: darkSecondary,
        tertiary: darkTertiary,
      ),
      textTheme: GoogleFonts.quicksandTextTheme().apply(
        bodyColor: darkTextPrimary,
        displayColor: darkTextPrimary,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
          color: darkTextPrimary,
          fontSize: 22,
          fontWeight: FontWeight.bold,
          fontFamily: 'Quicksand',
        ),
        iconTheme: IconThemeData(color: darkTextPrimary),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: darkPrimary,
          foregroundColor: darkBackground,
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: darkPrimary,
        foregroundColor: darkBackground,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: darkSurface,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: Colors.transparent),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: darkPrimary, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 16,
        ),
        hintStyle: TextStyle(color: darkTextSecondary.withValues(alpha: 0.7)),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: darkSurface,
        elevation: 10,
        shadowColor: Colors.black.withValues(alpha: 0.3),
        indicatorColor: darkPrimary.withValues(alpha: 0.2),
        labelTextStyle: WidgetStateProperty.all(
          const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: darkTextPrimary,
          ),
        ),
      ),
      cardTheme: const CardThemeData(
        color: darkSurface,
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(16)),
        ),
      ),
    );
  }
}
