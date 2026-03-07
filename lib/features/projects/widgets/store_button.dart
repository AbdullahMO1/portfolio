import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

/// Store button for app store links (Google Play, App Store)
class StoreButton extends StatelessWidget {
  const StoreButton({super.key, required this.store, required this.url, this.size = StoreButtonSize.medium});

  final StoreType store;
  final String url;
  final StoreButtonSize size;

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
            onTap: () => _launchStore(url),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeOutCubic,
              padding: _getPadding(),
              decoration: BoxDecoration(
                color: _getBackgroundColor(hovered, theme),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: _getBorderColor(hovered, theme), width: 1.5),
                boxShadow: hovered ? _getBoxShadow(theme) : null,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _getStoreIcon(theme),
                  const SizedBox(width: 8),
                  Text(_getStoreText(), style: _getTextStyle(theme, size)),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  EdgeInsets _getPadding() {
    switch (size) {
      case StoreButtonSize.small:
        return const EdgeInsets.symmetric(horizontal: 12, vertical: 8);
      case StoreButtonSize.medium:
        return const EdgeInsets.symmetric(horizontal: 16, vertical: 12);
      case StoreButtonSize.large:
        return const EdgeInsets.symmetric(horizontal: 20, vertical: 16);
    }
  }

  Color _getBackgroundColor(bool hovered, ThemeData theme) {
    if (hovered) {
      switch (store) {
        case StoreType.googlePlay:
          return theme.colorScheme.primary;
        case StoreType.appStore:
          return theme.colorScheme.primary;
      }
    }
    return theme.colorScheme.surface.withValues(alpha: 0.9);
  }

  Color _getBorderColor(bool hovered, ThemeData theme) {
    if (hovered) {
      return theme.colorScheme.primary;
    }
    return theme.colorScheme.outline.withValues(alpha: 0.3);
  }

  List<BoxShadow> _getBoxShadow(ThemeData theme) {
    return [
      BoxShadow(color: theme.colorScheme.primary.withValues(alpha: 0.2), blurRadius: 12, offset: const Offset(0, 4)),
    ];
  }

  Widget _getStoreIcon(ThemeData theme) {
    IconData icon;
    Color iconColor;

    switch (store) {
      case StoreType.googlePlay:
        icon = Icons.play_arrow_rounded;
        iconColor = Colors.green;
        break;
      case StoreType.appStore:
        icon = Icons.apple;
        iconColor = theme.colorScheme.onSurface;
        break;
    }

    return Icon(icon, size: _getIconSize(), color: iconColor);
  }

  double _getIconSize() {
    switch (size) {
      case StoreButtonSize.small:
        return 16;
      case StoreButtonSize.medium:
        return 20;
      case StoreButtonSize.large:
        return 24;
    }
  }

  String _getStoreText() {
    switch (store) {
      case StoreType.googlePlay:
        return 'Google Play';
      case StoreType.appStore:
        return 'App Store';
    }
  }

  TextStyle _getTextStyle(ThemeData theme, StoreButtonSize size) {
    final fontSize = switch (size) {
      StoreButtonSize.small => 12.0,
      StoreButtonSize.medium => 14.0,
      StoreButtonSize.large => 16.0,
    };

    return theme.textTheme.labelMedium?.copyWith(
          fontSize: fontSize,
          fontWeight: FontWeight.w600,
          color: theme.colorScheme.onSurface,
        ) ??
        TextStyle(fontSize: fontSize, fontWeight: FontWeight.w600, color: theme.colorScheme.onSurface);
  }

  Future<void> _launchStore(String url) async {
    try {
      final uri = Uri.parse(url);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri);
      }
    } catch (e) {
      // Handle error silently or show a snackbar
    }
  }
}

enum StoreType { googlePlay, appStore }

enum StoreButtonSize { small, medium, large }
