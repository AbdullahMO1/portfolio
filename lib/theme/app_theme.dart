import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Royal palette and Material 3 theming for the portfolio.
/// Colors: Imperial Navy, Gold, Deep Slate, and Desert accents.
class AppTheme {
  // Persian Dessert Palette
  static const Color saffron = Color(0xFFD4AF37); // Base Saffron
  static const Color saffronLight = Color(
    0xFFFDF5E6,
  ); // Creamy Saffron background
  static const Color pistachio = Color(0xFF93C572); // Pistachio Green
  static const Color rosewater = Color(0xFFF4C2C2); // Rosewater Pink
  static const Color cardamon = Color(0xFF8B7D6B); // Cardamon Brown (muted)
  static const Color pomegranate = Color(
    0xFFC0392B,
  ); // Pomegranate Red (accent)
  static const Color deepNavy = Color(
    0xFF0A1128,
  ); // Contrast for text in dark mode
  static const Color parchment = Color(0xFFE8DCC8); // Warm parchment for body text
  static const Color ivoryGold = Color(0xFFF0E6C8); // Light gold for secondary text

  /// Story title style — Amiri calligraphic serif.
  static TextStyle storyTitleStyle({
    double fontSize = 48,
    Color color = saffron,
  }) => GoogleFonts.amiri(
    fontSize: fontSize,
    fontWeight: FontWeight.w700,
    color: color,
    letterSpacing: 0.5,
    height: 1.2,
  );

  /// Story subtitle / narrative style — Newsreader.
  static TextStyle narrativeStyle({
    double fontSize = 18,
    Color color = ivoryGold,
  }) => GoogleFonts.newsreader(
    fontSize: fontSize,
    fontWeight: FontWeight.w400,
    fontStyle: FontStyle.italic,
    color: color,
    height: 1.6,
  );

  static ThemeData get dark {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: const ColorScheme.dark(
        primary: saffron,
        onPrimary: deepNavy,
        secondary: pistachio,
        onSecondary: deepNavy,
        tertiary: rosewater,
        surface: deepNavy,
        onSurface: saffronLight,
        onSurfaceVariant: parchment,
        surfaceContainerHigh: Color(0xFF141D3B),
        outline: cardamon,
      ),
      scaffoldBackgroundColor: deepNavy,

      textTheme: GoogleFonts.newsreaderTextTheme(
        const TextTheme(
          headlineLarge: TextStyle(
            fontSize: 56,
            fontWeight: FontWeight.w900,
            color: saffron,
            letterSpacing: -1.0,
          ),
          headlineMedium: TextStyle(
            fontSize: 36,
            fontWeight: FontWeight.w800,
            color: ivoryGold,
            letterSpacing: -0.5,
          ),
          titleLarge: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.w700,
            color: saffronLight,
          ),
          bodyLarge: TextStyle(
            fontSize: 20,
            height: 1.6,
            color: parchment,
          ),
          bodyMedium: TextStyle(
            fontSize: 18,
            height: 1.5,
            color: parchment,
          ),
          bodySmall: TextStyle(
            fontSize: 14,
            height: 1.5,
            color: ivoryGold,
          ),
          labelLarge: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            letterSpacing: 1.2,
            color: saffron,
          ),
        ),
      ),

      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: saffron,
          foregroundColor: deepNavy,
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 18),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(999),
          ),
          textStyle: const TextStyle(
            fontWeight: FontWeight.w700,
            letterSpacing: 1.2,
          ),
        ),
      ),

      cardTheme: CardThemeData(
        color: const Color(0xFF141D3B),
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
          side: BorderSide(color: saffron.withValues(alpha: 0.1)),
        ),
      ),

      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: deepNavy.withValues(alpha: 0.95),
        indicatorColor: saffron.withValues(alpha: 0.15),
        labelBehavior: NavigationDestinationLabelBehavior.onlyShowSelected,
      ),
    );
  }

  static ThemeData get light {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: const ColorScheme.light(
        primary: saffron,
        onPrimary: Colors.white,
        secondary: pistachio,
        onSecondary: Colors.white,
        tertiary: pomegranate,
        surface: saffronLight,
        onSurface: deepNavy,
        onSurfaceVariant: Color(0xFF3D2E1A),
        surfaceContainerHigh: Color(0xFFF5EFE0),
        outline: cardamon,
      ),
      scaffoldBackgroundColor: saffronLight,

      textTheme: GoogleFonts.newsreaderTextTheme(
        const TextTheme(
          headlineLarge: TextStyle(
            fontSize: 56,
            fontWeight: FontWeight.w900,
            color: deepNavy,
            letterSpacing: -1.0,
          ),
          headlineMedium: TextStyle(
            fontSize: 36,
            fontWeight: FontWeight.w800,
            color: cardamon,
            letterSpacing: -0.5,
          ),
          titleLarge: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.w700,
            color: deepNavy,
          ),
          bodyLarge: TextStyle(
            fontSize: 20,
            height: 1.6,
            color: Color(0xFF333333),
          ),
          bodyMedium: TextStyle(
            fontSize: 18,
            height: 1.5,
            color: Color(0xFF333333),
          ),
          labelLarge: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            letterSpacing: 1.2,
            color: saffron,
          ),
        ),
      ),

      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: saffron,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 18),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(999),
          ),
          textStyle: const TextStyle(
            fontWeight: FontWeight.w700,
            letterSpacing: 1.2,
          ),
        ),
      ),

      cardTheme: CardThemeData(
        color: Colors.white,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
          side: BorderSide(color: saffron.withValues(alpha: 0.1)),
        ),
      ),

      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: saffronLight.withValues(alpha: 0.95),
        indicatorColor: saffron.withValues(alpha: 0.1),
        labelBehavior: NavigationDestinationLabelBehavior.onlyShowSelected,
      ),
    );
  }
}
