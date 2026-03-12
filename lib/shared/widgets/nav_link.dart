import 'package:flutter/material.dart';

/// Navigation link widget with hover effects
class NavLink extends StatelessWidget {
  const NavLink({
    super.key,
    required this.label,
    required this.onTap,
    this.padding,
    this.style,
  });

  final String label;
  final VoidCallback onTap;
  final EdgeInsetsGeometry? padding;
  final TextStyle? style;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isHovered = ValueNotifier<bool>(false);

    return ValueListenableBuilder<bool>(
      valueListenable: isHovered,
      builder: (context, hovered, child) {
        return MouseRegion(
          onEnter: (_) => isHovered.value = true,
          onExit: (_) => isHovered.value = false,
          child: GestureDetector(
            onTap: onTap,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeOutCubic,
              padding:
                  padding ??
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              decoration: BoxDecoration(
                color: hovered
                    ? theme.colorScheme.primary.withValues(alpha: 0.1)
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: hovered
                      ? theme.colorScheme.primary.withValues(alpha: 0.3)
                      : Colors.transparent,
                  width: 1,
                ),
              ),
              child: Text(
                label,
                style:
                    style ??
                    theme.textTheme.labelLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                      color: hovered
                          ? theme.colorScheme.primary
                          : theme.colorScheme.onSurfaceVariant,
                    ),
              ),
            ),
          ),
        );
      },
    );
  }
}
