import 'package:flutter/material.dart';
import 'package:portoflio/theme/app_theme.dart';

/// Ornamental divider with gold lines and gem accents for the hero section.
class HeroArabesqueDivider extends StatelessWidget {
  const HeroArabesqueDivider({super.key, required this.alignment});

  final Alignment alignment;

  @override
  Widget build(BuildContext context) {
    const gold = AppTheme.saffron;
    return Align(
      alignment: alignment,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _line(gold, 24),
          _gem(gold, 8),
          _line(gold, 48),
          _gem(gold, 12),
          _line(gold, 48),
          _gem(gold, 8),
          _line(gold, 24),
        ],
      ),
    );
  }

  Widget _line(Color c, double w) => Container(
    width: w,
    height: 1,
    margin: const EdgeInsets.symmetric(horizontal: 2),
    decoration: BoxDecoration(
      gradient: LinearGradient(
        colors: [
          c.withValues(alpha: 0.0),
          c.withValues(alpha: 0.7),
          c.withValues(alpha: 0.0),
        ],
      ),
    ),
  );

  Widget _gem(Color c, double size) => Container(
    width: size,
    height: size,
    decoration: BoxDecoration(
      color: c.withValues(alpha: 0.15),
      border: Border.all(color: c.withValues(alpha: 0.5), width: 1),
      shape: BoxShape.rectangle,
      borderRadius: BorderRadius.circular(2),
    ),
    child: Center(
      child: Container(
        width: size * 0.4,
        height: size * 0.4,
        decoration: BoxDecoration(
          color: c.withValues(alpha: 0.6),
          shape: BoxShape.circle,
        ),
      ),
    ),
  );
}
