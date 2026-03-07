import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:portoflio/core/models/resume_model.dart';
import 'package:portoflio/core/providers/portfolio_provider.dart';
import 'package:portoflio/shared/widgets/arabesque_decoration.dart';
import 'package:portoflio/shared/widgets/nav_link.dart';
import 'package:portoflio/theme/app_theme.dart';
import 'package:url_launcher/url_launcher.dart';

class Footer extends ConsumerWidget {
  const Footer({super.key});

  static List<_LinkItem> _connectLinks(MetaInfo meta) {
    final links = <_LinkItem>[];
    if (meta.linkedin.isNotEmpty) {
      links.add(
        _LinkItem('LinkedIn', () => launchUrl(Uri.parse(meta.linkedin))),
      );
    }
    if (meta.github.isNotEmpty) {
      links.add(_LinkItem('GitHub', () => launchUrl(Uri.parse(meta.github))));
    }
    links.add(
      _LinkItem('Email', () => launchUrl(Uri.parse('mailto:${meta.email}'))),
    );
    return links;
  }

  static List<_LinkItem> _siteLinks(BuildContext context) {
    return [
      _LinkItem('Projects', () => context.go('/projects')),
      _LinkItem('Skills', () => context.go('/skills')),
      _LinkItem('Contact', () => context.go('/contact')),
    ];
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final size = MediaQuery.sizeOf(context);
    final isDesktop = size.width >= 1200;
    final asyncResume = ref.watch(portfolioDataProvider);
    final resume = asyncResume.value;
    final name = resume?.meta.name ?? 'Portfolio';
    final meta = resume?.meta;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: isDesktop ? 100 : 20,
        vertical: 80,
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
          const Center(
            child: ArabesqueDecoration(
              color: AppTheme.saffronLight,
              width: 200,
              height: 12,
              opacity: 0.3,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'From the first fire to the last account.',
            style: GoogleFonts.amiri(
              fontSize: 14,
              fontStyle: FontStyle.italic,
              color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.7),
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          Divider(
            color: theme.colorScheme.primary.withValues(alpha: 0.2),
            thickness: 1.5,
          ),
          const SizedBox(height: 56),
          if (isDesktop) _buildDesktopFooter(context, theme, name, meta),
          if (!isDesktop) _buildMobileFooter(context, theme, name, meta),
        ],
      ),
    );
  }

  Widget _buildDesktopFooter(
    BuildContext context,
    ThemeData theme,
    String name,
    MetaInfo? meta,
  ) {
    final connectLinks = meta != null ? _connectLinks(meta) : <_LinkItem>[];
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          '© ${DateTime.now().year} $name. All rights reserved.',
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.75),
            letterSpacing: 0.3,
          ),
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _FooterColumn(
              title: 'Connect',
              links: connectLinks.isNotEmpty
                  ? connectLinks
                  : [_LinkItem('Email', () {})],
            ),
            const SizedBox(width: 96),
            _FooterColumn(title: 'Site', links: _siteLinks(context)),
          ],
        ),
      ],
    );
  }

  Widget _buildMobileFooter(
    BuildContext context,
    ThemeData theme,
    String name,
    MetaInfo? meta,
  ) {
    final connectLinks = meta != null ? _connectLinks(meta) : <_LinkItem>[];
    return Column(
      children: [
        Text(
          '© ${DateTime.now().year} $name. All rights reserved.',
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.75),
            letterSpacing: 0.3,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 32),
        _FooterColumn(
          title: 'Connect',
          links: connectLinks.isNotEmpty
              ? connectLinks
              : [_LinkItem('Email', () {})],
        ),
        const SizedBox(height: 20),
        _FooterColumn(title: 'Site', links: _siteLinks(context)),
      ],
    );
  }
}

class _LinkItem {
  const _LinkItem(this.label, this.onTap);
  final String label;
  final VoidCallback onTap;
}

class _FooterColumn extends StatelessWidget {
  const _FooterColumn({required this.title, required this.links});
  final String title;
  final List<_LinkItem> links;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          title.toUpperCase(),
          style: theme.textTheme.titleSmall?.copyWith(
            color: theme.colorScheme.primary.withValues(alpha: 0.9),
            fontWeight: FontWeight.w700,
            letterSpacing: 2.5,
          ),
        ),
        const SizedBox(height: 20),
        ...links.map(
          (item) => Padding(
            padding: const EdgeInsets.only(bottom: 14),
            child: NavLink(
              label: item.label,
              onTap: item.onTap,
              padding: const EdgeInsets.all(12),
            ),
          ),
        ),
      ],
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
                : AppTheme.saffronLight.withValues(alpha: 0.1),
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
