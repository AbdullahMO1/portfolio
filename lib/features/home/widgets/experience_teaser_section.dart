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
    final asyncResume = ref.watch(portfolioDataProvider);
    final story = ref.watch(storyConfigProvider);
    final chapter = story.chapterBySectionKey('experience');
    final experiences = asyncResume.value?.experience ?? [];
    final featured = experiences.take(2).toList();

    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: isDesktop ? 72 : 20,
          vertical: 40,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ScrollReveal(
              child: Center(
                child: StoryBanner(
                  chapter:
                      chapter ??
                      const StoryChapter(
                        key: 'experience',
                        title: 'The Oasis Journey',
                        subtitle: 'Professional oases in the desert of career',
                        storyLine:
                            'Through vast deserts of challenges, the Prince discovered oases of opportunity and growth.',
                        persianElement: 'oasis',
                      ),
                  chapterIndex: 3,
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            const SizedBox(height: 60),
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
              ...List.generate(featured.length, (index) {
                final experience = featured[index];
                return Padding(
                  padding: EdgeInsets.only(
                    bottom: index < featured.length - 1 ? 40 : 0,
                  ),
                  child: ScrollReveal(
                    delay: Duration(milliseconds: index * 120),
                    direction: RevealDirection.fromBottom,
                    child: _ExperienceCard(
                      company: experience.company,
                      role: experience.role,
                      period: experience.period,
                      description: experience.highlights.isNotEmpty
                          ? experience.highlights.first
                          : '',
                      technologies:
                          const [], // ExperienceEntry doesn't have technologies field
                      theme: theme,
                      isDesktop: isDesktop,
                    ),
                  ),
                );
              }),
            const SizedBox(height: 40),
            Center(
              child: ScrollReveal(
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
                          'View Full Journey',
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
            ),
          ],
        ),
      ),
    );
  }
}

class _ExperienceCard extends StatelessWidget {
  const _ExperienceCard({
    required this.company,
    required this.role,
    required this.period,
    required this.description,
    required this.technologies,
    required this.theme,
    required this.isDesktop,
  });

  final String company;
  final String role;
  final String period;
  final String description;
  final List<String> technologies;
  final ThemeData theme;
  final bool isDesktop;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(isDesktop ? 40 : 28),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        color: theme.colorScheme.surfaceContainerHigh.withValues(alpha: 0.2),
        border: Border.all(
          color: theme.colorScheme.outline.withValues(alpha: 0.08),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
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
                      role,
                      style: theme.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: theme.colorScheme.onSurface,
                        fontSize: isDesktop ? 32 : 24,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      company,
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: theme.colorScheme.primary,
                        fontWeight: FontWeight.w600,
                        fontSize: isDesktop ? 20 : 16,
                      ),
                    ),
                  ],
                ),
              ),
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
                child: Text(
                  period,
                  style: theme.textTheme.labelMedium?.copyWith(
                    color: theme.colorScheme.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            description,
            style: theme.textTheme.bodyLarge?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
              height: 1.6,
            ),
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),
          if (technologies.isNotEmpty) ...[
            const SizedBox(height: 20),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: technologies
                  .map(
                    (tech) => Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.surfaceContainerHighest
                            .withValues(alpha: 0.5),
                        borderRadius: BorderRadius.circular(999),
                        border: Border.all(
                          color: theme.colorScheme.outline.withValues(
                            alpha: 0.2,
                          ),
                        ),
                      ),
                      child: Text(
                        tech,
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  )
                  .toList(),
            ),
          ],
        ],
      ),
    );
  }
}
