import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:portoflio/core/providers/portfolio_provider.dart';
import 'package:portoflio/core/providers/story_config_provider.dart';
import 'package:portoflio/core/config/story_config.dart';
import 'package:portoflio/shared/widgets/scroll_reveal.dart';
import 'package:portoflio/shared/widgets/story_banner.dart';
import 'package:portoflio/shared/widgets/tilt_hover_card.dart';

/// Home-only curated portfolio; featured projects from resume (Gist/local).
class CuratedPortfolioSection extends ConsumerWidget {
  const CuratedPortfolioSection({super.key});

  static const String _placeholderImage =
      'https://placehold.co/800x500/1a1a2e/eab308?text=Project';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final screenWidth = MediaQuery.sizeOf(context).width;
    final isDesktop = screenWidth >= 1200;
    final asyncResume = ref.watch(portfolioDataProvider);
    final story = ref.watch(storyConfigProvider);
    final chapter = story.chapterBySectionKey('portfolio');
    final projects = asyncResume.value?.projects ?? [];
    final featured = projects.take(2).toList();

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
                        key: 'portfolio',
                        title: 'The Digital Caravans',
                        subtitle: 'Projects that traverse the digital desert',
                        storyLine:
                            'Each creation is a caravan carrying treasures across the vast landscape of technology.',
                        persianElement: 'caravan',
                      ),
                  chapterIndex: 2,
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
                    'No featured projects yet.',
                    style: theme.textTheme.bodyLarge,
                  ),
                ),
              )
            else
              ...List.generate(featured.length, (index) {
                final project = featured[index];
                final number = '${(index + 1).toString().padLeft(2, '0')}';
                final category = project.tech.isNotEmpty
                    ? project.tech.first
                    : 'Project';
                final imageUrl = project.imageUrl ?? _placeholderImage;
                final imageFirst = index == 1;
                return Padding(
                  padding: EdgeInsets.only(
                    bottom: index < featured.length - 1 ? 40 : 0,
                  ),
                  child: ScrollReveal(
                    delay: Duration(milliseconds: index * 120),
                    direction: RevealDirection.fromBottom,
                    child: _FeaturedProjectCard(
                      id: project.id,
                      number: number,
                      category: category,
                      title: project.title,
                      description: project.description,
                      tech: project.tech,
                      imageUrl: imageUrl,
                      theme: theme,
                      isDesktop: isDesktop,
                      imageFirst: imageFirst,
                    ),
                  ),
                );
              }),
          ],
        ),
      ),
    );
  }
}

class _FeaturedProjectCard extends StatelessWidget {
  const _FeaturedProjectCard({
    required this.id,
    required this.number,
    required this.category,
    required this.title,
    required this.description,
    required this.tech,
    required this.imageUrl,
    required this.theme,
    required this.isDesktop,
    required this.imageFirst,
  });

  final String id;
  final String number;
  final String category;
  final String title;
  final String description;
  final List<String> tech;
  final String imageUrl;
  final ThemeData theme;
  final bool isDesktop;
  final bool imageFirst;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.go('/projects/$id'),
      child: TiltHoverCard(
        invertTilt: true,
        tiltStrength: 0.06,
        followSpeed: 14,
        hoverLift: 4,
        builder: (context, isHovered) {
          return AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            curve: Curves.easeOutSine,
            padding: EdgeInsets.all(isDesktop ? 40 : 28),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(28),
              color: theme.colorScheme.surfaceContainerHigh.withValues(
                alpha: isHovered ? 0.4 : 0.2,
              ),
              border: Border.all(
                color: isHovered
                    ? theme.colorScheme.primary.withValues(alpha: 0.4)
                    : theme.colorScheme.outline.withValues(alpha: 0.08),
                width: 1.5,
              ),
              boxShadow: [
                if (isHovered)
                  BoxShadow(
                    color: theme.colorScheme.primary.withValues(alpha: 0.12),
                    blurRadius: 40,
                    spreadRadius: 2,
                  ),
                BoxShadow(
                  color: Colors.black.withValues(alpha: isHovered ? 0.3 : 0.15),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: isDesktop
                ? Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      if (imageFirst) _buildProjectImage(),
                      if (imageFirst) const SizedBox(width: 64),
                      Expanded(flex: 2, child: _buildProjectContent()),
                      if (!imageFirst) const SizedBox(width: 64),
                      if (!imageFirst) _buildProjectImage(),
                    ],
                  )
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildProjectImage(isCompact: true),
                      const SizedBox(height: 24),
                      _buildProjectContent(),
                    ],
                  ),
          );
        },
      ),
    );
  }

  Widget _buildProjectImage({bool isCompact = false}) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: Container(
        width: isCompact ? double.infinity : 400,
        height: isCompact ? 220 : 280,
        decoration: BoxDecoration(
          color: theme.colorScheme.surfaceContainerHigh.withValues(alpha: 0.4),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: theme.colorScheme.primary.withValues(alpha: 0.2),
          ),
          boxShadow: [
            BoxShadow(
              color: theme.colorScheme.primary.withValues(alpha: 0.1),
              blurRadius: 40,
              spreadRadius: 2,
            ),
          ],
        ),
        child: Image.network(
          imageUrl,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) => Container(
            color: theme.colorScheme.surfaceContainerHighest,
            child: Icon(
              Icons.image_not_supported_rounded,
              size: 48,
              color: theme.colorScheme.primary,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProjectContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '$number / $category',
          style: theme.textTheme.labelMedium?.copyWith(
            color: theme.colorScheme.primary,
            fontWeight: FontWeight.w800,
            letterSpacing: 1.5,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          title,
          style: theme.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.w700,
            color: theme.colorScheme.onSurface,
            fontSize: isDesktop ? 40 : 28,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
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
        const SizedBox(height: 20),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: tech
              .map(
                (t) => Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primary.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(999),
                    border: Border.all(
                      color: theme.colorScheme.primary.withValues(alpha: 0.2),
                    ),
                  ),
                  child: Text(
                    t,
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: theme.colorScheme.primary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              )
              .toList(),
        ),
        const SizedBox(height: 24),
        Row(
          children: [
            Text(
              'Case Study',
              style: theme.textTheme.labelLarge?.copyWith(
                color: theme.colorScheme.primary,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(width: 6),
            Icon(
              Icons.north_east_rounded,
              size: 18,
              color: theme.colorScheme.primary,
            ),
          ],
        ),
      ],
    );
  }
}
