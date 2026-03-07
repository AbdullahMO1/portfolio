import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Providers for tracking place and scroll progress in the home screen
/// These are used for animations and journey progress indicators

/// Provider for place progress (0.0 to 5.0) used for cinematic effects
/// Maps to different "places" in the journey narrative
final homePlaceProgressProvider = Provider<ValueNotifier<double>>((ref) {
  return ValueNotifier<double>(0.0);
});

/// Provider for scroll progress (0.0 to 1.0) used for overall page progress
/// Used for navigation indicators and progress bars
final homeScrollProgressProvider = Provider<ValueNotifier<double>>((ref) {
  return ValueNotifier<double>(0.0);
});

/// Provider for tracking current section index (0-5) in the home screen
/// Used for navigation and section-specific animations
final currentSectionProvider = Provider<int>((ref) {
  return 0; // Start at hero section
});

/// Provider for tracking whether user is actively scrolling
/// Used to pause/start animations based on user interaction
final isScrollingProvider = Provider<bool>((ref) {
  return false;
});

/// Provider for scroll velocity used for dynamic effects
/// Higher values can trigger more dramatic animations
final scrollVelocityProvider = Provider<double>((ref) {
  return 0.0;
});

/// Utility functions for progress calculations
class ProgressUtils {
  /// Convert scroll progress (0-1) to place progress (0-5)
  /// Maps the 6 home sections to 6 main places
  static double scrollToPlaceProgress(double scrollProgress) {
    return scrollProgress * 5.0;
  }

  /// Convert scroll progress (0-1) to section index (0-5)
  static double scrollToSectionIndex(double scrollProgress) {
    return (scrollProgress * 5).clamp(0.0, 5.0);
  }

  /// Get place name based on progress value
  static String getPlaceName(double placeProgress) {
    if (placeProgress < 2.0) return 'Beginning';
    if (placeProgress < 4.0) return 'Journey';
    return 'Destination';
  }

  /// Calculate progress between two places
  static double calculatePlaceProgress(
    double currentPlace,
    double targetPlace,
    double scrollProgress,
  ) {
    final totalDistance = targetPlace - currentPlace;
    return currentPlace + (totalDistance * scrollProgress);
  }
}
