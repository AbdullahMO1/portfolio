import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:portoflio/core/providers/story_config_provider.dart';
import 'package:portoflio/core/config/story_config.dart';
import 'package:portoflio/shared/widgets/scroll_reveal.dart';
import 'package:portoflio/theme/app_theme.dart';
import 'package:url_launcher/url_launcher.dart';

/// Contact section with:
/// - Floating orbs background effect
/// - Magnetic attract social buttons with gold glow
/// - Pulsing CTA
/// - ScrollReveal entrance
class ContactScreen extends ConsumerWidget {
  const ContactScreen({super.key});

  static const List<_SocialLink> _links = [
    _SocialLink(
      icon: Icons.email_rounded,
      label: 'Email',
      url: 'mailto:abdullahaboelkhair1@gmail.com',
    ),
    _SocialLink(
      icon: Icons.code_rounded,
      label: 'GitHub',
      url: 'https://github.com/AbdullahMO1',
    ),
    _SocialLink(
      icon: Icons.work_rounded,
      label: 'LinkedIn',
      url: 'https://www.linkedin.com/in/abdullah-mohammed-ali/',
    ),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final screenWidth = MediaQuery.sizeOf(context).width;
    final isDesktop = screenWidth >= 1200;
    final story = ref.watch(storyConfigProvider);
    final chapter = story.chapterBySectionKey('contact');

    return Center(
      child: SingleChildScrollView(
        padding: EdgeInsets.symmetric(
          horizontal: isDesktop ? 100 : 24,
          vertical: 80,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ScrollReveal(
              child: Column(
                children: [
                  Text(
                    chapter?.title ?? 'Let\'s Talk',
                    style: AppTheme.storyTitleStyle(fontSize: 36),
                    textAlign: TextAlign.center,
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
                      style: AppTheme.narrativeStyle(fontSize: 16),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(height: 24),
            ScrollReveal(
              delay: const Duration(milliseconds: 200),
              child: Text(
                chapter?.storyLine ??
                    'Good things start with a conversation.\nIf you\'ve got an idea, I\'d love to hear it.',
                style: GoogleFonts.amiri(
                  fontSize: 18,
                  fontStyle: FontStyle.italic,
                  color: theme.colorScheme.onSurfaceVariant,
                  height: 1.6,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 50),
            ScrollReveal(
              delay: const Duration(milliseconds: 400),
              direction: RevealDirection.scale,
              child: Wrap(
                spacing: 20,
                runSpacing: 20,
                alignment: WrapAlignment.center,
                children: _links
                    .map(
                      (link) => _MagneticSocialButton(link: link, theme: theme),
                    )
                    .toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SocialLink {
  const _SocialLink({
    required this.icon,
    required this.label,
    required this.url,
  });
  final IconData icon;
  final String label;
  final String url;
}

class _MagneticSocialButton extends StatefulWidget {
  const _MagneticSocialButton({required this.link, required this.theme});
  final _SocialLink link;
  final ThemeData theme;

  @override
  State<_MagneticSocialButton> createState() => _MagneticSocialButtonState();
}

class _MagneticSocialButtonState extends State<_MagneticSocialButton> {
  bool _isHovered = false;
  Offset _offset = Offset.zero;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() {
        _isHovered = false;
        _offset = Offset.zero;
      }),
      onHover: (event) {
        if (!_isHovered) return;
        final renderBox = context.findRenderObject() as RenderBox?;
        if (renderBox == null) return;
        final size = renderBox.size;
        final center = Offset(size.width / 2, size.height / 2);
        final delta = event.localPosition - center;
        setState(() {
          _offset = Offset(delta.dx * 0.15, delta.dy * 0.15);
        });
      },
      child: GestureDetector(
        onTap: () => launchUrl(Uri.parse(widget.link.url)),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOutCubic,
          // ignore: deprecated_member_use
          transform: Matrix4.identity()
            // ignore: deprecated_member_use
            ..translate(_offset.dx, _offset.dy)
            // ignore: deprecated_member_use
            ..scale(_isHovered ? 1.08 : 1.0),
          transformAlignment: Alignment.center,
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 20),
          decoration: BoxDecoration(
            color: _isHovered
                ? widget.theme.colorScheme.primary.withValues(alpha: 0.12)
                : widget.theme.colorScheme.surfaceContainerHigh.withValues(
                    alpha: 0.3,
                  ),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: _isHovered
                  ? widget.theme.colorScheme.primary.withValues(alpha: 0.5)
                  : widget.theme.colorScheme.outline.withValues(alpha: 0.1),
            ),
            boxShadow: _isHovered
                ? [
                    BoxShadow(
                      color: widget.theme.colorScheme.primary.withValues(
                        alpha: 0.15,
                      ),
                      blurRadius: 25,
                      offset: const Offset(0, 8),
                    ),
                  ]
                : null,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                widget.link.icon,
                color: _isHovered
                    ? widget.theme.colorScheme.primary
                    : widget.theme.colorScheme.onSurface,
              ),
              const SizedBox(width: 14),
              Text(
                widget.link.label,
                style: widget.theme.textTheme.labelLarge?.copyWith(
                  color: _isHovered
                      ? widget.theme.colorScheme.primary
                      : widget.theme.colorScheme.onSurface,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
