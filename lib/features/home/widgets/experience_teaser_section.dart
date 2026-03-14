import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:portoflio/core/providers/portfolio_provider.dart';
import 'package:portoflio/core/providers/story_config_provider.dart';
import 'package:portoflio/core/config/story_config.dart';
import 'package:portoflio/shared/widgets/scroll_reveal.dart';
import 'package:portoflio/shared/widgets/story_banner.dart';

/// Home experience teaser section; featured experience from resume (Gist/local).
class ExperienceTeaserSection extends ConsumerWidget {
  const ExperienceTeaserSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final screenWidth = MediaQuery.sizeOf(context).width;
    final isDesktop = screenWidth >= 1200;
    final isTablet = screenWidth >= 700 && screenWidth < 1200;
    final asyncResume = ref.watch(portfolioDataProvider);
    final story = ref.watch(storyConfigProvider);
    final chapter = story.chapterBySectionKey('experience');
    final experiences = asyncResume.value?.experience ?? [];
    final featured = experiences.take(4).toList();

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: isDesktop ? 72 : 20,
        vertical: isDesktop ? 40 : 24,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ScrollReveal(
            child: StoryBanner(
              chapter:
                  chapter ??
                  const StoryChapter(
                    key: 'experience',
                    title: 'Experience',
                    subtitle: 'Where I\'ve grown, who I\'ve grown with',
                    storyLine:
                        'The best lessons came from the teams, not the textbooks.',
                    persianElement: 'oasis',
                  ),
              chapterIndex: 3,
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(height: isDesktop ? 32 : 20),
          if (featured.isEmpty)
            Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Text(
                  'No experience entries yet.',
                  style: theme.textTheme.bodyLarge,
                ),
              ),
            )
          else
            _StaggeredExperienceGrid(
              featured: featured,
              theme: theme,
              isDesktop: isDesktop,
              isTablet: isTablet,
            ),
          SizedBox(height: isDesktop ? 24 : 16),
          ScrollReveal(
            delay: const Duration(milliseconds: 300),
            direction: RevealDirection.fromBottom,
            child: GestureDetector(
              onTap: () => context.go('/experience'),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 16,
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
                    Text(
                      'See All Experience',
                      style: theme.textTheme.labelLarge?.copyWith(
                        color: theme.colorScheme.primary,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Icon(
                      Icons.arrow_forward_rounded,
                      size: 18,
                      color: theme.colorScheme.primary,
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

class _StaggeredExperienceGrid extends StatelessWidget {
  const _StaggeredExperienceGrid({
    required this.featured,
    required this.theme,
    required this.isDesktop,
    required this.isTablet,
  });

  final List<dynamic> featured;
  final ThemeData theme;
  final bool isDesktop;
  final bool isTablet;

  @override
  Widget build(BuildContext context) {
    final useGrid = isDesktop || isTablet;
    final gap = isDesktop ? 20.0 : 14.0;

    if (!useGrid) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (int i = 0; i < featured.length; i++) ...[
            ScrollReveal(
              delay: Duration(milliseconds: i * 100),
              direction: RevealDirection.fromBottom,
              child: _ExperienceCard(
                experience: featured[i],
                theme: theme,
                compact: true,
              ),
            ),
            if (i < featured.length - 1) SizedBox(height: gap),
          ],
        ],
      );
    }

    final leftItems = <int>[];
    final rightItems = <int>[];
    for (int i = 0; i < featured.length; i++) {
      if (i.isEven) {
        leftItems.add(i);
      } else {
        rightItems.add(i);
      }
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Padding(
            padding: EdgeInsets.only(top: isDesktop ? 40 : 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                for (int i = 0; i < leftItems.length; i++) ...[
                  ScrollReveal(
                    delay: Duration(milliseconds: leftItems[i] * 120),
                    direction: RevealDirection.fromBottom,
                    child: _ExperienceCard(
                      experience: featured[leftItems[i]],
                      theme: theme,
                      compact: isTablet,
                    ),
                  ),
                  if (i < leftItems.length - 1) SizedBox(height: gap),
                ],
              ],
            ),
          ),
        ),
        SizedBox(width: gap),
        Expanded(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              for (int i = 0; i < rightItems.length; i++) ...[
                ScrollReveal(
                  delay: Duration(milliseconds: rightItems[i] * 120),
                  direction: RevealDirection.fromBottom,
                  child: _ExperienceCard(
                    experience: featured[rightItems[i]],
                    theme: theme,
                    compact: isTablet,
                  ),
                ),
                if (i < rightItems.length - 1) SizedBox(height: gap),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

class _ExperienceCard extends StatelessWidget {
  const _ExperienceCard({
    required this.experience,
    required this.theme,
    this.compact = false,
  });

  final dynamic experience;
  final ThemeData theme;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final role = experience.role as String;
    final company = experience.company as String;
    final period = experience.period as String;
    final highlights = experience.highlights as List<String>;
    final description = highlights.isNotEmpty ? highlights.first : '';
    final padding = compact ? 16.0 : 24.0;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(padding),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: theme.colorScheme.surfaceContainerHigh.withValues(alpha: 0.2),
        border: Border.all(
          color: theme.colorScheme.outline.withValues(alpha: 0.08),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  role,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: theme.colorScheme.onSurface,
                    fontSize: compact ? 15 : 18,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 5,
                ),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(999),
                  border: Border.all(
                    color: theme.colorScheme.primary.withValues(alpha: 0.3),
                  ),
                ),
                child: Text(
                  period,
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: theme.colorScheme.primary,
                    fontWeight: FontWeight.w600,
                    fontSize: compact ? 10 : 11,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            company,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.primary,
              fontWeight: FontWeight.w600,
              fontSize: compact ? 13 : 14,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          if (description.isNotEmpty) ...[
            const SizedBox(height: 10),
            Text(
              description,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
                height: 1.5,
                fontSize: compact ? 12 : 13,
              ),
              maxLines: compact ? 2 : 3,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ],
      ),
    );
  }
}
