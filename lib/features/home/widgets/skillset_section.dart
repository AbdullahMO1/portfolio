import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:portoflio/core/config/story_config.dart';
import 'package:portoflio/core/providers/portfolio_provider.dart';
import 'package:portoflio/core/providers/story_config_provider.dart';
import 'package:portoflio/shared/widgets/scroll_reveal.dart';
import 'package:portoflio/shared/widgets/story_banner.dart';
import 'package:portoflio/shared/widgets/tilt_hover_card.dart';

/// Home-only "The Skillset" section; first 4 skill categories from resume (Gist/local).
class SkillsetSection extends ConsumerWidget {
  const SkillsetSection({super.key});

  static const List<IconData> _categoryIcons = [
    Icons.account_tree_rounded,
    Icons.speed_rounded,
    Icons.palette_rounded,
    Icons.groups_rounded,
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final screenWidth = MediaQuery.sizeOf(context).width;
    final isDesktop = screenWidth >= 1200;
    final asyncResume = ref.watch(portfolioDataProvider);
    final story = ref.watch(storyConfigProvider);
    final chapter = story.chapterBySectionKey('skills');
    final categories = asyncResume.value?.skills ?? [];
    var skills = categories.take(4).toList().asMap().entries.map((e) {
      final i = e.key;
      final cat = e.value;
      return _SkillCardData(
        icon: i < _categoryIcons.length
            ? _categoryIcons[i]
            : Icons.star_rounded,
        title: cat.category,
        description: cat.items.map((e) => e.name).join(', '),
      );
    }).toList();
    if (skills.isEmpty) {
      skills = [
        const _SkillCardData(
          icon: Icons.account_tree_rounded,
          title: 'Architecture',
          description: 'Clean architecture, modular design.',
        ),
        const _SkillCardData(
          icon: Icons.speed_rounded,
          title: 'Performance',
          description: 'Optimization and lean widget trees.',
        ),
        const _SkillCardData(
          icon: Icons.palette_rounded,
          title: 'UI/UX',
          description: 'Pixel-perfect implementation.',
        ),
        const _SkillCardData(
          icon: Icons.groups_rounded,
          title: 'Leadership',
          description: 'Mentoring and delivery.',
        ),
      ];
    }

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
              child: StoryBanner(
                chapter:
                    chapter ??
                    const StoryChapter(
                      key: 'skills',
                      title: 'Skills',
                      subtitle: 'Sharp tools, steady hands',
                      storyLine:
                          'Knowing your tools is half the work. The other half is knowing when to put them down and think.',
                      persianElement: 'craft',
                    ),
                chapterIndex: 1,
                textAlign: isDesktop ? TextAlign.start : TextAlign.center,
              ),
            ),
            const SizedBox(height: 48),
            LayoutBuilder(
              builder: (context, constraints) {
                final crossAxisCount = isDesktop
                    ? 4
                    : (screenWidth >= 600 ? 2 : 1);
                return GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: crossAxisCount,
                    mainAxisSpacing: 24,
                    crossAxisSpacing: 24,
                    childAspectRatio: isDesktop ? 0.9 : 1.7,
                  ),
                  itemCount: skills.length,
                  itemBuilder: (context, index) {
                    final skill = skills[index];
                    return ScrollReveal(
                      delay: Duration(milliseconds: index * 80),
                      direction: RevealDirection.scale,
                      child: _SkillCard(
                        icon: skill.icon,
                        title: skill.title,
                        description: skill.description,
                        theme: theme,
                      ),
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _SkillCardData {
  const _SkillCardData({
    required this.icon,
    required this.title,
    required this.description,
  });
  final IconData icon;
  final String title;
  final String description;
}

class _SkillCard extends StatelessWidget {
  const _SkillCard({
    required this.icon,
    required this.title,
    required this.description,
    required this.theme,
  });

  final IconData icon;
  final String title;
  final String description;
  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    return TiltHoverCard(
      invertTilt: true,
      tiltStrength: 0.08,
      followSpeed: 14,
      hoverLift: 4,
      builder: (context, isHovered) {
        return AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          curve: Curves.easeOutSine,
          padding: const EdgeInsets.all(28),
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
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: isHovered
                      ? theme.colorScheme.primary
                      : theme.colorScheme.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: theme.colorScheme.primary.withValues(alpha: 0.2),
                  ),
                ),
                child: Icon(
                  icon,
                  color: isHovered
                      ? theme.colorScheme.onPrimary
                      : theme.colorScheme.primary,
                  size: 28,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                title,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: theme.colorScheme.onSurface,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 10),
              Text(
                description,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                  height: 1.6,
                ),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        );
      },
    );
  }
}
