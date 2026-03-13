import 'package:flutter/material.dart';
import 'package:portoflio/theme/app_theme.dart';

/// Typewriter tagline with optional story line quote.
class HeroTaglineBlock extends StatelessWidget {
  const HeroTaglineBlock({
    super.key,
    required this.displayedTagline,
    required this.showCursor,
    required this.theme,
    required this.isDesktop,
    required this.taglineAnimationValue,
    this.storyLine,
  });

  final String displayedTagline;
  final bool showCursor;
  final ThemeData theme;
  final bool isDesktop;
  final double taglineAnimationValue;
  final String? storyLine;

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: taglineAnimationValue.clamp(0.0, 1.0),
      child: Transform.translate(
        offset: Offset(0, 15 * (1 - taglineAnimationValue)),
        child: Column(
          crossAxisAlignment: isDesktop
              ? CrossAxisAlignment.start
              : CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              displayedTagline + (showCursor ? '▌' : ''),
              style: theme.textTheme.bodyLarge?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
                height: 1.8,
              ),
              textAlign: isDesktop ? TextAlign.start : TextAlign.center,
            ),
            if (storyLine != null) ...[
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  border: Border(
                    left: BorderSide(
                      color: theme.colorScheme.primary.withValues(alpha: 0.6),
                      width: 3,
                    ),
                  ),
                  color: theme.colorScheme.primary.withValues(alpha: 0.04),
                  borderRadius: const BorderRadius.only(
                    topRight: Radius.circular(8),
                    bottomRight: Radius.circular(8),
                  ),
                ),
                child: Text(
                  storyLine!,
                  style: AppTheme.narrativeStyle(
                    fontSize: isDesktop ? 16 : 14,
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                  textAlign: TextAlign.start,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
