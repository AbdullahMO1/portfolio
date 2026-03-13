import 'package:flutter/material.dart';
import 'package:portoflio/theme/app_theme.dart';
import 'package:portoflio/features/home/widgets/hero/hero_arabesque_divider.dart';
import 'package:portoflio/features/home/widgets/hero/hero_pill_tag.dart';
import 'package:portoflio/features/home/widgets/hero/hero_name_block.dart';
import 'package:portoflio/features/home/widgets/hero/hero_tagline_block.dart';
import 'package:portoflio/features/home/widgets/hero/hero_cta_buttons.dart';

/// Left column: pill (optional), divider, preamble, name, tagline, CTAs.
class HeroContentColumn extends StatelessWidget {
  const HeroContentColumn({
    super.key,
    required this.theme,
    required this.isDesktop,
    required this.name,
    required this.storyPreamble,
    required this.storyLine,
    required this.displayedTagline,
    required this.showCursor,
    required this.nameAnimationValue,
    required this.underlineAnimationValue,
    required this.taglineAnimationValue,
    required this.ctaAnimationValue,
    this.showPill = true,
  });

  final ThemeData theme;
  final bool isDesktop;
  final String name;
  final String? storyPreamble;
  final String? storyLine;
  final String displayedTagline;
  final bool showCursor;
  final double nameAnimationValue;
  final double underlineAnimationValue;
  final double taglineAnimationValue;
  final double ctaAnimationValue;

  /// Set to false when pill is already shown above (e.g. mobile layout).
  final bool showPill;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: isDesktop
          ? CrossAxisAlignment.start
          : CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (showPill) ...[
          HeroPillTag(theme: theme, nameAnimationValue: nameAnimationValue),
          const SizedBox(height: 20),
        ],
        HeroArabesqueDivider(
          alignment: isDesktop ? Alignment.centerLeft : Alignment.center,
        ),
        const SizedBox(height: 20),
        if (storyPreamble != null) ...[
          Text(
            storyPreamble!,
            style: AppTheme.narrativeStyle(
              fontSize: isDesktop ? 20 : 16,
              color: theme.colorScheme.primary.withValues(alpha: 0.8),
            ),
            textAlign: isDesktop ? TextAlign.start : TextAlign.center,
          ),
          const SizedBox(height: 16),
        ],
        HeroNameBlock(
          name: name,
          theme: theme,
          isDesktop: isDesktop,
          nameAnimationValue: nameAnimationValue,
          underlineAnimationValue: underlineAnimationValue,
        ),
        const SizedBox(height: 20),
        HeroTaglineBlock(
          displayedTagline: displayedTagline,
          showCursor: showCursor,
          theme: theme,
          isDesktop: isDesktop,
          taglineAnimationValue: taglineAnimationValue,
          storyLine: storyLine,
        ),
        const SizedBox(height: 32),
        HeroCtaButtons(
          theme: theme,
          isDesktop: isDesktop,
          ctaAnimationValue: ctaAnimationValue,
        ),
      ],
    );
  }
}
