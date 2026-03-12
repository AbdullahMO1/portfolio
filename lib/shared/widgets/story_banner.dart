import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:portoflio/core/config/story_config.dart';
import 'package:portoflio/theme/app_theme.dart';

/// Narrative chapter header displayed at the top of each portfolio section.
///
/// Shows:
///  - Gold chapter badge  ("Chapter I", "Chapter II" …)
///  - Calligraphic Amiri title
///  - Muted italic subtitle
///  - Ornamental divider
///  - Story line in Newsreader italic
///
/// Animates in with a staggered fade-slide powered by flutter_animate.
class StoryBanner extends StatelessWidget {
  const StoryBanner({
    super.key,
    required this.chapter,
    required this.chapterIndex,
    this.animate = true,
    this.textAlign = TextAlign.center,
  });

  final StoryChapter chapter;
  final int chapterIndex;
  final bool animate;
  final TextAlign textAlign;

  static const _romanNumerals = [
    'I',
    'II',
    'III',
    'IV',
    'V',
    'VI',
    'VII',
    'VIII',
  ];

  String get _roman {
    if (chapterIndex < _romanNumerals.length) {
      return _romanNumerals[chapterIndex];
    }
    return '${chapterIndex + 1}';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isCenter = textAlign == TextAlign.center;

    Widget content = Column(
      crossAxisAlignment: isCenter
          ? CrossAxisAlignment.center
          : CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        // ── Chapter badge ───────────────────────────────────────────
        _ChapterBadge(roman: _roman, theme: theme),
        const SizedBox(height: 16),

        // ── Calligraphic title ──────────────────────────────────────
        Text(
          chapter.title,
          style: AppTheme.storyTitleStyle(
            fontSize: 38,
            color: theme.colorScheme.primary,
          ),
          textAlign: textAlign,
        ),
        const SizedBox(height: 8),

        // ── Subtitle ────────────────────────────────────────────────
        Text(
          chapter.subtitle,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.primary.withValues(alpha: 0.85),
            fontStyle: FontStyle.italic,
            letterSpacing: 0.5,
          ),
          textAlign: textAlign,
        ),
        const SizedBox(height: 20),

        // ── Ornamental divider ──────────────────────────────────────
        _OrnamentDivider(align: textAlign),
        const SizedBox(height: 20),

        // ── Story line ──────────────────────────────────────────────
        Container(
          padding: const EdgeInsets.only(left: 16),
          decoration: BoxDecoration(
            border: Border(
              left: BorderSide(
                color: theme.colorScheme.primary.withValues(alpha: 0.5),
                width: 2.5,
              ),
            ),
          ),
          child: Text(
            chapter.storyLine,
            style: AppTheme.narrativeStyle(
              fontSize: 15,
              color: theme.colorScheme.onSurfaceVariant,
            ),
            textAlign: textAlign,
          ),
        ),
      ],
    );

    if (!animate) return content;

    // Stagger each child in with flutter_animate
    return content
        .animate()
        .fadeIn(duration: 600.ms, curve: Curves.easeOut)
        .slideY(
          begin: 0.25,
          end: 0,
          duration: 700.ms,
          curve: Curves.easeOutCubic,
        );
  }
}

// ─── Chapter badge ────────────────────────────────────────────────────────────

class _ChapterBadge extends StatelessWidget {
  const _ChapterBadge({required this.roman, required this.theme});
  final String roman;
  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 7),
      decoration: BoxDecoration(
        color: theme.colorScheme.primary.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(
          color: theme.colorScheme.primary.withValues(alpha: 0.30),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 7,
            height: 7,
            decoration: BoxDecoration(
              color: theme.colorScheme.primary,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 10),
          Text(
            'Chapter $roman',
            style: theme.textTheme.labelSmall?.copyWith(
              color: theme.colorScheme.primary,
              fontWeight: FontWeight.w800,
              letterSpacing: 2.0,
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Ornamental divider ───────────────────────────────────────────────────────

class _OrnamentDivider extends StatelessWidget {
  const _OrnamentDivider({required this.align});
  final TextAlign align;

  @override
  Widget build(BuildContext context) {
    const gold = AppTheme.saffron;
    final isCenter = align == TextAlign.center;

    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: isCenter
          ? MainAxisAlignment.center
          : MainAxisAlignment.start,
      children: [
        _buildLine(gold, 40),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: Text('✦', style: TextStyle(color: gold, fontSize: 14)),
        ),
        _buildLine(gold, 40),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Text(
            '✦',
            style: TextStyle(color: gold.withValues(alpha: 0.4), fontSize: 10),
          ),
        ),
        _buildLine(gold, 20),
      ],
    );
  }

  Widget _buildLine(Color color, double width) => Container(
    width: width,
    height: 1.5,
    decoration: BoxDecoration(
      gradient: LinearGradient(
        colors: [
          color.withValues(alpha: 0.0),
          color,
          color.withValues(alpha: 0.0),
        ],
      ),
    ),
  );
}
