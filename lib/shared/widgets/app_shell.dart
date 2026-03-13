import 'dart:ui' as ui;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:portoflio/core/services/audio_service.dart';
import 'package:portoflio/shared/widgets/arabesque_decoration.dart';
import 'package:portoflio/shared/widgets/custom_cursor.dart';
import 'package:portoflio/shared/widgets/magnetic_button.dart';
import 'package:portoflio/shared/widgets/nav_link.dart';
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
    this.placeProgress,
    this.scrollProgress,
    super.key,
  });

  final Widget child;
  final int currentIndex;
  final ValueChanged<int> onDestinationSelected;
  final ValueNotifier<double>? placeProgress;
  final ValueNotifier<double>? scrollProgress;

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  final ValueNotifier<Offset> _mousePosition = ValueNotifier(Offset.zero);
  final ValueNotifier<double> _ownPlaceProgress = ValueNotifier(0.0);

  /// Maps route index to place progress (0=camp, 1=oasis, 2=war, 3=mansion).
  /// Router indices: 0=home, 1=about, 2=skills, 3=experience, 4=projects, 5=contact.
  double _placeForIndex(int index) {
    switch (index) {
      case 0:
        return 0.0; // home (dynamic when placeProgress provided)
      case 1:
        return 3.0; // about
      case 2:
        return 0.0; // skills
      case 3:
        return 2.0; // experience
      case 4:
        return 1.0; // projects
      case 5:
        return 0.0; // contact
      default:
        return 0.0;
    }
  }

  @override
  void initState() {
    super.initState();
    _ownPlaceProgress.value = _placeForIndex(widget.currentIndex);
  }

  @override
  void didUpdateWidget(AppShell oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.placeProgress == null &&
        widget.currentIndex != oldWidget.currentIndex) {
      _ownPlaceProgress.value = _placeForIndex(widget.currentIndex);
    }
  }

  @override
  void dispose() {
    _mousePosition.dispose();
    _ownPlaceProgress.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isSmallScreen =
        MediaQuery.sizeOf(context).width <= _kSmallScreenBreakpoint;
    final isDesktop = MediaQuery.sizeOf(context).width >= _kDesktopBreakpoint;

    final bodyContent = CustomCursorOverlay(
      child: Listener(
        onPointerDown: (_) {
          // Attempt to unlock audio on interaction only if explicitly unmuted
          final audio = AudioService.instance;
          if (!audio.isMuted) {
            audio.tryUnlock();
          }
        },
        onPointerMove: (event) {
          _mousePosition.value = event.localPosition;
        },
        child: Stack(
          children: [
            // Persistent interactive shader background (shared across all routes)
            Positioned.fill(
              child: ShaderBackground(
                mousePosition: _mousePosition,
                placeProgress: widget.placeProgress ?? _ownPlaceProgress,
                scrollProgress: widget.scrollProgress,
              ),
            ),
            // Main content area
            Padding(
              padding: const EdgeInsets.only(top: 32),
              child: widget.child,
            ),
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

        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Transform(
              alignment: Alignment.topCenter,
              transform: Matrix4.identity()
                ..setEntry(3, 2, 0.001)
                ..rotateX(rotateX)
                ..rotateY(rotateY),
              child: Container(
                margin: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(999),
                  child: BackdropFilter(
                    filter: ui.ImageFilter.blur(sigmaX: 12, sigmaY: 12),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 32,
                        vertical: 12,
                      ),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.surface.withValues(alpha: 0.5),
                        borderRadius: BorderRadius.circular(999),
                        border: Border.all(
                          color: theme.colorScheme.primary.withValues(
                            alpha: 0.15,
                          ),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: theme.colorScheme.primary.withValues(
                              alpha: 0.1,
                            ),
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
                                NavLink(
                                  label: 'Skills',
                                  onTap: () => _navigateTo(context, '/skills'),
                                ),
                                NavLink(
                                  label: 'Masterpieces',
                                  onTap: () =>
                                      _navigateTo(context, '/projects'),
                                ),
                                NavLink(
                                  label: 'Experience',
                                  onTap: () =>
                                      _navigateTo(context, '/experience'),
                                ),
                                NavLink(
                                  label: 'About',
                                  onTap: () => _navigateTo(context, '/about'),
                                ),
                                const SizedBox(width: 12),
                                const _AudioToggleButton(),
                                const SizedBox(width: 12),
                                _HireMeButton(theme: theme),
                              ],
                            )
                          else
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const _AudioToggleButton(),
                                const SizedBox(width: 4),
                                PopupMenuButton<String>(
                                  icon: Icon(
                                    Icons.menu,
                                    color: theme.colorScheme.primary,
                                  ),
                                  padding: EdgeInsets.zero,
                                  offset: const Offset(0, 48),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  onSelected: (value) {
                                    switch (value) {
                                      case 'skills':
                                        _navigateTo(context, '/skills');
                                        break;
                                      case 'masterpieces':
                                        _navigateTo(context, '/projects');
                                        break;
                                      case 'experience':
                                        _navigateTo(context, '/experience');
                                        break;
                                      case 'about':
                                        _navigateTo(context, '/about');
                                        break;
                                      case 'hire':
                                        _navigateTo(context, '/contact');
                                        break;
                                    }
                                  },
                                  itemBuilder: (context) => [
                                    PopupMenuItem(
                                      value: 'skills',
                                      child: Text(
                                        'Skills',
                                        style: theme.textTheme.labelLarge
                                            ?.copyWith(
                                              fontWeight: FontWeight.w700,
                                            ),
                                      ),
                                    ),
                                    PopupMenuItem(
                                      value: 'masterpieces',
                                      child: Text(
                                        'Masterpieces',
                                        style: theme.textTheme.labelLarge
                                            ?.copyWith(
                                              fontWeight: FontWeight.w700,
                                            ),
                                      ),
                                    ),
                                    PopupMenuItem(
                                      value: 'experience',
                                      child: Text(
                                        'Experience',
                                        style: theme.textTheme.labelLarge
                                            ?.copyWith(
                                              fontWeight: FontWeight.w700,
                                            ),
                                      ),
                                    ),
                                    PopupMenuItem(
                                      value: 'about',
                                      child: Text(
                                        'About',
                                        style: theme.textTheme.labelLarge
                                            ?.copyWith(
                                              fontWeight: FontWeight.w700,
                                            ),
                                      ),
                                    ),
                                    PopupMenuItem(
                                      value: 'hire',
                                      child: Text(
                                        'Hire Me',
                                        style: theme.textTheme.labelLarge
                                            ?.copyWith(
                                              fontWeight: FontWeight.w700,
                                              color: theme.colorScheme.primary,
                                            ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 2),
              child: ArabesqueDecoration(
                color: theme.colorScheme.primary,
                width: 120,
                height: 8,
                opacity: 0.25,
              ),
            ),
          ],
        );
      },
    );
  }

  void _navigateTo(BuildContext context, String location) {
    final currentPath = GoRouterState.of(context).uri.path;
    if (currentPath != location) context.go(location);
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
            colors: [theme.colorScheme.primary, theme.colorScheme.tertiary],
          ).createShader(bounds),
          child: Text(
            'AM',
            style: GoogleFonts.amiri(
              fontSize: 22,
              fontWeight: FontWeight.w700,
              color: Colors.white,
              letterSpacing: 1.0,
            ),
          ),
        ),
      ],
    );
  }
}

class _AudioToggleButton extends StatefulWidget {
  const _AudioToggleButton();

  @override
  State<_AudioToggleButton> createState() => _AudioToggleButtonState();
}

class _AudioToggleButtonState extends State<_AudioToggleButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulse;

  @override
  void initState() {
    super.initState();
    _pulse = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );
    // Initial state
    if (!AudioService.instance.isMuted) _pulse.repeat(reverse: true);

    // Add listener to react to global audio state changes
    AudioService.instance.addListener(_onAudioStateChanged);
  }

  void _onAudioStateChanged() {
    if (!mounted) return;
    final muted = AudioService.instance.isMuted;
    if (!muted && !_pulse.isAnimating) {
      _pulse.repeat(reverse: true);
    } else if (muted && _pulse.isAnimating) {
      _pulse.stop();
      _pulse.value = 0;
    }
    setState(() {}); // Rebuild on state change
  }

  @override
  void dispose() {
    AudioService.instance.removeListener(_onAudioStateChanged);
    _pulse.dispose();
    super.dispose();
  }

  void _toggle() {
    AudioService.instance.toggle();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final muted = AudioService.instance.isMuted;

    return Tooltip(
      message: muted ? 'Unmute desert ambience' : 'Mute',
      child: GestureDetector(
        onTap: _toggle,
        child: AnimatedBuilder(
          animation: _pulse,
          builder: (context, child) {
            final glow = muted ? 0.0 : (_pulse.value * 0.4 + 0.1);
            return Container(
              width: 34,
              height: 34,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: theme.colorScheme.surface.withValues(alpha: 0.4),
                border: Border.all(
                  color: muted
                      ? theme.colorScheme.onSurface.withValues(alpha: 0.2)
                      : theme.colorScheme.primary.withValues(alpha: 0.6),
                ),
                boxShadow: muted
                    ? null
                    : [
                        BoxShadow(
                          color: theme.colorScheme.primary.withValues(
                            alpha: glow,
                          ),
                          blurRadius: 12,
                        ),
                      ],
              ),
              child: Icon(
                muted ? Icons.volume_off_rounded : Icons.volume_up_rounded,
                size: 16,
                color: muted
                    ? theme.colorScheme.onSurface.withValues(alpha: 0.5)
                    : theme.colorScheme.primary,
              ),
            );
          },
        ),
      ),
    );
  }
}

class _HireMeButton extends StatelessWidget {
  const _HireMeButton({required this.theme});
  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    return MagneticButton(
      onTap: () => context.go('/contact'),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
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
              'Hire Me',
              style: theme.textTheme.labelLarge?.copyWith(
                color: theme.colorScheme.onPrimary,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(width: 8),
            Icon(
              Icons.arrow_forward_rounded,
              color: theme.colorScheme.onPrimary,
              size: 18,
            ),
          ],
        ),
      ),
    );
  }
}
