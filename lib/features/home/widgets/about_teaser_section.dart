import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:portoflio/shared/widgets/scroll_reveal.dart';
import 'package:url_launcher/url_launcher.dart';

/// Home CTA section: "Ready to build something extraordinary?"
/// Matches code.html footer/CTA block with Start a Project button and social icons.
class AboutTeaserSection extends StatelessWidget {
  const AboutTeaserSection({super.key});

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
      child: ScrollReveal(
        direction: RevealDirection.fromBottom,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(32),
          child: BackdropFilter(
            filter: ui.ImageFilter.blur(sigmaX: 16, sigmaY: 16),
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.all(isDesktop ? 80 : 48),
              decoration: BoxDecoration(
                color: theme.colorScheme.surface.withValues(alpha: 0.7),
                borderRadius: BorderRadius.circular(32),
                border: Border.all(
                  color: theme.colorScheme.primary.withValues(alpha: 0.15),
                ),
              ),
              child: Column(
                children: [
                  Container(
                    width: double.infinity,
                    height: 4,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.transparent,
                          theme.colorScheme.primary.withValues(alpha: 0.5),
                          Colors.transparent,
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 48),
                  RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      style: theme.textTheme.headlineLarge?.copyWith(
                        fontSize: isDesktop ? 64 : 40,
                        fontWeight: FontWeight.w700,
                        color: theme.colorScheme.onSurface,
                        height: 1.2,
                      ),
                      children: [
                        const TextSpan(text: 'Ready to build something '),
                        TextSpan(
                          text: 'extraordinary?',
                          style: TextStyle(
                            color: theme.colorScheme.primary,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    "I'm currently accepting select projects for Q3 & Q4 2024. Let's discuss your vision.",
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                      height: 1.6,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 40),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _StartProjectButton(theme: theme),
                      const SizedBox(width: 24),
                      _SocialIconButton(
                        icon: Icons.alternate_email_rounded,
                        onTap: () =>
                            launchUrl(Uri.parse('mailto:your.email@example.com')),
                        theme: theme,
                      ),
                      const SizedBox(width: 16),
                      _SocialIconButton(
                        icon: Icons.link_rounded,
                        onTap: () =>
                            launchUrl(Uri.parse('https://linkedin.com')),
                        theme: theme,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _StartProjectButton extends StatelessWidget {
  const _StartProjectButton({required this.theme});
  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.go('/contact'),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 20),
        decoration: BoxDecoration(
          color: theme.colorScheme.primary,
          borderRadius: BorderRadius.circular(999),
          boxShadow: [
            BoxShadow(
              color: theme.colorScheme.primary.withValues(alpha: 0.3),
              blurRadius: 30,
            ),
          ],
        ),
        child: Text(
          'Start a Project',
          style: theme.textTheme.titleMedium?.copyWith(
            color: theme.colorScheme.onPrimary,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
    );
  }
}

class _SocialIconButton extends StatelessWidget {
  const _SocialIconButton({
    required this.icon,
    required this.onTap,
    required this.theme,
  });
  final IconData icon;
  final VoidCallback onTap;
  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: theme.colorScheme.primary.withValues(alpha: 0.3),
          ),
          color: theme.colorScheme.surface.withValues(alpha: 0.5),
        ),
        child: Icon(icon, color: theme.colorScheme.primary, size: 22),
      ),
    );
  }
}
