import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

/// "Open for collaborations" pill with dot and optional shimmer.
class HeroPillTag extends StatelessWidget {
  const HeroPillTag({
    super.key,
    required this.theme,
    required this.nameAnimationValue,
    this.label = 'OPEN TO NEW OPPORTUNITIES',
    this.shrinkLetterSpacingBelowWidth = 360,
  });

  final ThemeData theme;
  final double nameAnimationValue;
  final String label;
  final double shrinkLetterSpacingBelowWidth;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.sizeOf(context).width;
    return AnimatedOpacity(
      opacity: nameAnimationValue.clamp(0.0, 1.0),
      duration: const Duration(milliseconds: 350),
      child:
          Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(999),
                  border: Border.all(
                    color: theme.colorScheme.primary.withValues(alpha: 0.3),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: theme.colorScheme.primary,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Flexible(
                      child: Text(
                        label,
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: theme.colorScheme.primary,
                          fontWeight: FontWeight.w800,
                          letterSpacing:
                              screenWidth < shrinkLetterSpacingBelowWidth
                              ? 0.5
                              : 1.5,
                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                    ),
                  ],
                ),
              )
              .animate(onPlay: (c) => c.repeat())
              .shimmer(
                duration: 2400.ms,
                delay: 1800.ms,
                color: theme.colorScheme.primary.withValues(alpha: 0.35),
              ),
    );
  }
}
