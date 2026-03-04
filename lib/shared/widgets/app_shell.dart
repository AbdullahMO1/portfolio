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
              // Global Header (Top Navigation) — compact on small screens
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: _GlobalHeader(
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

/// A floating glassmorphism header for global navigation.
/// When [compact] is true (small screens), only the logo is shown; nav is in bottom bar.
class _GlobalHeader extends StatelessWidget {
  const _GlobalHeader({this.compact = false, this.hideClickCursor = false});
  final bool compact;
  final bool hideClickCursor;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final padding = compact
        ? const EdgeInsets.symmetric(horizontal: 20, vertical: 12)
        : const EdgeInsets.symmetric(horizontal: 40, vertical: 20);
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            theme.colorScheme.surface.withValues(alpha: 0.8),
            theme.colorScheme.surface.withValues(alpha: 0.0),
          ],
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: () => _navigateTo(context, '/'),
            child: hideClickCursor
                ? MouseRegion(
                    cursor: SystemMouseCursors.none,
                    child: Text(
                      'AM.',
                      style: theme.textTheme.titleLarge?.copyWith(
                        color: theme.colorScheme.primary,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 2.0,
                      ),
                    ),
                  )
                : Text(
                    'AM.',
                    style: theme.textTheme.titleLarge?.copyWith(
                      color: theme.colorScheme.primary,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 2.0,
                    ),
                  ),
          ),
          if (!compact)
            Row(
              children: [
                _HeaderLink(
                  label: 'ABOUT',
                  onTap: () => _navigateTo(context, '/about'),
                ),
                _HeaderLink(
                  label: 'SKILLS',
                  onTap: () => _navigateTo(context, '/skills'),
                ),
                _HeaderLink(
                  label: 'EXPERIENCE',
                  onTap: () => _navigateTo(context, '/experience'),
                ),
                _HeaderLink(
                  label: 'PROJECTS',
                  onTap: () => _navigateTo(context, '/projects'),
                ),
                _HeaderLink(
                  label: 'CONTACT',
                  onTap: () => _navigateTo(context, '/contact'),
                ),
              ],
            ),
        ],
      ),
    );
  }

  void _navigateTo(BuildContext context, String location) {
    // Only navigate if we're not already there
    final currentPath = GoRouterState.of(context).uri.path;
    if (currentPath != location) {
      context.go(location);
    }
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
