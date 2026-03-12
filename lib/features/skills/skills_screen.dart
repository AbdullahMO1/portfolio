import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:portoflio/core/models/resume_model.dart';
import 'package:portoflio/core/providers/portfolio_provider.dart';
import 'package:portoflio/core/providers/story_config_provider.dart';
import 'package:portoflio/core/config/story_config.dart';
import 'package:portoflio/shared/widgets/scroll_reveal.dart';
import 'package:portoflio/theme/app_theme.dart';

class SkillsScreen extends ConsumerWidget {
  const SkillsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final screenWidth = MediaQuery.sizeOf(context).width;
    final asyncResume = ref.watch(portfolioDataProvider);
    final story = ref.watch(storyConfigProvider);
    final chapter = story.chapterBySectionKey('skills');

    final double horizontalPadding;
    if (screenWidth >= 1200) {
      horizontalPadding = 100;
    } else if (screenWidth >= 768) {
      horizontalPadding = 48;
    } else {
      horizontalPadding = 24;
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(vertical: 80),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1400),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ScrollReveal(
                  duration: const Duration(milliseconds: 400),
                  offset: 20,
                  child: Center(
                    child: Column(
                      children: [
                        Text(
                          chapter?.title ?? 'The Craft',
                          style: AppTheme.storyTitleStyle(fontSize: screenWidth < 400 ? 26 : 36),
                          textAlign: TextAlign.center,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 12),
                        Container(
                          width: 60,
                          height: 3,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(colors: [theme.colorScheme.primary, theme.colorScheme.tertiary]),
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
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
                asyncResume.when(
                  loading: () => const Center(
                    child: Padding(padding: EdgeInsets.all(48), child: CircularProgressIndicator()),
                  ),
                  error: (err, _) => Center(
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Text('Failed to load skills: $err', style: theme.textTheme.bodyLarge),
                    ),
                  ),
                  data: (resume) {
                    final categories = resume.skills;
                    if (categories.isEmpty) {
                      return Center(child: Text('No skills listed.', style: theme.textTheme.bodyLarge));
                    }
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: categories.asMap().entries.map((mapEntry) {
                        final index = mapEntry.key;
                        final cat = mapEntry.value;
                        return ScrollReveal(
                          delay: Duration(milliseconds: index * 50),
                          duration: const Duration(milliseconds: 400),
                          offset: 20,
                          direction: RevealDirection.fromBottom,
                          child: _SkillCategoryGroup(
                            category: cat.category,
                            skills: cat.items,
                            theme: theme,
                            screenWidth: screenWidth,
                          ),
                        );
                      }).toList(),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _SkillCategoryGroup extends StatelessWidget {
  const _SkillCategoryGroup({
    required this.category,
    required this.skills,
    required this.theme,
    required this.screenWidth,
  });

  final String category;
  final List<SkillItem> skills;
  final ThemeData theme;
  final double screenWidth;

  @override
  Widget build(BuildContext context) {
    final int crossAxisCount;
    if (screenWidth >= 1200) {
      crossAxisCount = 4;
    } else if (screenWidth >= 768) {
      crossAxisCount = 3;
    } else if (screenWidth >= 480) {
      crossAxisCount = 2;
    } else {
      crossAxisCount = 2;
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 36),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(category, style: theme.textTheme.titleLarge?.copyWith(color: theme.colorScheme.primary)),
          const SizedBox(height: 14),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: crossAxisCount,
              mainAxisSpacing: 10,
              crossAxisSpacing: 10,
              childAspectRatio: 2.7,
            ),
            itemCount: skills.length,
            itemBuilder: (context, index) {
              return _GlassSkillChip(skill: skills[index], theme: theme);
            },
          ),
        ],
      ),
    );
  }
}

class _GlassSkillChip extends StatefulWidget {
  const _GlassSkillChip({required this.skill, required this.theme});
  final SkillItem skill;
  final ThemeData theme;

  @override
  State<_GlassSkillChip> createState() => _GlassSkillChipState();
}

class _GlassSkillChipState extends State<_GlassSkillChip> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 500));
    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeOutQuart, reverseCurve: Curves.easeInCubic);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Color _proficiencyColor(int proficiency) {
    if (proficiency >= 90) return const Color(0xFF22C55E);
    if (proficiency >= 75) return const Color(0xFF3B82F6);
    if (proficiency >= 60) return widget.theme.colorScheme.primary;
    return const Color(0xFFF59E0B);
  }

  String _proficiencyLabel(int proficiency) {
    if (proficiency >= 90) return 'Expert';
    if (proficiency >= 75) return 'Advanced';
    if (proficiency >= 60) return 'Proficient';
    return 'Familiar';
  }

  @override
  Widget build(BuildContext context) {
    final proficiency = widget.skill.proficiency;
    final barColor = _proficiencyColor(proficiency);
    final theme = widget.theme;

    return MouseRegion(
      onEnter: (_) => _controller.forward(),
      onExit: (_) => _controller.reverse(),
      cursor: SystemMouseCursors.click,
      child: AnimatedBuilder(
        animation: _animation,
        builder: (context, _) {
          final t = _animation.value;
          return Transform.translate(
            offset: Offset(0, -2.0 * t),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
              decoration: BoxDecoration(
                color: Color.lerp(
                  theme.colorScheme.surfaceContainerHigh.withValues(alpha: 0.3),
                  theme.colorScheme.primary.withValues(alpha: 0.12),
                  t,
                ),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: Color.lerp(
                    theme.colorScheme.outline.withValues(alpha: 0.1),
                    theme.colorScheme.primary.withValues(alpha: 0.4),
                    t,
                  )!,
                ),
                boxShadow: t > 0.01
                    ? [
                        BoxShadow(
                          color: theme.colorScheme.primary.withValues(alpha: 0.08 * t),
                          blurRadius: 12 * t,
                          offset: Offset(0, 3 * t),
                        ),
                      ]
                    : null,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.skill.name,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: Color.lerp(theme.colorScheme.onSurface, theme.colorScheme.primary, t),
                      fontWeight: t > 0.5 ? FontWeight.w600 : FontWeight.w400,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizeTransition(
                    sizeFactor: _animation,
                    axisAlignment: -1.0,
                    child: FadeTransition(
                      opacity: _animation,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 10),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(4),
                              child: SizedBox(
                                height: 5,
                                child: LayoutBuilder(
                                  builder: (context, constraints) {
                                    return Stack(
                                      children: [
                                        Container(
                                          width: constraints.maxWidth,
                                          decoration: BoxDecoration(
                                            color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.4),
                                            borderRadius: BorderRadius.circular(4),
                                          ),
                                        ),
                                        AnimatedBuilder(
                                          animation: _animation,
                                          builder: (context, _) {
                                            return Container(
                                              width: constraints.maxWidth * (proficiency / 100.0) * _animation.value,
                                              decoration: BoxDecoration(
                                                gradient: LinearGradient(
                                                  colors: [barColor.withValues(alpha: 0.7), barColor],
                                                ),
                                                borderRadius: BorderRadius.circular(4),
                                                boxShadow: [
                                                  BoxShadow(color: barColor.withValues(alpha: 0.3), blurRadius: 4),
                                                ],
                                              ),
                                            );
                                          },
                                        ),
                                      ],
                                    );
                                  },
                                ),
                              ),
                            ),
                            const SizedBox(height: 5),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  _proficiencyLabel(proficiency),
                                  style: theme.textTheme.labelSmall?.copyWith(
                                    color: barColor,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 10,
                                  ),
                                ),
                                Text(
                                  '$proficiency%',
                                  style: theme.textTheme.labelSmall?.copyWith(
                                    color: theme.colorScheme.onSurfaceVariant,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 10,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
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
