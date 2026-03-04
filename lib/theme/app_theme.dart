import 'package:flutter/material.dart';

/// Royal palette and Material 3 theming for the portfolio.
/// Colors: Imperial Navy, Gold, and Deep Slate.
class AppTheme {
  static const Color navyBase = Color(0xFF0A1128); // Imperial Navy
  static const Color navySurface = Color(
    0xFF0F1B3D,
  ); // Lighter navy for surface
  static const Color gold = Color(0xFFD4AF37); // Royal Gold
  static const Color goldLight = Color(0xFFFFD700); // Shimmering Gold
  static const Color slate = Color(0xFF8E9AAF); // Modern Slate

  static ThemeData get dark {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: const ColorScheme.dark(
        primary: gold,
        onPrimary: navyBase,
        secondary: goldLight,
        onSecondary: navyBase,
        tertiary: Color(0xFFE5B80B),
        surface: navyBase,
        onSurface: Colors.white,
        surfaceContainerHigh: navySurface,
        outline: slate,
      ),
      scaffoldBackgroundColor: navyBase,

      // Modern Typography
      textTheme: const TextTheme(
        headlineLarge: TextStyle(
          fontSize: 48,
          fontWeight: FontWeight.w900,
          color: Colors.white,
          letterSpacing: -1.0,
        ),
        headlineMedium: TextStyle(
          fontSize: 32,
          fontWeight: FontWeight.w800,
          color: gold,
          letterSpacing: -0.5,
        ),
        titleLarge: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.w700,
          color: Colors.white,
        ),
        bodyLarge: TextStyle(
          fontSize: 18,
          height: 1.6,
          color: Color(0xFFBDC3C7),
        ),
        bodyMedium: TextStyle(
          fontSize: 16,
          height: 1.5,
          color: Color(0xFFBDC3C7),
        ),
        labelLarge: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          letterSpacing: 1.2,
          color: gold,
        ),
      ),

      // Button Styles
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: gold,
          foregroundColor: navyBase,
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 18),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: const TextStyle(
            fontWeight: FontWeight.w700,
            letterSpacing: 1.2,
          ),
        ),
      ),

      // Card Styles
      cardTheme: CardThemeData(
        color: navySurface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: const BorderSide(color: Color(0x1AFFFFFF)),
        ),
      ),

      // Navigation Bar (mobile)
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: navyBase.withValues(alpha: 0.95),
        indicatorColor: const Color(0xFFD4AF37).withValues(alpha: 0.15),
        labelBehavior: NavigationDestinationLabelBehavior.onlyShowSelected,
      ),

      dividerTheme: const DividerThemeData(
        color: Color(0x1AFFFFFF),
        thickness: 1,
      ),
    );
  }

  // Light theme (fallback or auto-switch)
  static ThemeData get light => dark; // Focusing on the "Royal Dark" aesthetic
}
