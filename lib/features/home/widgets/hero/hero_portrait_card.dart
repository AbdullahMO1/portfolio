import 'dart:math' show min;

import 'package:flutter/material.dart';
import 'package:portoflio/shared/widgets/tilt_hover_card.dart';

/// Hero portrait with rectangular frame and "Current focus" card.
class HeroPortraitCard extends StatelessWidget {
  const HeroPortraitCard({
    super.key,
    required this.theme,
    required this.nameAnimationValue,
    this.avatarPath = 'assets/images/avatar.jpeg',
    this.currentFocusTitle = 'CURRENT FOCUS',
    this.currentFocusRole = 'Senior & Team Leading Mobile Engineer',
  });

  final ThemeData theme;
  final double nameAnimationValue;
  final String avatarPath;
  final String currentFocusTitle;
  final String currentFocusRole;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.sizeOf(context).width;
    final size = screenWidth < 768 ? min(300.0, screenWidth - 48) : 400.0;

    return TiltHoverCard(
      tiltStrength: 0.14,
      followSpeed: 12.0,
      hoverLift: 6.0,
      resetDuration: const Duration(milliseconds: 500),
      resetCurve: Curves.easeOutBack,
      builder: (context, isHovered) => Opacity(
        opacity: nameAnimationValue.clamp(0.0, 1.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: size,
              height: size * 1.25,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: theme.colorScheme.primary.withValues(alpha: 0.5), width: 2),
                boxShadow: [
                  BoxShadow(
                    color: theme.colorScheme.primary.withValues(alpha: 0.15),
                    blurRadius: 24,
                    offset: const Offset(0, 8),
                  ),
                  BoxShadow(color: Colors.black.withValues(alpha: 0.2), blurRadius: 16, offset: const Offset(0, 4)),
                ],
              ),
              clipBehavior: Clip.antiAlias,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Transform.scale(
                    scale: 1.25,
                    alignment: const Alignment(0, -0.15),
                    child: Image.asset(
                      avatarPath,
                      fit: BoxFit.contain,
                      alignment: const Alignment(0, -0.25),
                      errorBuilder: (context, error, stackTrace) => Container(
                        color: theme.colorScheme.surfaceContainerHighest,
                        child: Icon(Icons.person_rounded, size: size * 0.4, color: theme.colorScheme.primary),
                      ),
                    ),
                  ),
                  Positioned.fill(
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: RadialGradient(
                          center: const Alignment(0, -0.2),
                          radius: 0.85,
                          colors: [
                            Colors.transparent,
                            Colors.transparent,
                            theme.colorScheme.surface.withValues(alpha: 0.4),
                          ],
                          stops: const [0.0, 0.6, 1.0],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            _CurrentFocusCard(theme: theme, width: size * 0.88, title: currentFocusTitle, role: currentFocusRole),
          ],
        ),
      ),
    );
  }
}

class _CurrentFocusCard extends StatelessWidget {
  const _CurrentFocusCard({required this.theme, required this.width, required this.title, required this.role});

  final ThemeData theme;
  final double width;
  final String title;
  final String role;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface.withValues(alpha: 0.8),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: theme.colorScheme.primary.withValues(alpha: 0.2)),
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.primary.withValues(alpha: 0.1),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            title,
            style: theme.textTheme.labelSmall?.copyWith(
              color: theme.colorScheme.primary,
              fontWeight: FontWeight.w800,
              letterSpacing: 1.5,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            role,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w700,
              color: theme.colorScheme.onSurface,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
