import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:portoflio/shared/widgets/scroll_reveal.dart';
import 'package:portoflio/shared/widgets/tilt_hover_card.dart';

/// Home-only "Currated Portfolio" section with 2–3 featured projects.
/// Matches Stitch wireframe: Selected Masterpieces with Case Study links.
class CuratedPortfolioSection extends StatelessWidget {
  const CuratedPortfolioSection({super.key});

  static const List<Map<String, dynamic>> _featuredProjects = [
    {
      'id': 'fintech-app',
      'number': '01',
      'category': 'Fintech Solution',
      'title': 'Royal Bank App',
      'description':
          'A high-security banking application featuring real-time transaction tracking, biometric authentication, and custom data visualization charts.',
      'tech': ['FLUTTER', 'DART', 'FIREBASE'],
      'imageUrl':
          'https://lh3.googleusercontent.com/aida-public/AB6AXuAlLHXt9xsALzag-xEyUt0bFlM12SvqTplVZhu0MQnuKg0bQCh3RU38_uyL7w-L4ZKf740_5e0b2zbUeod8ARM7n-7Zrk-aGpOgrogNyzJBi7KOKcekmdLCel5vKNLy2qLbdIPHmO650MPqLCkByQkpAhUWoHUJs5H2CXAvEW1twetgDeXUVFjnw10t1Fukif7c6W0pFSXREp3QOmdtPUOvyAdQmjI4CU8OCLlZOFpM7kS0VbR5lmi17JuJxpQZqjERsjsnt4lsbtUH',
    },
    {
      'id': 'ecommerce-app',
      'number': '02',
      'category': 'E-Commerce',
      'title': 'LuxeMarket',
      'description':
          'Redefining luxury shopping with immersive 3D product previews, AR try-ons, and seamless checkout experiences.',
      'tech': ['RIVE', 'FLUTTER', 'STRIPE'],
      'imageUrl':
          'https://lh3.googleusercontent.com/aida-public/AB6AXuC9eUXI1hk7X1NtXE9tCgsEYTxnxWYzkJ-smiLNYMCJTgeDOVlHwfG4xu2zCmhhi3tfjykUeOGVG8WTlbDBxGcLF8UJEf5qVcX0ewTEX6er6e5EPu1ULj1pBkt9ik8OziZxGpwGoJWBxWE593K5HvwN8dNtWushbfFohna1bnuI6XvU11GhixlUsqGId7xjLYeTnCR1WRB-3a7CHs5OJO_RpQddBuaQtvvt5OOTSXJW2r8wRSh-Rz8DeFtqGZ5BPenwFvSgOVxrnj5l',
    },
  ];

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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ScrollReveal(
            child: Center(
              child: Column(
                children: [
                  Text(
                    'CURATED PORTFOLIO',
                    style: theme.textTheme.labelMedium?.copyWith(
                      color: theme.colorScheme.primary,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 3,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Selected Masterpieces',
                    style: theme.textTheme.headlineLarge?.copyWith(
                      fontSize: isDesktop ? 64 : 40,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 60),
          ...List.generate(_featuredProjects.length, (index) {
            final project = _featuredProjects[index];
            final imageFirst = index == 1;
            return Padding(
              padding: EdgeInsets.only(
                bottom: index < _featuredProjects.length - 1 ? 80 : 0,
              ),
              child: ScrollReveal(
                delay: Duration(milliseconds: index * 120),
                direction: RevealDirection.fromBottom,
                child: _FeaturedProjectCard(
                  id: project['id'] as String,
                  number: project['number'] as String,
                  category: project['category'] as String,
                  title: project['title'] as String,
                  description: project['description'] as String,
                  tech: project['tech'] as List<String>,
                  imageUrl: project['imageUrl'] as String,
                  theme: theme,
                  isDesktop: isDesktop,
                  imageFirst: imageFirst,
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}

class _FeaturedProjectCard extends StatelessWidget {
  const _FeaturedProjectCard({
    required this.id,
    required this.number,
    required this.category,
    required this.title,
    required this.description,
    required this.tech,
    required this.imageUrl,
    required this.theme,
    required this.isDesktop,
    required this.imageFirst,
  });

  final String id;
  final String number;
  final String category;
  final String title;
  final String description;
  final List<String> tech;
  final String imageUrl;
  final ThemeData theme;
  final bool isDesktop;
  final bool imageFirst;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.go('/projects/$id'),
      child: TiltHoverCard(
        invertTilt: true,
        tiltStrength: 0.06,
        followSpeed: 14,
        hoverLift: 4,
        builder: (context, isHovered) {
          return AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            curve: Curves.easeOutSine,
            padding: EdgeInsets.all(isDesktop ? 40 : 28),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(28),
              color: theme.colorScheme.surfaceContainerHigh.withValues(
                alpha: isHovered ? 0.4 : 0.2,
              ),
              border: Border.all(
                color: isHovered
                    ? theme.colorScheme.primary.withValues(alpha: 0.4)
                    : theme.colorScheme.outline.withValues(alpha: 0.08),
                width: 1.5,
              ),
              boxShadow: [
                if (isHovered)
                  BoxShadow(
                    color: theme.colorScheme.primary.withValues(alpha: 0.12),
                    blurRadius: 40,
                    spreadRadius: 2,
                  ),
                BoxShadow(
                  color: Colors.black.withValues(alpha: isHovered ? 0.3 : 0.15),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: isDesktop
                ? Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      if (imageFirst) _buildProjectImage(),
                      if (imageFirst) const SizedBox(width: 64),
                      Expanded(
                        flex: 2,
                        child: _buildProjectContent(),
                      ),
                      if (!imageFirst) const SizedBox(width: 64),
                      if (!imageFirst) _buildProjectImage(),
                    ],
                  )
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildProjectImage(isCompact: true),
                      const SizedBox(height: 24),
                      _buildProjectContent(),
                    ],
                  ),
          );
        },
      ),
    );
  }

  Widget _buildProjectImage({bool isCompact = false}) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: Container(
        width: isCompact ? double.infinity : 400,
        height: isCompact ? 220 : 280,
        decoration: BoxDecoration(
          color: theme.colorScheme.surfaceContainerHigh.withValues(alpha: 0.4),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: theme.colorScheme.primary.withValues(alpha: 0.2),
          ),
          boxShadow: [
            BoxShadow(
              color: theme.colorScheme.primary.withValues(alpha: 0.1),
              blurRadius: 40,
              spreadRadius: 2,
            ),
          ],
        ),
        child: Image.network(
          imageUrl,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) => Container(
            color: theme.colorScheme.surfaceContainerHighest,
            child: Icon(
              Icons.image_not_supported_rounded,
              size: 48,
              color: theme.colorScheme.primary,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProjectContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '$number / $category',
          style: theme.textTheme.labelMedium?.copyWith(
            color: theme.colorScheme.primary,
            fontWeight: FontWeight.w800,
            letterSpacing: 1.5,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          title,
          style: theme.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.w700,
            color: theme.colorScheme.onSurface,
            fontSize: isDesktop ? 40 : 28,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 16),
        Text(
          description,
          style: theme.textTheme.bodyLarge?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
            height: 1.6,
          ),
          maxLines: 3,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 20),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: tech
              .map(
                (t) => Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primary.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(999),
                    border: Border.all(
                      color: theme.colorScheme.primary.withValues(alpha: 0.2),
                    ),
                  ),
                  child: Text(
                    t,
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: theme.colorScheme.primary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              )
              .toList(),
        ),
        const SizedBox(height: 24),
        Row(
          children: [
            Text(
              'Case Study',
              style: theme.textTheme.labelLarge?.copyWith(
                color: theme.colorScheme.primary,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(width: 6),
            Icon(
              Icons.north_east_rounded,
              size: 18,
              color: theme.colorScheme.primary,
            ),
          ],
        ),
      ],
    );
  }
}
