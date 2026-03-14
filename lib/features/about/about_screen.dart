import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:portoflio/core/providers/portfolio_provider.dart';
import 'package:portoflio/core/providers/story_config_provider.dart';
import 'package:portoflio/core/config/story_config.dart';
import 'package:portoflio/features/about/widgets/profile_card.dart';
import 'package:portoflio/shared/widgets/scroll_reveal.dart';
import 'package:portoflio/theme/app_theme.dart';

/// About section with data from resume (Gist/local).
class AboutScreen extends ConsumerWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final screenWidth = MediaQuery.sizeOf(context).width;
    final isDesktop = screenWidth >= 1200;
    final asyncResume = ref.watch(portfolioDataProvider);
    final story = ref.watch(storyConfigProvider);
    final chapter = story.chapterBySectionKey('about');

    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(
        horizontal: isDesktop ? 100 : 24,
        vertical: 80,
      ),
      child: asyncResume.when(
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
              'Failed to load about: $err',
              style: theme.textTheme.bodyLarge,
            ),
          ),
        ),
        data: (resume) {
          final meta = resume.meta;
          return Column(
            children: [
              ScrollReveal(
                child: _SectionTitle(
                  title: chapter?.title ?? 'About Me',
                  theme: theme,
                ),
              ),
              const SizedBox(height: 60),
              isDesktop
                  ? Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ScrollReveal(
                          direction: RevealDirection.fromLeft,
                          child: ProfileCard(
                            name: meta.name,
                            tagline: meta.tagline,
                            avatarUrl: meta.avatarUrl,
                          ),
                        ),
                        const SizedBox(width: 80),
                        Expanded(
                          child: ScrollReveal(
                            delay: const Duration(milliseconds: 200),
                            direction: RevealDirection.fromRight,
                            child: _AboutContent(
                              theme: theme,
                              about: resume.about,
                            ),
                          ),
                        ),
                      ],
                    )
                  : Column(
                      children: [
                        ScrollReveal(
                          direction: RevealDirection.scale,
                          child: ProfileCard(
                            name: meta.name,
                            tagline: meta.tagline,
                            avatarUrl: meta.avatarUrl,
                          ),
                        ),
                        const SizedBox(height: 48),
                        ScrollReveal(
                          delay: const Duration(milliseconds: 200),
                          child: _AboutContent(
                            theme: theme,
                            about: resume.about,
                          ),
                        ),
                      ],
                    ),
              const SizedBox(height: 60),
              Wrap(
                spacing: 20,
                runSpacing: 20,
                alignment: WrapAlignment.center,
                children: [
                  ScrollReveal(
                    delay: const Duration(milliseconds: 300),
                    direction: RevealDirection.scale,
                    child: _GlowStatCard(
                      label: 'Years Experience',
                      value: '5+',
                      theme: theme,
                    ),
                  ),
                  ScrollReveal(
                    delay: const Duration(milliseconds: 450),
                    direction: RevealDirection.scale,
                    child: _GlowStatCard(
                      label: 'Apps Delivered',
                      value: '15+',
                      theme: theme,
                    ),
                  ),
                  ScrollReveal(
                    delay: const Duration(milliseconds: 600),
                    direction: RevealDirection.scale,
                    child: _GlowStatCard(
                      label: 'Team Size Led',
                      value: '8+',
                      theme: theme,
                    ),
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({required this.title, required this.theme});
  final String title;
  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(title, style: AppTheme.storyTitleStyle(fontSize: 36)),
        const SizedBox(height: 12),
        Container(
          width: 60,
          height: 3,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [theme.colorScheme.primary, theme.colorScheme.tertiary],
            ),
            borderRadius: BorderRadius.circular(2),
          ),
        ),
      ],
    );
  }
}

class _AboutContent extends StatelessWidget {
  const _AboutContent({required this.theme, required this.about});
  final ThemeData theme;
  final String about;

  @override
  Widget build(BuildContext context) {
    final paragraphs = about.split(RegExp(r'\n\n+'));
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (final p in paragraphs) ...[
          if (p.trim().isNotEmpty)
            Text(p.trim(), style: theme.textTheme.bodyLarge),
          if (p != paragraphs.last) const SizedBox(height: 20),
        ],
      ],
    );
  }
}

class _GlowStatCard extends StatefulWidget {
  const _GlowStatCard({
    required this.label,
    required this.value,
    required this.theme,
  });

  final String label;
  final String value;
  final ThemeData theme;

  @override
  State<_GlowStatCard> createState() => _GlowStatCardState();
}

class _GlowStatCardState extends State<_GlowStatCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOutCubic,
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
        decoration: BoxDecoration(
          color: widget.theme.colorScheme.surfaceContainerHigh.withValues(
            alpha: _isHovered ? 0.5 : 0.3,
          ),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: _isHovered
                ? widget.theme.colorScheme.primary.withValues(alpha: 0.4)
                : widget.theme.colorScheme.outline.withValues(alpha: 0.1),
          ),
          boxShadow: _isHovered
              ? [
                  BoxShadow(
                    color: widget.theme.colorScheme.primary.withValues(
                      alpha: 0.1,
                    ),
                    blurRadius: 30,
                    spreadRadius: 2,
                  ),
                ]
              : null,
        ),
        child: Column(
          children: [
            ShaderMask(
              shaderCallback: (bounds) => LinearGradient(
                colors: [
                  widget.theme.colorScheme.primary,
                  widget.theme.colorScheme.tertiary,
                ],
              ).createShader(bounds),
              child: Text(
                widget.value,
                style: widget.theme.textTheme.displayMedium?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
            const SizedBox(height: 6),
            Text(
              widget.label,
              style: widget.theme.textTheme.bodySmall?.copyWith(
                color: widget.theme.colorScheme.onSurfaceVariant,
                letterSpacing: 1.0,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
