import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:portoflio/core/models/resume_model.dart';
import 'package:portoflio/core/providers/portfolio_provider.dart';
import 'package:portoflio/core/providers/story_config_provider.dart';
import 'package:portoflio/core/config/story_config.dart';
import 'package:portoflio/shared/widgets/scroll_reveal.dart';
import 'package:portoflio/theme/app_theme.dart';

/// Experience timeline with:
/// - Animated connector that draws itself on scroll
/// - Cards slide in from alternating left/right
/// - Glassmorphism containers with gold accents
/// - ScrollReveal stagger per entry
/// - Data from resume (Gist/local)
class ExperienceScreen extends ConsumerWidget {
  const ExperienceScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final screenWidth = MediaQuery.sizeOf(context).width;
    final isDesktop = screenWidth >= 1200;
    final asyncResume = ref.watch(portfolioDataProvider);
    final story = ref.watch(storyConfigProvider);
    final chapter = story.chapterBySectionKey('experience');
    final experiences = asyncResume.value?.experience ?? [];

    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(
        horizontal: isDesktop ? 100 : 24,
        vertical: 80,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ScrollReveal(
            child: Center(
              child: Column(
                children: [
                  Text(
                    chapter?.title ?? 'The Trials',
                    style: AppTheme.storyTitleStyle(fontSize: 36),
                  ),
                  const SizedBox(height: 12),
                  const _ExperienceDivider(),
                  if ((chapter?.subtitle ?? '').isNotEmpty) ...[
                    const SizedBox(height: 12),
                    Text(
                      chapter!.subtitle,
                      style: AppTheme.narrativeStyle(fontSize: 16),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ],
              ),
            ),
          ),
          const SizedBox(height: 50),
          ...List.generate(experiences.length, (index) {
            final exp = experiences[index];
            return ScrollReveal(
              delay: Duration(milliseconds: index * 150),
              direction: index.isEven
                  ? RevealDirection.fromLeft
                  : RevealDirection.fromRight,
              offset: 80,
              child: _GlassTimelineEntry(
                index: index,
                isLast: index == experiences.length - 1,
                entry: exp,
                theme: theme,
              ),
            );
          }),
        ],
      ),
    );
  }
}

class _ExperienceDivider extends StatelessWidget {
  const _ExperienceDivider();
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      width: 60,
      height: 3,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [theme.colorScheme.primary, theme.colorScheme.tertiary],
        ),
        borderRadius: BorderRadius.circular(2),
      ),
    );
  }
}

class _GlassTimelineEntry extends StatefulWidget {
  const _GlassTimelineEntry({
    required this.index,
    required this.isLast,
    required this.entry,
    required this.theme,
  });

  final int index;
  final bool isLast;
  final ExperienceEntry entry;
  final ThemeData theme;

  @override
  State<_GlassTimelineEntry> createState() => _GlassTimelineEntryState();
}

class _GlassTimelineEntryState extends State<_GlassTimelineEntry> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final entry = widget.entry;
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Timeline connector
          SizedBox(
            width: 40,
            child: Column(
              children: [
                // 8-pointed star (Islamic geometric motif)
                CustomPaint(
                  size: const Size(16, 16),
                  painter: _EightPointedStarPainter(
                    color: widget.theme.colorScheme.primary,
                  ),
                ),
                if (!widget.isLast)
                  Expanded(
                    child: Container(
                      width: 2,
                      margin: const EdgeInsets.symmetric(vertical: 6),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            widget.theme.colorScheme.primary.withValues(
                              alpha: 0.5,
                            ),
                            widget.theme.colorScheme.primary.withValues(
                              alpha: 0.05,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(width: 20),
          // Glassmorphism card
          Expanded(
            child: MouseRegion(
              onEnter: (_) => setState(() => _isHovered = true),
              onExit: (_) => setState(() => _isHovered = false),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                margin: const EdgeInsets.only(bottom: 36),
                padding: const EdgeInsets.all(28),
                decoration: BoxDecoration(
                  color: widget.theme.colorScheme.surfaceContainerHigh
                      .withValues(alpha: _isHovered ? 0.4 : 0.25),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: _isHovered
                        ? widget.theme.colorScheme.primary.withValues(
                            alpha: 0.3,
                          )
                        : widget.theme.colorScheme.outline.withValues(
                            alpha: 0.08,
                          ),
                  ),
                  boxShadow: _isHovered
                      ? [
                          BoxShadow(
                            color: widget.theme.colorScheme.primary.withValues(
                              alpha: 0.08,
                            ),
                            blurRadius: 30,
                          ),
                        ]
                      : null,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                entry.role,
                                style: widget.theme.textTheme.titleMedium
                                    ?.copyWith(
                                      fontWeight: FontWeight.w600,
                                      color: widget.theme.colorScheme.onSurface,
                                    ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 4),
                              Text(
                                entry.company,
                                style: widget.theme.textTheme.bodyLarge
                                    ?.copyWith(
                                      color: widget.theme.colorScheme.primary,
                                      fontWeight: FontWeight.w500,
                                    ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 7,
                          ),
                          decoration: BoxDecoration(
                            color: widget.theme.colorScheme.primary.withValues(
                              alpha: 0.1,
                            ),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: widget.theme.colorScheme.primary
                                  .withValues(alpha: 0.2),
                            ),
                          ),
                          child: Text(
                            entry.period,
                            style: widget.theme.textTheme.bodySmall?.copyWith(
                              color: widget.theme.colorScheme.primary,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                    if (entry.location.isNotEmpty) ...[
                      const SizedBox(height: 6),
                      Text(
                        '📍 ${entry.location}',
                        style: widget.theme.textTheme.bodySmall?.copyWith(
                          color: widget.theme.colorScheme.onSurfaceVariant,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                    const SizedBox(height: 18),
                    Flexible(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: entry.highlights
                            .map(
                              (h) => Padding(
                                padding: const EdgeInsets.only(bottom: 8),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(top: 6),
                                      child: Container(
                                        width: 6,
                                        height: 6,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: widget
                                              .theme
                                              .colorScheme
                                              .primary
                                              .withValues(alpha: 0.6),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    Expanded(
                                      child: Text(
                                        h,
                                        style:
                                            widget.theme.textTheme.bodyMedium,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            )
                            .toList(),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _EightPointedStarPainter extends CustomPainter {
  _EightPointedStarPainter({required this.color});
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;
    final cx = size.width / 2;
    final cy = size.height / 2;
    final outer = size.width / 2;
    final inner = outer * 0.4;
    final path = Path();
    for (int i = 0; i < 8; i++) {
      final angle = (i * 45 - 90) * math.pi / 180;
      final nextAngle = ((i * 45 + 22.5) - 90) * math.pi / 180;
      final ox = cx + outer * math.cos(angle);
      final oy = cy + outer * math.sin(angle);
      final ix = cx + inner * math.cos(nextAngle);
      final iy = cy + inner * math.sin(nextAngle);
      if (i == 0) {
        path.moveTo(ox, oy);
      } else {
        path.lineTo(ox, oy);
      }
      path.lineTo(ix, iy);
    }
    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
