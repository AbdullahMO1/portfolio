import 'dart:ui' as ui;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:portoflio/shared/widgets/custom_cursor.dart';
import 'package:portoflio/shared/widgets/shader_background.dart';

/// Breakpoint below which we show bottom nav instead of top nav links.
const double _kSmallScreenBreakpoint = 800;

/// Breakpoint for custom cursor and hiding default click cursor.
const double _kDesktopBreakpoint = 1024;

/// Adaptive app shell with persistent global header navigation
/// and a shared interactive shader background that renders behind
/// every route without being recreated on navigation.
/// On small screens, top bar shows only logo and a bottom nav bar is used.
class AppShell extends StatefulWidget {
  const AppShell({
    required this.child,
    required this.currentIndex,
    required this.onDestinationSelected,
    super.key,
  });

  final Widget child;
  final int currentIndex;
  final ValueChanged<int> onDestinationSelected;

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  final ValueNotifier<Offset> _mousePosition = ValueNotifier(Offset.zero);

  @override
  void dispose() {
    _mousePosition.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isSmallScreen =
        MediaQuery.sizeOf(context).width <= _kSmallScreenBreakpoint;
    final isDesktop = MediaQuery.sizeOf(context).width >= _kDesktopBreakpoint;
    final bottomNavHeight = isSmallScreen ? 80.0 : 0.0;

    final bodyContent = CustomCursorOverlay(
      child: Listener(
        onPointerMove: (event) {
          _mousePosition.value = event.localPosition;
        },
        child: Padding(
          padding: EdgeInsets.only(bottom: bottomNavHeight),
          child: Stack(
            children: [
              // Persistent interactive shader background (shared across all routes)
              Positioned.fill(
                child: ShaderBackground(mousePosition: _mousePosition),
              ),
              // Main content area
              widget.child,
              // Global Header (Top Navigation) — 3D blur + mouse-driven tilt
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: _AnimatedBlurHeader(
                  mousePosition: _mousePosition,
                  viewportSize: MediaQuery.sizeOf(context),
                  compact: isSmallScreen,
                  hideClickCursor: isDesktop,
                ),
              ),
            ],
          ),
        ),
      ),
    );

    final themeOverrides = Theme.of(context).copyWith(
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          enabledMouseCursor: SystemMouseCursors.none,
          disabledMouseCursor: SystemMouseCursors.none,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          enabledMouseCursor: SystemMouseCursors.none,
          disabledMouseCursor: SystemMouseCursors.none,
        ),
      ),
      iconButtonTheme: IconButtonThemeData(
        style: IconButton.styleFrom(
          enabledMouseCursor: SystemMouseCursors.none,
          disabledMouseCursor: SystemMouseCursors.none,
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          enabledMouseCursor: SystemMouseCursors.none,
          disabledMouseCursor: SystemMouseCursors.none,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          enabledMouseCursor: SystemMouseCursors.none,
          disabledMouseCursor: SystemMouseCursors.none,
        ),
      ),
    );

    return Scaffold(
      body: isDesktop
          ? Theme(data: themeOverrides, child: bodyContent)
          : bodyContent,
      bottomNavigationBar: isSmallScreen
          ? _BottomNavBar(
              currentIndex: widget.currentIndex,
              onDestinationSelected: widget.onDestinationSelected,
            )
          : null,
    );
  }
}

/// Header with 3D blur (glassmorphism) and mouse-driven 3D tilt.
/// When [compact] is true (small screens), only the logo is shown; nav is in bottom bar.
class _AnimatedBlurHeader extends StatelessWidget {
  const _AnimatedBlurHeader({
    required this.mousePosition,
    required this.viewportSize,
    this.compact = false,
    this.hideClickCursor = false,
  });
  final ValueListenable<Offset> mousePosition;
  final Size viewportSize;
  final bool compact;
  final bool hideClickCursor;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ListenableBuilder(
      listenable: mousePosition,
      builder: (context, _) {
        final pos = mousePosition.value;
        final cx = viewportSize.width / 2;
        final cy = viewportSize.height / 2;
        final nx = cx > 0 ? (pos.dx - cx) / cx : 0.0;
        final ny = cy > 0 ? (pos.dy - cy) / cy : 0.0;
        const tiltStrength = 0.03;
        final rotateY = nx.clamp(-1.0, 1.0) * tiltStrength;
        final rotateX = -ny.clamp(-1.0, 1.0) * tiltStrength;

        return Transform(
          alignment: Alignment.topCenter,
          transform: Matrix4.identity()
            ..setEntry(3, 2, 0.001)
            ..rotateX(rotateX)
            ..rotateY(rotateY),
          child: ClipRect(
            child: BackdropFilter(
              filter: ui.ImageFilter.blur(sigmaX: 12, sigmaY: 12),
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surface.withValues(alpha: 0.7),
                  borderRadius: BorderRadius.circular(999),
                  border: Border.all(
                    color: theme.colorScheme.primary.withValues(alpha: 0.15),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: theme.colorScheme.primary.withValues(alpha: 0.1),
                      blurRadius: 30,
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () => _navigateTo(context, '/'),
                      child: hideClickCursor
                          ? MouseRegion(
                              cursor: SystemMouseCursors.none,
                              child: _HeaderLogo(theme: theme),
                            )
                          : _HeaderLogo(theme: theme),
                    ),
                    if (!compact)
                      Row(
                        children: [
                          _HeaderLink(
                            label: 'Expertise',
                            onTap: () => _scrollToSection(context, 'skillset'),
                          ),
                          _HeaderLink(
                            label: 'Masterpieces',
                            onTap: () => _scrollToSection(context, 'portfolio'),
                          ),
                          _HeaderLink(
                            label: 'About',
                            onTap: () => _navigateTo(context, '/about'),
                          ),
                          const SizedBox(width: 16),
                          _HireMeButton(theme: theme),
                        ],
                      ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  void _navigateTo(BuildContext context, String location) {
    final currentPath = GoRouterState.of(context).uri.path;
    if (currentPath != location) context.go(location);
  }

  void _scrollToSection(BuildContext context, String section) {
    final currentPath = GoRouterState.of(context).uri.path;
    if (currentPath != '/') {
      context.go('/?section=$section');
    } else {
      context.go('/?section=$section&t=${DateTime.now().millisecondsSinceEpoch}');
    }
  }
}

class _HeaderLogo extends StatelessWidget {
  const _HeaderLogo({required this.theme});
  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: theme.colorScheme.primary,
            shape: BoxShape.circle,
          ),
          child: Icon(
            Icons.star_rounded,
            size: 18,
            color: theme.colorScheme.onPrimary,
          ),
        ),
        const SizedBox(width: 12),
        ShaderMask(
          shaderCallback: (bounds) => LinearGradient(
            colors: [
              theme.colorScheme.primary,
              theme.colorScheme.tertiary,
            ],
          ).createShader(bounds),
          child: Text(
            'AM',
            style: theme.textTheme.titleLarge?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w900,
              letterSpacing: 1.0,
            ),
          ),
        ),
      ],
    );
  }
}

class _HireMeButton extends StatelessWidget {
  const _HireMeButton({required this.theme});
  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.go('/contact'),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
        decoration: BoxDecoration(
          color: theme.colorScheme.primary,
          borderRadius: BorderRadius.circular(999),
          boxShadow: [
            BoxShadow(
              color: theme.colorScheme.primary.withValues(alpha: 0.3),
              blurRadius: 12,
            ),
          ],
        ),
        child: Text(
          'Hire Me',
          style: theme.textTheme.labelLarge?.copyWith(
            color: theme.colorScheme.onPrimary,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
    );
  }
}

class _HeaderLink extends StatelessWidget {
  const _HeaderLink({required this.label, required this.onTap});
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(left: 30),
      child: TextButton(
        onPressed: onTap,
        child: Text(
          label,
          style: theme.textTheme.labelLarge?.copyWith(
            color: theme.colorScheme.onSurface,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}

/// Bottom navigation bar for small screens (≤800px).
class _BottomNavBar extends StatelessWidget {
  const _BottomNavBar({
    required this.currentIndex,
    required this.onDestinationSelected,
  });
  final int currentIndex;
  final ValueChanged<int> onDestinationSelected;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface.withValues(alpha: 0.9),
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.shadow.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: NavigationBar(
          selectedIndex: currentIndex.clamp(0, 5),
          onDestinationSelected: onDestinationSelected,
          destinations: const [
            NavigationDestination(
              icon: Icon(Icons.home_outlined),
              selectedIcon: Icon(Icons.home),
              label: 'Home',
            ),
            NavigationDestination(
              icon: Icon(Icons.person_outline),
              selectedIcon: Icon(Icons.person),
              label: 'About',
            ),
            NavigationDestination(
              icon: Icon(Icons.code_outlined),
              selectedIcon: Icon(Icons.code),
              label: 'Skills',
            ),
            NavigationDestination(
              icon: Icon(Icons.work_outline),
              selectedIcon: Icon(Icons.work),
              label: 'Experience',
            ),
            NavigationDestination(
              icon: Icon(Icons.folder_outlined),
              selectedIcon: Icon(Icons.folder),
              label: 'Projects',
            ),
            NavigationDestination(
              icon: Icon(Icons.mail_outline),
              selectedIcon: Icon(Icons.mail),
              label: 'Contact',
            ),
          ],
        ),
      ),
    );
  }
}
