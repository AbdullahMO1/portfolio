import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:portoflio/core/providers/portfolio_provider.dart';
import 'package:portoflio/core/providers/story_config_provider.dart';
import 'package:portoflio/core/config/story_config.dart';
import 'package:portoflio/shared/widgets/scroll_reveal.dart';
import 'package:portoflio/theme/app_theme.dart';

/// Skills screen with data from resume (Gist/local).
class SkillsScreen extends ConsumerWidget {
  const SkillsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final screenWidth = MediaQuery.sizeOf(context).width;
    final isDesktop = screenWidth >= 1200;
    final asyncResume = ref.watch(portfolioDataProvider);
    final story = ref.watch(storyConfigProvider);
    final chapter = story.chapterBySectionKey('skills');

    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: isDesktop ? 100 : 24, vertical: 80),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ScrollReveal(
            child: Center(
              child: Column(
                children: [
                  Text(chapter?.title ?? 'The Craft', style: AppTheme.storyTitleStyle(fontSize: 36)),
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
                    Text(chapter!.subtitle, style: AppTheme.narrativeStyle(fontSize: 16), textAlign: TextAlign.center),
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
                    delay: Duration(milliseconds: index * 100),
                    direction: index.isEven ? RevealDirection.fromLeft : RevealDirection.fromRight,
                    child: _SkillCategoryGroup(category: cat.category, skills: cat.items, theme: theme),
                  );
                }).toList(),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _SkillCategoryGroup extends StatelessWidget {
  const _SkillCategoryGroup({required this.category, required this.skills, required this.theme});

  final String category;
  final List<String> skills;
  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 36),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(category, style: theme.textTheme.titleLarge?.copyWith(color: theme.colorScheme.primary)),
          const SizedBox(height: 14),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: skills.asMap().entries.map((entry) {
              return _GlassSkillChip(label: entry.value, theme: theme);
            }).toList(),
          ),
        ],
      ),
    );
  }
}

class _GlassSkillChip extends StatefulWidget {
  const _GlassSkillChip({required this.label, required this.theme});
  final String label;
  final ThemeData theme;

  @override
  State<_GlassSkillChip> createState() => _GlassSkillChipState();
}

class _GlassSkillChipState extends State<_GlassSkillChip> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOutCubic,
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
        decoration: BoxDecoration(
          color: _isHovered
              ? widget.theme.colorScheme.primary.withValues(alpha: 0.15)
              : widget.theme.colorScheme.surfaceContainerHigh.withValues(alpha: 0.3),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: _isHovered
                ? widget.theme.colorScheme.primary.withValues(alpha: 0.5)
                : widget.theme.colorScheme.outline.withValues(alpha: 0.1),
          ),
          boxShadow: _isHovered
              ? [
                  BoxShadow(
                    color: widget.theme.colorScheme.primary.withValues(alpha: 0.1),
                    blurRadius: 15,
                    offset: const Offset(0, 4),
                  ),
                ]
              : null,
        ),
        // ignore: deprecated_member_use
        transform: Matrix4.identity()..scale(_isHovered ? 1.08 : 1.0),
        transformAlignment: Alignment.center,
        child: Text(
          widget.label,
          style: widget.theme.textTheme.bodyMedium?.copyWith(
            color: _isHovered ? widget.theme.colorScheme.primary : widget.theme.colorScheme.onSurface,
            fontWeight: _isHovered ? FontWeight.w600 : FontWeight.w400,
          ),
        ),
      ),
    );
  }
}
