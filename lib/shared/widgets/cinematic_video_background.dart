import 'package:flutter/material.dart';

/// Cinematic video background with place-based effects
class CinematicVideoBackground extends StatelessWidget {
  const CinematicVideoBackground({
    super.key,
    required this.opacity,
    required this.placeProgress,
  });

  final double opacity;
  final ValueNotifier<double> placeProgress;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<double>(
      valueListenable: placeProgress,
      builder: (context, progress, child) {
        return AnimatedContainer(
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOutCubic,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: _getGradientColors(context, progress),
            ),
          ),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: (1.0 - opacity) * 0.3),
            ),
          ),
        );
      },
    );
  }

  List<Color> _getGradientColors(BuildContext context, double progress) {
    final theme = Theme.of(context);

    // Different gradients based on place progress (0.0 to 5.0)
    if (progress < 2.0) {
      // Beginning (Hero, Skills) - warm colors
      return [
        theme.colorScheme.primary.withValues(alpha: 0.3),
        theme.colorScheme.tertiary.withValues(alpha: 0.2),
      ];
    } else if (progress < 4.0) {
      // Journey (Portfolio, Experience) - cool colors
      return [
        theme.colorScheme.primary.withValues(alpha: 0.2),
        Colors.blue.withValues(alpha: 0.1),
      ];
    } else {
      // Destination (About, Footer) - dramatic colors
      return [
        Colors.deepPurple.withValues(alpha: 0.2),
        theme.colorScheme.primary.withValues(alpha: 0.3),
      ];
    }
  }
}
