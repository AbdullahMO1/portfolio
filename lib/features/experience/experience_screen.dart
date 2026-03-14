import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:portoflio/core/models/resume_model.dart';
import 'package:portoflio/core/providers/portfolio_provider.dart';
import 'package:portoflio/core/providers/story_config_provider.dart';
import 'package:portoflio/core/config/story_config.dart';
import 'package:portoflio/shared/widgets/scroll_reveal.dart';
import 'package:portoflio/theme/app_theme.dart';

class ExperienceScreen extends ConsumerWidget {
  const ExperienceScreen({super.key});

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

    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(
        horizontal: isDesktop ? 100 : 24,
        vertical: 80,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ScrollReveal(
            child: Center(
              child: Column(
                children: [
                  Text(
                    chapter?.title ?? 'Experience',
                    style: AppTheme.storyTitleStyle(fontSize: 36),
                  ),
                  const SizedBox(height: 12),
                  const _ExperienceDivider(),
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
          _ExperienceGrid(
            experiences: experiences,
            theme: theme,
            isDesktop: isDesktop,
            isTablet: isTablet,
          ),
        ],
      ),
    );
  }
}

class _ExperienceDivider extends StatelessWidget {
  const _ExperienceDivider();
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      width: 60,
      height: 3,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [theme.colorScheme.primary, theme.colorScheme.tertiary],
        ),
        borderRadius: BorderRadius.circular(2),
      ),
    );
  }
}

class _ExperienceGrid extends StatelessWidget {
  const _ExperienceGrid({
    required this.experiences,
    required this.theme,
    required this.isDesktop,
    required this.isTablet,
  });

  final List<ExperienceEntry> experiences;
  final ThemeData theme;
  final bool isDesktop;
  final bool isTablet;

  @override
  Widget build(BuildContext context) {
    final gap = isDesktop ? 20.0 : 14.0;
    final useGrid = isDesktop || isTablet;

    if (!useGrid) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (int i = 0; i < experiences.length; i++) ...[
            ScrollReveal(
              delay: Duration(milliseconds: i * 100),
              direction: RevealDirection.fromBottom,
              child: _ExperienceCard(
                entry: experiences[i],
                theme: theme,
                compact: true,
              ),
            ),
            if (i < experiences.length - 1) SizedBox(height: gap),
          ],
        ],
      );
    }

    final leftItems = <int>[];
    final rightItems = <int>[];
    for (int i = 0; i < experiences.length; i++) {
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
                      entry: experiences[leftItems[i]],
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
                    entry: experiences[rightItems[i]],
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

class _ExperienceCard extends StatefulWidget {
  const _ExperienceCard({
    required this.entry,
    required this.theme,
    this.compact = false,
  });

  final ExperienceEntry entry;
  final ThemeData theme;
  final bool compact;

  @override
  State<_ExperienceCard> createState() => _ExperienceCardState();
}

class _ExperienceCardState extends State<_ExperienceCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final entry = widget.entry;
    final padding = widget.compact ? 16.0 : 24.0;

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        width: double.infinity,
        padding: EdgeInsets.all(padding),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: widget.theme.colorScheme.surfaceContainerHigh.withValues(
            alpha: _isHovered ? 0.4 : 0.2,
          ),
          border: Border.all(
            color: _isHovered
                ? widget.theme.colorScheme.primary.withValues(alpha: 0.3)
                : widget.theme.colorScheme.outline.withValues(alpha: 0.08),
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: _isHovered
                  ? widget.theme.colorScheme.primary.withValues(alpha: 0.08)
                  : Colors.black.withValues(alpha: 0.08),
              blurRadius: _isHovered ? 30 : 16,
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
                    entry.role,
                    style: widget.theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: widget.theme.colorScheme.onSurface,
                      fontSize: widget.compact ? 15 : 18,
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
                    color: widget.theme.colorScheme.primary.withValues(
                      alpha: 0.1,
                    ),
                    borderRadius: BorderRadius.circular(999),
                    border: Border.all(
                      color: widget.theme.colorScheme.primary.withValues(
                        alpha: 0.3,
                      ),
                    ),
                  ),
                  child: Text(
                    entry.period,
                    style: widget.theme.textTheme.labelSmall?.copyWith(
                      color: widget.theme.colorScheme.primary,
                      fontWeight: FontWeight.w600,
                      fontSize: widget.compact ? 10 : 11,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Text(
              entry.company,
              style: widget.theme.textTheme.bodyMedium?.copyWith(
                color: widget.theme.colorScheme.primary,
                fontWeight: FontWeight.w600,
                fontSize: widget.compact ? 13 : 14,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            if (entry.location.isNotEmpty) ...[
              const SizedBox(height: 4),
              Text(
                entry.location,
                style: widget.theme.textTheme.bodySmall?.copyWith(
                  color: widget.theme.colorScheme.onSurfaceVariant,
                  fontSize: widget.compact ? 11 : 12,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
            if (entry.highlights.isNotEmpty) ...[
              const SizedBox(height: 12),
              ...entry.highlights.map(
                (h) => Padding(
                  padding: const EdgeInsets.only(bottom: 6),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 6),
                        child: Container(
                          width: 5,
                          height: 5,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: widget.theme.colorScheme.primary.withValues(
                              alpha: 0.6,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          h,
                          style: widget.theme.textTheme.bodySmall?.copyWith(
                            color: widget.theme.colorScheme.onSurfaceVariant,
                            height: 1.5,
                            fontSize: widget.compact ? 12 : 13,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
