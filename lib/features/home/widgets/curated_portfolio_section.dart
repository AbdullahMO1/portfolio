import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:portoflio/core/providers/portfolio_provider.dart';
import 'package:portoflio/core/providers/story_config_provider.dart';
import 'package:portoflio/core/config/story_config.dart';
import 'package:portoflio/shared/widgets/scroll_reveal.dart';
import 'package:portoflio/shared/widgets/story_banner.dart';
import 'package:portoflio/shared/widgets/tilt_hover_card.dart';

/// Home-only curated portfolio displayed as a staggered masonry grid.
class CuratedPortfolioSection extends ConsumerWidget {
  const CuratedPortfolioSection({super.key});

  static const String _placeholderImage =
      'https://placehold.co/800x500/1a1a2e/eab308?text=Project';

  static const List<double> _heightPattern = [
    340,
    260,
    280,
    360,
    240,
    320,
    300,
    280,
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final screenWidth = MediaQuery.sizeOf(context).width;
    final isDesktop = screenWidth >= 1200;
    final isTablet = screenWidth >= 768;
    final asyncResume = ref.watch(portfolioDataProvider);
    final story = ref.watch(storyConfigProvider);
    final chapter = story.chapterBySectionKey('portfolio');
    final projects = asyncResume.value?.projects ?? [];
    final featured = projects.take(6).toList();

    final columnCount = isDesktop ? 3 : (isTablet ? 2 : 1);
    final horizontalPad = isDesktop ? 72.0 : 20.0;
    final gap = isDesktop ? 20.0 : 14.0;

    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: horizontalPad, vertical: 40),
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
              _StaggeredGrid(
                columnCount: columnCount,
                gap: gap,
                children: List.generate(featured.length, (index) {
                  final project = featured[index];
                  final imageUrl = project.imageUrl ?? _placeholderImage;
                  final height = _heightPattern[index % _heightPattern.length];

                  return ScrollReveal(
                    delay: Duration(milliseconds: index * 100),
                    direction: RevealDirection.fromBottom,
                    child: _StaggeredProjectTile(
                      id: project.id,
                      title: project.title,
                      category: project.tech.isNotEmpty
                          ? project.tech.first
                          : 'Project',
                      imageUrl: imageUrl,
                      height: height,
                      tech: project.tech.take(3).toList(),
                    ),
                  );
                }),
              ),
          ],
        ),
      ),
    );
  }
}

class _StaggeredGrid extends StatelessWidget {
  const _StaggeredGrid({
    required this.columnCount,
    required this.gap,
    required this.children,
  });

  final int columnCount;
  final double gap;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final columns = List.generate(columnCount, (_) => <Widget>[]);

    for (var i = 0; i < children.length; i++) {
      columns[i % columnCount].add(children[i]);
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (var col = 0; col < columns.length; col++) ...[
          if (col > 0) SizedBox(width: gap),
          Expanded(
            child: Column(
              children: [
                for (var row = 0; row < columns[col].length; row++) ...[
                  if (row > 0) SizedBox(height: gap),
                  columns[col][row],
                ],
              ],
            ),
          ),
        ],
      ],
    );
  }
}

class _StaggeredProjectTile extends StatelessWidget {
  const _StaggeredProjectTile({
    required this.id,
    required this.title,
    required this.category,
    required this.imageUrl,
    required this.height,
    required this.tech,
  });

  final String id;
  final String title;
  final String category;
  final String imageUrl;
  final double height;
  final List<String> tech;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: () => context.go('/projects/$id'),
      child: TiltHoverCard(
        invertTilt: true,
        tiltStrength: 0.04,
        followSpeed: 14,
        hoverLift: 6,
        builder: (context, isHovered) {
          return AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOutCubic,
            height: height,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: isHovered
                    ? theme.colorScheme.primary.withValues(alpha: 0.5)
                    : theme.colorScheme.outline.withValues(alpha: 0.06),
                width: 1.5,
              ),
              boxShadow: [
                if (isHovered)
                  BoxShadow(
                    color: theme.colorScheme.primary.withValues(alpha: 0.15),
                    blurRadius: 32,
                    spreadRadius: 0,
                  ),
                BoxShadow(
                  color: Colors.black.withValues(
                    alpha: isHovered ? 0.35 : 0.18,
                  ),
                  blurRadius: 16,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Image.network(
                    imageUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      color: theme.colorScheme.surfaceContainerHighest,
                      child: Icon(
                        Icons.image_not_supported_rounded,
                        size: 40,
                        color: theme.colorScheme.primary.withValues(alpha: 0.5),
                      ),
                    ),
                  ),

                  // Gradient scrim
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.black.withValues(
                            alpha: isHovered ? 0.85 : 0.6,
                          ),
                        ],
                        stops: [isHovered ? 0.2 : 0.35, 1.0],
                      ),
                    ),
                  ),

                  // Category badge
                  Positioned(
                    top: 14,
                    left: 14,
                    child: AnimatedOpacity(
                      duration: const Duration(milliseconds: 250),
                      opacity: isHovered ? 1.0 : 0.85,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 5,
                        ),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.primary.withValues(
                            alpha: 0.85,
                          ),
                          borderRadius: BorderRadius.circular(999),
                        ),
                        child: Text(
                          category.toUpperCase(),
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: theme.colorScheme.onPrimary,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 1.0,
                            fontSize: 10,
                          ),
                        ),
                      ),
                    ),
                  ),

                  // Bottom content
                  Positioned(
                    left: 16,
                    right: 16,
                    bottom: 16,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          title,
                          style: theme.textTheme.titleMedium?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                            height: 1.2,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        AnimatedCrossFade(
                          duration: const Duration(milliseconds: 250),
                          crossFadeState: isHovered
                              ? CrossFadeState.showSecond
                              : CrossFadeState.showFirst,
                          firstChild: const SizedBox(
                            height: 0,
                            width: double.infinity,
                          ),
                          secondChild: Padding(
                            padding: const EdgeInsets.only(top: 10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Wrap(
                                  spacing: 6,
                                  runSpacing: 4,
                                  children: tech
                                      .map(
                                        (t) => Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 8,
                                            vertical: 3,
                                          ),
                                          decoration: BoxDecoration(
                                            color: Colors.white.withValues(
                                              alpha: 0.15,
                                            ),
                                            borderRadius: BorderRadius.circular(
                                              6,
                                            ),
                                            border: Border.all(
                                              color: Colors.white.withValues(
                                                alpha: 0.2,
                                              ),
                                            ),
                                          ),
                                          child: Text(
                                            t,
                                            style: theme.textTheme.labelSmall
                                                ?.copyWith(
                                                  color: Colors.white
                                                      .withValues(alpha: 0.9),
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 10,
                                                ),
                                          ),
                                        ),
                                      )
                                      .toList(),
                                ),
                                const SizedBox(height: 10),
                                Row(
                                  children: [
                                    Text(
                                      'View Project',
                                      style: theme.textTheme.labelSmall
                                          ?.copyWith(
                                            color: theme.colorScheme.primary,
                                            fontWeight: FontWeight.w700,
                                            letterSpacing: 0.5,
                                          ),
                                    ),
                                    const SizedBox(width: 4),
                                    Icon(
                                      Icons.arrow_forward_rounded,
                                      size: 14,
                                      color: theme.colorScheme.primary,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
