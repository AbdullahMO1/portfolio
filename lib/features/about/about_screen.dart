import 'package:flutter/material.dart';
import 'package:portoflio/features/about/widgets/profile_card.dart';
import 'package:portoflio/shared/widgets/scroll_reveal.dart';

/// About section with glassmorphism 3D profile card, animated bio,
/// and scroll-reveal stat cards.
class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

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
        children: [
          // Section title
          ScrollReveal(
            child: _SectionTitle(title: 'About Me', theme: theme),
          ),
          const SizedBox(height: 60),
          // Content
          isDesktop
              ? Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const ScrollReveal(
                      direction: RevealDirection.fromLeft,
                      child: ProfileCard(),
                    ),
                    const SizedBox(width: 80),
                    Expanded(
                      child: ScrollReveal(
                        delay: const Duration(milliseconds: 200),
                        direction: RevealDirection.fromRight,
                        child: _AboutContent(theme: theme),
                      ),
                    ),
                  ],
                )
              : Column(
                  children: [
                    const ScrollReveal(
                      direction: RevealDirection.scale,
                      child: ProfileCard(),
                    ),
                    const SizedBox(height: 48),
                    ScrollReveal(
                      delay: const Duration(milliseconds: 200),
                      child: _AboutContent(theme: theme),
                    ),
                  ],
                ),
          const SizedBox(height: 60),
          // Stats row
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
        Text(title, style: theme.textTheme.headlineLarge),
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
  const _AboutContent({required this.theme});
  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Passionate Flutter developer with extensive experience building '
          'production-ready mobile and web applications. I specialize in '
          'clean architecture, performance optimization, and creating '
          'delightful user experiences with advanced animations.',
          style: theme.textTheme.bodyLarge,
        ),
        const SizedBox(height: 20),
        Text(
          'As a team lead, I focus on code quality, mentoring developers, '
          'and establishing engineering best practices that scale. My work '
          'combines deep technical knowledge with a keen eye for design.',
          style: theme.textTheme.bodyLarge,
        ),
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
