import 'package:flutter/material.dart';

import 'package:portoflio/shared/widgets/tilt_hover_card.dart';

/// Glassmorphism 3D tilt profile card; name, tagline, and avatar from resume.
class ProfileCard extends StatelessWidget {
  const ProfileCard({
    super.key,
    required this.name,
    required this.tagline,
    this.avatarUrl,
  });

  final String name;
  final String tagline;
  final String? avatarUrl;

  static const String _assetAvatarPath = 'assets/images/avatar.jpeg';

  Widget _buildAvatar(ThemeData theme) {
    if (avatarUrl != null && avatarUrl!.isNotEmpty) {
      if (avatarUrl!.startsWith('assets/')) {
        return ClipOval(
          child: Image.asset(
            avatarUrl!,
            width: 100,
            height: 100,
            fit: BoxFit.cover,
            alignment: const Alignment(0, -0.2),
            errorBuilder: (_, _, _) => _placeholderAvatar(theme),
          ),
        );
      }
      final url = avatarUrl!.startsWith(RegExp(r'https?://'))
          ? avatarUrl!
          : Uri.base.resolve(avatarUrl!).toString();
      return ClipOval(
        child: Image.network(
          url,
          width: 100,
          height: 100,
          fit: BoxFit.cover,
          alignment: const Alignment(0, -0.2),
          errorBuilder: (_, _, _) => _placeholderAvatar(theme),
        ),
      );
    }
    return ClipOval(
      child: Image.asset(
        _assetAvatarPath,
        width: 100,
        height: 100,
        fit: BoxFit.cover,
        alignment: const Alignment(0, -0.2),
        errorBuilder: (_, _, _) => _placeholderAvatar(theme),
      ),
    );
  }

  Widget _placeholderAvatar(ThemeData theme) {
    return Container(
      width: 100,
      height: 100,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [theme.colorScheme.primary, theme.colorScheme.tertiary],
        ),
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.primary.withValues(alpha: 0.4),
            blurRadius: 25,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Icon(
        Icons.person_rounded,
        size: 48,
        color: theme.colorScheme.onPrimary,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return TiltHoverCard(
      invertTilt: true,
      builder: (context, isHovered) {
        return ClipRRect(
          borderRadius: BorderRadius.circular(28),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            curve: Curves.easeOut,
            constraints: const BoxConstraints(maxWidth: 380),
            padding: const EdgeInsets.all(36),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(28),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  theme.colorScheme.surfaceContainerHigh.withValues(alpha: 0.4),
                  theme.colorScheme.surfaceContainerLow.withValues(alpha: 0.2),
                ],
              ),
              border: Border.all(
                color: isHovered
                    ? theme.colorScheme.primary.withValues(alpha: 0.4)
                    : theme.colorScheme.outline.withValues(alpha: 0.15),
                width: 1.5,
              ),
              boxShadow: [
                BoxShadow(
                  color: theme.colorScheme.primary.withValues(
                    alpha: isHovered ? 0.15 : 0.0,
                  ),
                  blurRadius: 40,
                  spreadRadius: isHovered ? 2 : 0,
                ),
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.3),
                  blurRadius: 30,
                  offset: const Offset(0, 15),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildAvatar(theme),
                const SizedBox(height: 28),
                Text(
                  name,
                  style: theme.textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  tagline,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.primary,
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFF10B981).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: const Color(0xFF10B981).withValues(alpha: 0.3),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 8,
                        height: 8,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Color(0xFF10B981),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Available for hire',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: const Color(0xFF10B981),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
