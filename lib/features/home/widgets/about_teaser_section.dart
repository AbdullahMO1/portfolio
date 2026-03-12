import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:portoflio/core/providers/portfolio_provider.dart';
import 'package:portoflio/core/providers/story_config_provider.dart';
import 'package:portoflio/core/config/story_config.dart';
import 'package:portoflio/shared/widgets/scroll_reveal.dart';
import 'package:portoflio/shared/widgets/story_banner.dart';
import 'package:portoflio/shared/widgets/magnetic_button.dart';
import 'package:url_launcher/url_launcher.dart';

/// Home CTA section; email and social links from resume (Gist/local).
class AboutTeaserSection extends ConsumerWidget {
  const AboutTeaserSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final screenWidth = MediaQuery.sizeOf(context).width;
    final isDesktop = screenWidth >= 1200;
    final asyncResume = ref.watch(portfolioDataProvider);
    final story = ref.watch(storyConfigProvider);
    final chapter = story.chapterBySectionKey('about');
    final meta = asyncResume.value?.meta;
    final email = meta?.email ?? '';
    final linkedin = meta?.linkedin ?? '';
    final github = meta?.github ?? '';

    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: isDesktop ? 72 : 20,
          vertical: 40,
        ),
        child: ScrollReveal(
          direction: RevealDirection.fromBottom,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ClipRRect(
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
                        color: theme.colorScheme.primary.withValues(
                          alpha: 0.15,
                        ),
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
                                theme.colorScheme.primary.withValues(
                                  alpha: 0.5,
                                ),
                                Colors.transparent,
                              ],
                            ),
                          ),
                        ),
                        StoryBanner(
                          chapter:
                              chapter ??
                              const StoryChapter(
                                key: 'about',
                                title: 'The Royal Record',
                                subtitle:
                                    'The history and future of the Prince',
                                storyLine:
                                    'The journey continues beyond the horizon, seeking new domains to conquer.',
                                persianElement: 'record',
                              ),
                          chapterIndex: 4,
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 40),
                        Wrap(
                          alignment: WrapAlignment.center,
                          spacing: 16,
                          runSpacing: 16,
                          children: [
                            _StartProjectButton(theme: theme),
                            if (email.isNotEmpty)
                              _SocialIconButton(
                                icon: Icons.alternate_email_rounded,
                                onTap: () =>
                                    launchUrl(Uri.parse('mailto:$email')),
                                theme: theme,
                              ),
                            if (linkedin.isNotEmpty)
                              _SocialIconButton(
                                icon: Icons.link_rounded,
                                onTap: () => launchUrl(Uri.parse(linkedin)),
                                theme: theme,
                              ),
                            if (github.isNotEmpty)
                              _SocialIconButton(
                                icon: Icons.code_rounded,
                                onTap: () => launchUrl(Uri.parse(github)),
                                theme: theme,
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
      ),
    );
  }
}

class _StartProjectButton extends StatelessWidget {
  const _StartProjectButton({required this.theme});
  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    return MagneticButton(
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
    return MagneticButton(
      onTap: onTap,
      magneticStrength: 0.4,
      scaleOnHover: 1.12,
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
