import 'package:flutter/material.dart';
import 'package:portoflio/shared/widgets/three_d_scroll_wrapper.dart';
import 'package:url_launcher/url_launcher.dart';

class Footer extends StatelessWidget {
  const Footer({required this.scrollController, super.key});

  final ScrollController scrollController;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final size = MediaQuery.sizeOf(context);
    final isDesktop = size.width >= 1200;

    return ThreeDScrollWrapper(
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(
          horizontal: isDesktop ? 120 : 24,
          vertical: 48,
        ),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              theme.colorScheme.surface.withValues(alpha: 0.0),
              theme.colorScheme.surface.withValues(alpha: 0.6),
              theme.colorScheme.surface,
            ],
          ),
        ),
        child: Column(
          children: [
            Divider(
              color: theme.colorScheme.primary.withValues(alpha: 0.1),
              thickness: 1,
            ),
            const SizedBox(height: 40),
            isDesktop
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '© ${DateTime.now().year} Abdullah Mohammed. All rights reserved.',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant
                              .withValues(alpha: 0.7),
                        ),
                      ),
                      Row(
                        children: [
                          _FooterLink(
                            label: 'Privacy',
                            onTap: () {},
                            inline: true,
                          ),
                          const SizedBox(width: 32),
                          _FooterLink(
                            label: 'Terms',
                            onTap: () {},
                            inline: true,
                          ),
                          const SizedBox(width: 32),
                          _FooterLink(
                            label: 'LinkedIn',
                            onTap: () =>
                                launchUrl(Uri.parse('https://linkedin.com')),
                            inline: true,
                          ),
                        ],
                      ),
                      _buildBackToTop(theme),
                    ],
                  )
                : Column(
                    children: [
                      Text(
                        '© ${DateTime.now().year} Abdullah Mohammed. All rights reserved.',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant
                              .withValues(alpha: 0.7),
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      Wrap(
                        alignment: WrapAlignment.center,
                        spacing: 24,
                        children: [
                          _FooterLink(
                            label: 'Privacy',
                            onTap: () {},
                            inline: true,
                          ),
                          _FooterLink(
                            label: 'Terms',
                            onTap: () {},
                            inline: true,
                          ),
                          _FooterLink(
                            label: 'LinkedIn',
                            onTap: () =>
                                launchUrl(Uri.parse('https://linkedin.com')),
                            inline: true,
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      _buildBackToTop(theme),
                    ],
                  ),
          ],
        ),
      ),
    );
  }

  Widget _buildBackToTop(ThemeData theme) {
    return TextButton.icon(
      onPressed: () {
        scrollController.animateTo(
          0,
          duration: const Duration(milliseconds: 1500),
          curve: Curves.fastOutSlowIn,
        );
      },
      icon: Icon(
        Icons.arrow_upward_rounded,
        size: 18,
        color: theme.colorScheme.primary,
      ),
      label: Text(
        'BACK TO TOP',
        style: theme.textTheme.labelLarge?.copyWith(
          color: theme.colorScheme.primary,
          fontWeight: FontWeight.w800,
          letterSpacing: 1.2,
        ),
      ),
    );
  }
}

class _FooterLink extends StatefulWidget {
  const _FooterLink({
    required this.label,
    required this.onTap,
    this.inline = false,
  });
  final String label;
  final VoidCallback onTap;
  final bool inline;

  @override
  State<_FooterLink> createState() => _FooterLinkState();
}

class _FooterLinkState extends State<_FooterLink> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: widget.inline ? EdgeInsets.zero : const EdgeInsets.only(bottom: 12),
      child: MouseRegion(
        onEnter: (_) => setState(() => _isHovered = true),
        onExit: (_) => setState(() => _isHovered = false),
        child: GestureDetector(
          onTap: widget.onTap,
          child: AnimatedDefaultTextStyle(
            duration: const Duration(milliseconds: 200),
            style: theme.textTheme.bodySmall!.copyWith(
              color: _isHovered
                  ? theme.colorScheme.primary
                  : theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.8),
              fontWeight: _isHovered ? FontWeight.w600 : FontWeight.w400,
            ),
            child: Text(widget.label),
          ),
        ),
      ),
    );
  }
}

class _SocialIcon extends StatefulWidget {
  const _SocialIcon({required this.icon, required this.url});
  final IconData icon;
  final String url;

  @override
  State<_SocialIcon> createState() => _SocialIconState();
}

class _SocialIconState extends State<_SocialIcon> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: () => launchUrl(Uri.parse(widget.url)),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: _isHovered
                ? theme.colorScheme.primary
                : theme.colorScheme.surfaceContainerHigh.withValues(alpha: 0.3),
            shape: BoxShape.circle,
            border: Border.all(
              color: _isHovered
                  ? theme.colorScheme.primary
                  : theme.colorScheme.outline.withValues(alpha: 0.1),
            ),
          ),
          child: Icon(
            widget.icon,
            size: 20,
            color: _isHovered
                ? theme.colorScheme.onPrimary
                : theme.colorScheme.onSurface,
          ),
        ),
      ),
    );
  }
}

class _MagneticWrapper extends StatefulWidget {
  const _MagneticWrapper({required this.child, required this.onTap});
  final Widget child;
  final VoidCallback onTap;

  @override
  State<_MagneticWrapper> createState() => _MagneticWrapperState();
}

class _MagneticWrapperState extends State<_MagneticWrapper> {
  Offset _offset = Offset.zero;
  bool _isHovered = false;

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
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOutCubic,
          transform: Matrix4.identity()
            ..translateByDouble(_offset.dx, _offset.dy, 0, 1)
            ..scaleByDouble(
              _isHovered ? 1.05 : 1.0,
              _isHovered ? 1.05 : 1.0,
              1,
              1,
            ),
          transformAlignment: Alignment.center,
          child: widget.child,
        ),
      ),
    );
  }
}
