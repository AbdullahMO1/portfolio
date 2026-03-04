import 'package:flutter/material.dart';
import 'package:portoflio/shared/widgets/scroll_reveal.dart';
import 'package:portoflio/shared/widgets/tilt_hover_card.dart';

/// Home-only "The Skillset" section with 4 core expertise cards.
/// Matches Stitch wireframe: Advanced Architecture, Performance, UI/UX, Team Leadership.
class SkillsetSection extends StatelessWidget {
  const SkillsetSection({super.key});

  static const List<_SkillCardData> _skills = [
    _SkillCardData(
      icon: Icons.account_tree_rounded,
      title: 'Advanced Architecture',
      description:
          'Clean architecture, BLoC, and Provider patterns for enterprise-grade scalability.',
    ),
    _SkillCardData(
      icon: Icons.speed_rounded,
      title: 'Performance Optimization',
      description:
          '60FPS animations, frame budget management, and lean widget trees.',
    ),
    _SkillCardData(
      icon: Icons.palette_rounded,
      title: 'UI/UX Mastery',
      description:
          'Pixel-perfect implementation of complex designs with custom painters and shaders.',
    ),
    _SkillCardData(
      icon: Icons.groups_rounded,
      title: 'Team Leadership',
      description:
          'Mentoring developers, CI/CD pipeline management, and agile delivery.',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final screenWidth = MediaQuery.sizeOf(context).width;
    final isDesktop = screenWidth >= 1200;

    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(
        horizontal: isDesktop ? 100 : 24,
        vertical: 80,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ScrollReveal(
            child: isDesktop
                ? Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'THE SKILLSET',
                            style: theme.textTheme.labelMedium?.copyWith(
                              color: theme.colorScheme.primary,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 3,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Core Expertise',
                            style: theme.textTheme.headlineLarge?.copyWith(
                              fontSize: 48,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        width: 280,
                        child: Text(
                          "Pushing the boundaries of what's possible on mobile screens.",
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                            fontStyle: FontStyle.italic,
                            height: 1.5,
                          ),
                        ),
                      ),
                    ],
                  )
                : Column(
                    children: [
                      Text(
                        'THE SKILLSET',
                        style: theme.textTheme.labelMedium?.copyWith(
                          color: theme.colorScheme.primary,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 3,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Core Expertise',
                        style: theme.textTheme.headlineLarge,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        "Pushing the boundaries of what's possible on mobile screens.",
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                          fontStyle: FontStyle.italic,
                          height: 1.5,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
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
                  childAspectRatio: isDesktop ? 0.9 : 1.0,
                ),
                itemCount: _skills.length,
                itemBuilder: (context, index) {
                  final skill = _skills[index];
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
