import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:portoflio/shared/widgets/scroll_reveal.dart';
import 'package:portoflio/shared/widgets/tilt_hover_card.dart';

/// Projects grid with:
/// - 3D perspective tilt cards tracking cursor
/// - Glassmorphism with gold border glow on hover
/// - ScrollReveal staggered entrance (scale pop)
/// - Deep link navigation to /projects/:id
class ProjectsScreen extends StatelessWidget {
  const ProjectsScreen({super.key});

  static const List<Map<String, dynamic>> _projects = [
    {
      'id': 'fintech-app',
      'title': 'FinTech Super App',
      'description':
          'Comprehensive financial services with real-time trading, bill payments, and smart budgeting.',
      'tech': ['Flutter', 'BLoC', 'WebSocket', 'Firebase'],
      'icon': Icons.account_balance_rounded,
    },
    {
      'id': 'delivery-platform',
      'title': 'Delivery Platform',
      'description':
          'End-to-end delivery with real-time tracking, route optimization, and fleet management.',
      'tech': ['Flutter', 'Google Maps', 'Riverpod', 'REST'],
      'icon': Icons.local_shipping_rounded,
    },
    {
      'id': 'health-tracker',
      'title': 'Health & Fitness',
      'description':
          'Personal health tracker with workout plans, nutrition logging, and wearable sync.',
      'tech': ['Flutter', 'Health Kit', 'Charts', 'SQLite'],
      'icon': Icons.favorite_rounded,
    },
    {
      'id': 'ecommerce-app',
      'title': 'E-Commerce App',
      'description':
          'Feature-rich shopping with AR product preview, wishlist, and payment gateway.',
      'tech': ['Flutter', 'Stripe', 'ARCore', 'GetX'],
      'icon': Icons.shopping_bag_rounded,
    },
    {
      'id': 'social-platform',
      'title': 'Social Platform',
      'description':
          'Community-driven social platform with real-time chat, stories, and moderation.',
      'tech': ['Flutter', 'Firebase', 'Agora', 'BLoC'],
      'icon': Icons.people_rounded,
    },
    {
      'id': 'smart-home',
      'title': 'Smart Home',
      'description':
          'IoT dashboard for controlling smart devices with voice commands and automation.',
      'tech': ['Flutter', 'MQTT', 'Riverpod', 'BLE'],
      'icon': Icons.home_rounded,
    },
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final screenWidth = MediaQuery.sizeOf(context).width;
    final isDesktop = screenWidth >= 1200;
    final crossAxisCount = isDesktop ? 3 : (screenWidth >= 600 ? 2 : 1);

    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(
        horizontal: isDesktop ? 100 : 24,
        vertical: 80,
      ),
      child: Column(
        children: [
          ScrollReveal(
            child: Center(
              child: Column(
                children: [
                  Text('Projects', style: theme.textTheme.headlineLarge),
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
                ],
              ),
            ),
          ),
          const SizedBox(height: 50),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: crossAxisCount,
              mainAxisSpacing: 24,
              crossAxisSpacing: 24,
              childAspectRatio: isDesktop ? 0.95 : 1.1,
            ),
            itemCount: _projects.length,
            itemBuilder: (context, index) {
              final project = _projects[index];
              return ScrollReveal(
                delay: Duration(milliseconds: index * 100),
                direction: RevealDirection.scale,
                child: _Glass3DProjectCard(
                  id: project['id'] as String,
                  title: project['title'] as String,
                  description: project['description'] as String,
                  tech: project['tech'] as List<String>,
                  icon: project['icon'] as IconData,
                  theme: theme,
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _Glass3DProjectCard extends StatelessWidget {
  const _Glass3DProjectCard({
    required this.id,
    required this.title,
    required this.description,
    required this.tech,
    required this.icon,
    required this.theme,
  });

  final String id;
  final String title;
  final String description;
  final List<String> tech;
  final IconData icon;
  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.go('/projects/$id'),
      child: TiltHoverCard(
        invertTilt: true,
        tiltStrength: 0.08,
        followSpeed: 14,
        hoverLift: 4,
        builder: (context, isHovered) {
          return AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            curve: Curves.easeOutSine,
            padding: const EdgeInsets.all(28),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24),
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
                  color:
                      Colors.black.withValues(alpha: isHovered ? 0.3 : 0.15),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: theme.colorScheme.primary.withValues(alpha: 0.2),
                    ),
                  ),
                  child: Icon(
                    icon,
                    color: theme.colorScheme.primary,
                    size: 26,
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  title,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: theme.colorScheme.onSurface,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 10),
                Expanded(
                  child: Text(
                    description,
                    style: theme.textTheme.bodySmall?.copyWith(height: 1.6),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(height: 14),
                Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children: tech
                      .map(
                        (t) => Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 5,
                          ),
                          decoration: BoxDecoration(
                            color:
                                theme.colorScheme.primary.withValues(alpha: 0.08),
                            borderRadius: BorderRadius.circular(6),
                            border: Border.all(
                              color: theme.colorScheme.primary.withValues(
                                alpha: 0.15,
                              ),
                            ),
                          ),
                          child: Text(
                            t,
                            style: theme.textTheme.labelSmall?.copyWith(
                              color: theme.colorScheme.primary.withValues(
                                alpha: 0.8,
                              ),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      )
                      .toList(),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
