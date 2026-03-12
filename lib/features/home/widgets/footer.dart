import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:portoflio/core/models/resume_model.dart';
import 'package:portoflio/core/providers/portfolio_provider.dart';
import 'package:portoflio/shared/widgets/magnetic_button.dart';
import 'package:url_launcher/url_launcher.dart';

class Footer extends ConsumerWidget {
  const Footer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final size = MediaQuery.sizeOf(context);
    final isDesktop = size.width >= 900;
    final asyncResume = ref.watch(portfolioDataProvider);
    final resume = asyncResume.value;
    final name = resume?.meta.name ?? 'Abdullah Mohammed';
    final tagline =
        resume?.meta.tagline ?? 'Senior Mobile Engineer & Team Lead';
    final meta = resume?.meta;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(
            color: theme.colorScheme.primary.withValues(alpha: 0.12),
          ),
        ),
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            theme.colorScheme.surface.withValues(alpha: 0.6),
            theme.colorScheme.surface.withValues(alpha: 0.9),
          ],
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Ornamental top accent
          Container(
            width: 60,
            height: 3,
            margin: const EdgeInsets.only(top: 32),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  theme.colorScheme.primary.withValues(alpha: 0),
                  theme.colorScheme.primary,
                  theme.colorScheme.tertiary,
                  theme.colorScheme.primary.withValues(alpha: 0),
                ],
              ),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 40),

          // Main content
          Padding(
            padding: EdgeInsets.symmetric(horizontal: isDesktop ? 80 : 24),
            child: isDesktop
                ? _buildDesktopLayout(context, theme, name, tagline, meta)
                : _buildMobileLayout(context, theme, name, tagline, meta),
          ),

          const SizedBox(height: 40),

          // Bottom bar
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(
              horizontal: isDesktop ? 80 : 24,
              vertical: 20,
            ),
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(
                  color: theme.colorScheme.primary.withValues(alpha: 0.08),
                ),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '\u00a9 ${DateTime.now().year} $name. All rights reserved.',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant.withValues(
                      alpha: 0.7,
                    ),
                    fontSize: 12,
                  ),
                ),
                Text(
                  'Built with Flutter',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant.withValues(
                      alpha: 0.6,
                    ),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDesktopLayout(
    BuildContext context,
    ThemeData theme,
    String name,
    String tagline,
    MetaInfo? meta,
  ) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Left column — brand + description + CTA
        Expanded(
          flex: 5,
          child: _buildBrandColumn(context, theme, name, tagline, meta),
        ),
        const SizedBox(width: 64),
        // Right column — two link groups side by side
        Expanded(
          flex: 5,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: _buildLinkGroup(context, theme, 'Explore', [
                  const _NavItem('Skills', '/skills'),
                  const _NavItem('Masterpieces', '/projects'),
                  const _NavItem('Experience', '/experience'),
                  const _NavItem('About', '/about'),
                ]),
              ),
              const SizedBox(width: 40),
              Expanded(child: _buildConnectGroup(context, theme, meta)),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMobileLayout(
    BuildContext context,
    ThemeData theme,
    String name,
    String tagline,
    MetaInfo? meta,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildBrandColumn(context, theme, name, tagline, meta),
        const SizedBox(height: 36),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: _buildLinkGroup(context, theme, 'Explore', [
                const _NavItem('Skills', '/skills'),
                const _NavItem('Masterpieces', '/projects'),
                const _NavItem('Experience', '/experience'),
                const _NavItem('About', '/about'),
              ]),
            ),
            const SizedBox(width: 24),
            Expanded(child: _buildConnectGroup(context, theme, meta)),
          ],
        ),
      ],
    );
  }

  Widget _buildBrandColumn(
    BuildContext context,
    ThemeData theme,
    String name,
    String tagline,
    MetaInfo? meta,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Logo
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: theme.colorScheme.primary,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.star_rounded,
                size: 20,
                color: theme.colorScheme.onPrimary,
              ),
            ),
            const SizedBox(width: 12),
            ShaderMask(
              shaderCallback: (bounds) => LinearGradient(
                colors: [theme.colorScheme.primary, theme.colorScheme.tertiary],
              ).createShader(bounds),
              child: Text(
                'AM',
                style: GoogleFonts.amiri(
                  fontSize: 26,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                  letterSpacing: 1.0,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Text(
          name,
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w700,
            fontSize: 20,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          tagline,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.85),
            fontSize: 14,
            height: 1.5,
          ),
        ),
        const SizedBox(height: 24),
        // CTA button
        MagneticButton(
          onTap: () => context.go('/contact'),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 36, vertical: 16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [theme.colorScheme.primary, theme.colorScheme.tertiary],
              ),
              borderRadius: BorderRadius.circular(999),
              boxShadow: [
                BoxShadow(
                  color: theme.colorScheme.primary.withValues(alpha: 0.3),
                  blurRadius: 24,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "Let's Work Together",
                  style: theme.textTheme.labelLarge?.copyWith(
                    color: theme.colorScheme.onPrimary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(width: 10),
                Icon(
                  Icons.arrow_forward_rounded,
                  color: theme.colorScheme.onPrimary,
                  size: 18,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLinkGroup(
    BuildContext context,
    ThemeData theme,
    String title,
    List<_NavItem> items,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title.toUpperCase(),
          style: theme.textTheme.labelSmall?.copyWith(
            color: theme.colorScheme.primary,
            fontWeight: FontWeight.w800,
            letterSpacing: 2,
            fontSize: 11,
          ),
        ),
        const SizedBox(height: 20),
        ...items.map(
          (item) => Padding(
            padding: const EdgeInsets.only(bottom: 14),
            child: _FooterLink(
              label: item.label,
              onTap: () {
                final currentPath = GoRouterState.of(context).uri.path;
                if (currentPath != item.route) context.go(item.route);
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildConnectGroup(
    BuildContext context,
    ThemeData theme,
    MetaInfo? meta,
  ) {
    final items = <_ExternalLink>[];
    if (meta != null) {
      if (meta.linkedin.isNotEmpty) {
        items.add(_ExternalLink('LinkedIn', meta.linkedin));
      }
      if (meta.github.isNotEmpty) {
        items.add(_ExternalLink('GitHub', meta.github));
      }
      items.add(_ExternalLink('Email', 'mailto:${meta.email}'));
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'CONNECT',
          style: theme.textTheme.labelSmall?.copyWith(
            color: theme.colorScheme.primary,
            fontWeight: FontWeight.w800,
            letterSpacing: 2,
            fontSize: 11,
          ),
        ),
        const SizedBox(height: 20),
        ...items.map(
          (item) => Padding(
            padding: const EdgeInsets.only(bottom: 14),
            child: _FooterLink(
              label: item.label,
              onTap: () => launchUrl(Uri.parse(item.url)),
              external: true,
            ),
          ),
        ),
      ],
    );
  }
}

class _FooterLink extends StatefulWidget {
  const _FooterLink({
    required this.label,
    required this.onTap,
    this.external = false,
  });
  final String label;
  final VoidCallback onTap;
  final bool external;

  @override
  State<_FooterLink> createState() => _FooterLinkState();
}

class _FooterLinkState extends State<_FooterLink> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: _hovered ? 16 : 0,
                child: AnimatedOpacity(
                  duration: const Duration(milliseconds: 200),
                  opacity: _hovered ? 1.0 : 0.0,
                  child: Padding(
                    padding: const EdgeInsets.only(right: 6),
                    child: Icon(
                      Icons.arrow_forward_rounded,
                      size: 12,
                      color: theme.colorScheme.primary,
                    ),
                  ),
                ),
              ),
              Text(
                widget.label,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: _hovered
                      ? theme.colorScheme.primary
                      : theme.colorScheme.onSurfaceVariant,
                  fontWeight: _hovered ? FontWeight.w600 : FontWeight.w400,
                  fontSize: 14,
                ),
              ),
              if (widget.external) ...[
                const SizedBox(width: 4),
                Icon(
                  Icons.north_east_rounded,
                  size: 11,
                  color: _hovered
                      ? theme.colorScheme.primary
                      : theme.colorScheme.onSurfaceVariant.withValues(
                          alpha: 0.7,
                        ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _NavItem {
  const _NavItem(this.label, this.route);
  final String label;
  final String route;
}

class _ExternalLink {
  const _ExternalLink(this.label, this.url);
  final String label;
  final String url;
}
