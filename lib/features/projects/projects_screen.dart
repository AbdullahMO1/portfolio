import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:portoflio/core/providers/portfolio_provider.dart';
import 'package:portoflio/core/providers/story_config_provider.dart';
import 'package:portoflio/core/config/story_config.dart';
import 'package:portoflio/features/projects/widgets/store_button.dart';
import 'package:portoflio/shared/widgets/scroll_reveal.dart';
import 'package:portoflio/shared/widgets/tilt_hover_card.dart';
import 'package:portoflio/theme/app_theme.dart';

/// Projects grid with data from resume (Gist or local).
/// - 3D perspective tilt cards tracking cursor
/// - Glassmorphism with gold border glow on hover
/// - ScrollReveal staggered entrance (scale pop)
/// - Deep link navigation to /projects/:id
class ProjectsScreen extends ConsumerWidget {
  const ProjectsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final screenWidth = MediaQuery.sizeOf(context).width;
    final isDesktop = screenWidth >= 1200;
    final crossAxisCount = isDesktop ? 3 : (screenWidth >= 600 ? 2 : 1);
    final asyncResume = ref.watch(portfolioDataProvider);
    final story = ref.watch(storyConfigProvider);
    final chapter = story.chapterBySectionKey('portfolio');

    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(
        horizontal: isDesktop ? 100 : 24,
        vertical: 80,
      ),
      child: Column(
        children: [
          ScrollReveal(
            child: Center(
              child: Column(
                children: [
                  Text(
                    chapter?.title ?? 'That Which Was Wrought',
                    style: AppTheme.storyTitleStyle(fontSize: 36),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    width: 60,
                    height: 3,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          theme.colorScheme.primary,
                          theme.colorScheme.tertiary,
                        ],
                      ),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  if ((chapter?.subtitle ?? '').isNotEmpty) ...[
                    const SizedBox(height: 12),
                    Text(
                      chapter!.subtitle,
                      style: AppTheme.narrativeStyle(
                        fontSize: 16,
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ],
              ),
            ),
          ),
          const SizedBox(height: 50),
          asyncResume.when(
            loading: () => const Center(
              child: Padding(
                padding: EdgeInsets.all(48),
                child: CircularProgressIndicator(),
              ),
            ),
            error: (err, _) => Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Text(
                  'Failed to load projects: $err',
                  style: theme.textTheme.bodyLarge,
                ),
              ),
            ),
            data: (resume) {
              final projects = resume.projects;
              if (projects.isEmpty) {
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Text(
                      'No projects yet.',
                      style: theme.textTheme.bodyLarge,
                    ),
                  ),
                );
              }
              return GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: crossAxisCount,
                  mainAxisSpacing: 24,
                  crossAxisSpacing: 24,
                  childAspectRatio: isDesktop ? 0.92 : 1.1,
                ),
                itemCount: projects.length,
                itemBuilder: (context, index) {
                  final project = projects[index];
                  return ScrollReveal(
                    delay: Duration(milliseconds: index * 100),
                    direction: RevealDirection.scale,
                    child: _Glass3DProjectCard(
                      id: project.id,
                      title: project.title,
                      description: project.description,
                      tech: project.tech,
                      icon: Icons.rocket_launch_rounded,
                      imageUrl: project.imageUrl,
                      googlePlayUrl: project.googlePlayUrl,
                      appStoreUrl: project.appStoreUrl,
                      theme: theme,
                    ),
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }
}

class _Glass3DProjectCard extends StatelessWidget {
  const _Glass3DProjectCard({
    required this.id,
    required this.title,
    required this.description,
    required this.tech,
    required this.icon,
    this.imageUrl,
    this.googlePlayUrl,
    this.appStoreUrl,
    required this.theme,
  });

  final String id;
  final String title;
  final String description;
  final List<String> tech;
  final IconData icon;
  final String? imageUrl;
  final String? googlePlayUrl;
  final String? appStoreUrl;
  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    final hasImage = imageUrl != null && imageUrl!.isNotEmpty;

    return GestureDetector(
      onTap: () => context.go('/projects/$id'),
      child: TiltHoverCard(
        invertTilt: true,
        tiltStrength: 0.08,
        followSpeed: 14,
        hoverLift: 4,
        builder: (context, isHovered) {
          return AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            curve: Curves.easeOutSine,
            clipBehavior: Clip.hardEdge,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24),
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (hasImage)
                  ClipRRect(
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(23),
                    ),
                    child: SizedBox(
                      height: 140,
                      width: double.infinity,
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          _buildProjectImage(
                            imageUrl!,
                            fit: BoxFit.cover,
                            errorWidget: Container(
                              color: theme.colorScheme.surfaceContainerHighest,
                              child: Icon(
                                icon,
                                color: theme.colorScheme.primary.withValues(
                                  alpha: 0.4,
                                ),
                                size: 40,
                              ),
                            ),
                          ),
                          Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  Colors.transparent,
                                  Colors.black.withValues(alpha: 0.5),
                                ],
                                stops: const [0.4, 1.0],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(
                      20,
                      hasImage ? 14 : 28,
                      20,
                      20,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (!hasImage) ...[
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: theme.colorScheme.primary.withValues(
                                alpha: 0.1,
                              ),
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(
                                color: theme.colorScheme.primary.withValues(
                                  alpha: 0.2,
                                ),
                              ),
                            ),
                            child: Icon(
                              icon,
                              color: theme.colorScheme.primary,
                              size: 26,
                            ),
                          ),
                          const SizedBox(height: 20),
                        ],
                        Text(
                          title,
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: theme.colorScheme.onSurface,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 10),
                        Expanded(
                          child: Text(
                            description,
                            style: theme.textTheme.bodySmall?.copyWith(
                              height: 1.6,
                            ),
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(height: 14),
                        Flexible(
                          flex: 0,
                          child: Wrap(
                            spacing: 6,
                            runSpacing: 6,
                            clipBehavior: Clip.hardEdge,
                            children: tech
                                .take(5)
                                .map(
                                  (t) => Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 10,
                                      vertical: 5,
                                    ),
                                    decoration: BoxDecoration(
                                      color: theme.colorScheme.primary
                                          .withValues(alpha: 0.08),
                                      borderRadius: BorderRadius.circular(6),
                                      border: Border.all(
                                        color: theme.colorScheme.primary
                                            .withValues(alpha: 0.15),
                                      ),
                                    ),
                                    child: Text(
                                      t,
                                      style: theme.textTheme.labelSmall
                                          ?.copyWith(
                                            color: theme.colorScheme.primary
                                                .withValues(alpha: 0.8),
                                            fontWeight: FontWeight.w500,
                                          ),
                                    ),
                                  ),
                                )
                                .toList(),
                          ),
                        ),
                        if (googlePlayUrl != null || appStoreUrl != null) ...[
                          const SizedBox(height: 14),
                          Flexible(
                            flex: 0,
                            child: Wrap(
                              spacing: 10,
                              runSpacing: 10,
                              clipBehavior: Clip.hardEdge,
                              children: [
                                if (googlePlayUrl != null)
                                  StoreButton(
                                    store: StoreType.googlePlay,
                                    url: googlePlayUrl!,
                                  ),
                                if (appStoreUrl != null)
                                  StoreButton(
                                    store: StoreType.appStore,
                                    url: appStoreUrl!,
                                  ),
                              ],
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

Widget _buildProjectImage(
  String url, {
  required BoxFit fit,
  required Widget errorWidget,
}) {
  if (url.startsWith('assets/')) {
    return Image.asset(url, fit: fit, errorBuilder: (_, _, _) => errorWidget);
  }
  return Image.network(url, fit: fit, errorBuilder: (_, _, _) => errorWidget);
}
