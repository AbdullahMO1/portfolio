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
          vertical: 80,
        ),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              theme.colorScheme.surface.withValues(alpha: 0.0),
              theme.colorScheme.surface.withValues(alpha: 0.8),
              theme.colorScheme.surface,
            ],
          ),
        ),
        child: Column(
          children: [
            // 1. "Get in Touch" Project Widget/Card
            _buildProjectWidget(theme, isDesktop),
            const SizedBox(height: 100),

            // 2. Main Footer Content
            if (isDesktop)
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildBrand(theme),
                  _buildLinks(theme),
                  _buildSocials(theme),
                ],
              )
            else
              Column(
                children: [
                  _buildBrand(theme),
                  const SizedBox(height: 48),
                  _buildSocials(theme),
                  const SizedBox(height: 48),
                  _buildLinks(theme),
                ],
              ),

            const SizedBox(height: 100),
            const Divider(color: Colors.white10),
            const SizedBox(height: 40),

            // 3. Copyright and Back to Top
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '© ${DateTime.now().year} Abdullah Mohammed. All rights reserved.',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant.withValues(
                      alpha: 0.6,
                    ),
                  ),
                ),
                _buildBackToTop(theme),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProjectWidget(ThemeData theme, bool isDesktop) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(isDesktop ? 60 : 32),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHigh.withValues(alpha: 0.4),
        borderRadius: BorderRadius.circular(32),
        border: Border.all(
          color: theme.colorScheme.primary.withValues(alpha: 0.2),
        ),
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.primary.withValues(alpha: 0.05),
            blurRadius: 50,
            spreadRadius: 10,
          ),
        ],
      ),
      child: isDesktop
          ? Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'HAVE A PROJECT IN MIND?',
                        style: theme.textTheme.labelLarge?.copyWith(
                          color: theme.colorScheme.primary,
                          letterSpacing: 4,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        "Let's create something\nlegendary together.",
                        style: theme.textTheme.displaySmall?.copyWith(
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ],
                  ),
                ),
                _buildContactCTA(theme),
              ],
            )
          : Column(
              children: [
                Text(
                  'HAVE A PROJECT IN MIND?',
                  style: theme.textTheme.labelLarge?.copyWith(
                    color: theme.colorScheme.primary,
                    letterSpacing: 4,
                    fontWeight: FontWeight.w800,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                Text(
                  "Let's create something\nlegendary together.",
                  style: theme.textTheme.headlineLarge?.copyWith(
                    fontWeight: FontWeight.w900,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 40),
                _buildContactCTA(theme),
              ],
            ),
    );
  }

  Widget _buildContactCTA(ThemeData theme) {
    return _MagneticWrapper(
      onTap: () => launchUrl(Uri.parse('mailto:your.email@example.com')),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
        decoration: BoxDecoration(
          color: theme.colorScheme.primary,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: theme.colorScheme.primary.withValues(alpha: 0.3),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'GET IN TOUCH',
              style: theme.textTheme.labelLarge?.copyWith(
                color: theme.colorScheme.onPrimary,
                fontWeight: FontWeight.w900,
                letterSpacing: 1.2,
              ),
            ),
            const SizedBox(width: 12),
            Icon(
              Icons.send_rounded,
              color: theme.colorScheme.onPrimary,
              size: 18,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBrand(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'AM.',
          style: theme.textTheme.headlineSmall?.copyWith(
            color: theme.colorScheme.primary,
            fontWeight: FontWeight.w900,
            letterSpacing: 2.0,
          ),
        ),
        const SizedBox(height: 16),
        Text(
          'Senior Flutter Developer specialized in\nbuilding premium digital experiences.',
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
            height: 1.6,
          ),
        ),
      ],
    );
  }

  Widget _buildLinks(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'NAVIGATION',
          style: theme.textTheme.labelSmall?.copyWith(
            color: theme.colorScheme.primary,
            letterSpacing: 2,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 24),
        _FooterLink(label: 'About', onTap: () {}),
        _FooterLink(label: 'Skills', onTap: () {}),
        _FooterLink(label: 'Experience', onTap: () {}),
        _FooterLink(label: 'Projects', onTap: () {}),
        _FooterLink(label: 'Contact', onTap: () {}),
      ],
    );
  }

  Widget _buildSocials(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'SOCIALS',
          style: theme.textTheme.labelSmall?.copyWith(
            color: theme.colorScheme.primary,
            letterSpacing: 2,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 24),
        Row(
          children: [
            _SocialIcon(
              icon: Icons.code_rounded,
              url: 'https://github.com/yourusername',
            ),
            const SizedBox(width: 16),
            _SocialIcon(
              icon: Icons.work_rounded,
              url: 'https://linkedin.com/in/yourusername',
            ),
            const SizedBox(width: 16),
            _SocialIcon(
              icon: Icons.alternate_email_rounded,
              url: 'https://twitter.com/yourusername',
            ),
          ],
        ),
      ],
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
  const _FooterLink({required this.label, required this.onTap});
  final String label;
  final VoidCallback onTap;

  @override
  State<_FooterLink> createState() => _FooterLinkState();
}

class _FooterLinkState extends State<_FooterLink> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: MouseRegion(
        onEnter: (_) => setState(() => _isHovered = true),
        onExit: (_) => setState(() => _isHovered = false),
        child: GestureDetector(
          onTap: widget.onTap,
          child: AnimatedDefaultTextStyle(
            duration: const Duration(milliseconds: 200),
            style: theme.textTheme.bodyLarge!.copyWith(
              color: _isHovered
                  ? theme.colorScheme.primary
                  : theme.colorScheme.onSurfaceVariant,
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
            ..translate(_offset.dx, _offset.dy)
            ..scale(_isHovered ? 1.05 : 1.0),
          transformAlignment: Alignment.center,
          child: widget.child,
        ),
      ),
    );
  }
}
