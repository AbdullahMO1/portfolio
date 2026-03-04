import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Full-viewport hero section with:
/// - 3D perspective tilt on mouse movement
/// - Typewriter effect on tagline
/// - Animated gradient underline sweep
/// - Staggered entrance animations
/// - Scroll-fade (opacity + scale reduces on scroll)
/// - Magnetic hover CTA
///
/// Performance: [ValueNotifier] for mouse offset limits rebuilds to 3D transform
/// layer only; typewriter uses isolated [ValueNotifier] to avoid full rebuilds.
class HeroSection extends StatefulWidget {
  const HeroSection({super.key});

  @override
  State<HeroSection> createState() => _HeroSectionState();
}

class _HeroSectionState extends State<HeroSection>
    with TickerProviderStateMixin {
  // Entrance animation controllers
  late AnimationController _nameController;
  late AnimationController _taglineController;
  late AnimationController _ctaController;
  late AnimationController _underlineController;

  // 3D perspective — ValueNotifier so only transform layer rebuilds
  final ValueNotifier<Offset> _mouseOffset = ValueNotifier(Offset.zero);

  // Typewriter state — isolated to avoid full HeroSection rebuilds
  static const String _fullTagline = 'Senior Flutter Developer & Team Lead';
  final ValueNotifier<String> _displayedTagline = ValueNotifier('');
  final ValueNotifier<bool> _showCursor = ValueNotifier(true);
  Timer? _typewriterTimer;
  Timer? _cursorTimer;
  int _charIndex = 0;

  @override
  void initState() {
    super.initState();

    _nameController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    _taglineController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _ctaController = AnimationController(
      duration: const Duration(milliseconds: 700),
      vsync: this,
    );
    _underlineController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    // Staggered entrance
    _nameController.forward();
    Future.delayed(const Duration(milliseconds: 600), () {
      if (mounted) {
        _underlineController.forward();
        _startTypewriter();
      }
    });
    Future.delayed(
      const Duration(milliseconds: 1800 + _fullTagline.length * 50),
      () {
        if (mounted) _taglineController.forward();
      },
    );
    Future.delayed(
      const Duration(milliseconds: 2200 + _fullTagline.length * 50),
      () {
        if (mounted) _ctaController.forward();
      },
    );

    // Blinking cursor — updates ValueNotifier, only typewriter row rebuilds
    _cursorTimer = Timer.periodic(const Duration(milliseconds: 530), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }
      _showCursor.value = !_showCursor.value;
    });
  }

  void _startTypewriter() {
    _typewriterTimer = Timer.periodic(const Duration(milliseconds: 55), (
      timer,
    ) {
      if (!mounted) {
        timer.cancel();
        return;
      }
      if (_charIndex < _fullTagline.length) {
        _charIndex++;
        _displayedTagline.value = _fullTagline.substring(0, _charIndex);
      } else {
        timer.cancel();
      }
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _taglineController.dispose();
    _ctaController.dispose();
    _underlineController.dispose();
    _typewriterTimer?.cancel();
    _cursorTimer?.cancel();
    _mouseOffset.dispose();
    _displayedTagline.dispose();
    _showCursor.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final size = MediaQuery.sizeOf(context);
    final isDesktop = size.width >= 1200;
    final center = Offset(size.width / 2, size.height / 2);

    return MouseRegion(
      onHover: (event) {
        _mouseOffset.value = Offset(
          (event.position.dx - center.dx) / center.dx,
          (event.position.dy - center.dy) / center.dy,
        );
      },
      child: SizedBox(
        height: size.height,
        child: Center(
          child: ListenableBuilder(
            listenable: _mouseOffset,
            builder: (context, _) {
              final offset = _mouseOffset.value;
              final rotateY = offset.dx * 0.015;
              final rotateX = -offset.dy * 0.015;
              return AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                curve: Curves.easeOutSine,
                transform: Matrix4.identity()
                  ..setEntry(3, 2, 0.001) // perspective
                  ..rotateX(rotateX)
                  ..rotateY(rotateY),
                transformAlignment: Alignment.center,
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: isDesktop ? 120 : 28,
                  ),
                  child: SingleChildScrollView(
                    physics: const ClampingScrollPhysics(),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: isDesktop
                          ? CrossAxisAlignment.start
                          : CrossAxisAlignment.center,
                      children: [
                        _buildNameRow(theme, isDesktop, offset),
                        const SizedBox(height: 20),
                        _buildTypewriter(theme, isDesktop),
                        const SizedBox(height: 12),
                        _buildSubtitle(theme, isDesktop),
                        const SizedBox(height: 48),
                        _buildCTA(theme),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  /// Row or Column of 3D profile image + name (desktop: side-by-side, mobile: stacked).
  Widget _buildNameRow(ThemeData theme, bool isDesktop, Offset mouseOffset) {
    final imageWidget = _buildProfileImage(theme, isDesktop, mouseOffset);
    final nameWidget = _buildName(theme, isDesktop);
    if (isDesktop) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          imageWidget,
          const SizedBox(width: 40),
          nameWidget,
        ],
      );
    }
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        imageWidget,
        const SizedBox(height: 24),
        nameWidget,
      ],
    );
  }

  /// Sample profile image with 3D tilt following mouse.
  Widget _buildProfileImage(ThemeData theme, bool isDesktop, Offset mouseOffset) {
    const double size = 140;
    final rotateY = mouseOffset.dx * 0.08;
    final rotateX = -mouseOffset.dy * 0.08;
    return AnimatedBuilder(
      animation: _nameController,
      builder: (context, child) => Opacity(
        opacity: CurvedAnimation(
          parent: _nameController,
          curve: const Cubic(0.16, 1, 0.3, 1),
        ).value.clamp(0.0, 1.0),
        child: Transform.translate(
          offset: Offset(0, 40 * (1 - CurvedAnimation(
            parent: _nameController,
            curve: const Cubic(0.16, 1, 0.3, 1),
          ).value)),
          child: child,
        ),
      ),
      child: Transform(
        transform: Matrix4.identity()
          ..setEntry(3, 2, 0.002)
          ..rotateX(rotateX)
          ..rotateY(rotateY),
        alignment: Alignment.center,
        child: Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(size / 2),
            boxShadow: [
              BoxShadow(
                color: theme.colorScheme.primary.withValues(alpha: 0.35),
                blurRadius: 24,
                spreadRadius: 2,
                offset: const Offset(0, 12),
              ),
              BoxShadow(
                color: theme.colorScheme.scrim.withValues(alpha: 0.25),
                blurRadius: 16,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          clipBehavior: Clip.antiAlias,
          child: Image.network(
            'https://picsum.photos/seed/portrait/400/400',
            fit: BoxFit.cover,
            width: size,
            height: size,
            errorBuilder: (_, _, _) => Container(
              color: theme.colorScheme.surfaceContainerHighest,
              child: Icon(
                Icons.person_rounded,
                size: size * 0.5,
                color: theme.colorScheme.primary,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildName(ThemeData theme, bool isDesktop) {
    final nameAnimation = CurvedAnimation(
      parent: _nameController,
      curve: const Cubic(0.16, 1, 0.3, 1), // Custom overshoot-free decelerate
    );

    return AnimatedBuilder(
      animation: _nameController,
      builder: (context, child) => Opacity(
        opacity: nameAnimation.value.clamp(0.0, 1.0),
        child: Transform.translate(
          offset: Offset(0, 40 * (1 - nameAnimation.value)),
          child: child,
        ),
      ),
      child: Column(
        crossAxisAlignment: isDesktop
            ? CrossAxisAlignment.start
            : CrossAxisAlignment.center,
        children: [
          Text(
            'Abdullah',
            style: theme.textTheme.displayLarge?.copyWith(
              fontSize: isDesktop ? 80 : 48,
              height: 1.0,
            ),
            textAlign: isDesktop ? TextAlign.start : TextAlign.center,
          ),
          // Name with gold gradient
          ShaderMask(
            shaderCallback: (bounds) => LinearGradient(
              colors: [
                theme.colorScheme.primary, // gold
                theme.colorScheme.tertiary, // amber
                theme.colorScheme.primary,
              ],
            ).createShader(bounds),
            child: Text(
              'Mohammed',
              style: theme.textTheme.displayLarge?.copyWith(
                fontSize: isDesktop ? 80 : 48,
                height: 1.0,
                color: Colors.white, // ShaderMask needs white base
              ),
              textAlign: isDesktop ? TextAlign.start : TextAlign.center,
            ),
          ),
          const SizedBox(height: 8),
          // Animated gradient underline
          AnimatedBuilder(
            animation: _underlineController,
            builder: (context, _) {
              return Container(
                width:
                    (isDesktop ? 300.0 : 200.0) *
                    CurvedAnimation(
                      parent: _underlineController,
                      curve: Curves.easeOutExpo,
                    ).value,
                height: 3,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      theme.colorScheme.primary,
                      theme.colorScheme.tertiary,
                      theme.colorScheme.primary.withValues(alpha: 0.0),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(2),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildTypewriter(ThemeData theme, bool isDesktop) {
    return ListenableBuilder(
      listenable: Listenable.merge([_displayedTagline, _showCursor]),
      builder: (context, _) {
        return Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: isDesktop
              ? MainAxisAlignment.start
              : MainAxisAlignment.center,
          children: [
            Text(
              _displayedTagline.value,
              style: theme.textTheme.headlineSmall?.copyWith(
                color: theme.colorScheme.primary,
                fontWeight: FontWeight.w400,
                letterSpacing: 1.0,
                fontFamily: 'monospace',
              ),
            ),
            AnimatedOpacity(
              opacity: _showCursor.value ? 1.0 : 0.0,
              duration: const Duration(milliseconds: 100),
              child: Text(
                '|',
                style: theme.textTheme.headlineSmall?.copyWith(
                  color: theme.colorScheme.primary,
                  fontWeight: FontWeight.w300,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildSubtitle(ThemeData theme, bool isDesktop) {
    final animation = CurvedAnimation(
      parent: _taglineController,
      curve: Curves.easeOut,
    );
    return AnimatedBuilder(
      animation: _taglineController,
      builder: (context, child) => Opacity(
        opacity: animation.value.clamp(0.0, 1.0),
        child: Transform.translate(
          offset: Offset(0, 15 * (1 - animation.value)),
          child: child,
        ),
      ),
      child: Text(
        'Crafting beautiful, performant mobile experiences\nwith Flutter & advanced architecture patterns',
        style: theme.textTheme.bodyLarge?.copyWith(
          color: theme.colorScheme.onSurfaceVariant,
          height: 1.8,
        ),
        textAlign: isDesktop ? TextAlign.start : TextAlign.center,
      ),
    );
  }

  Widget _buildCTA(ThemeData theme) {
    final animation = CurvedAnimation(
      parent: _ctaController,
      curve: Curves.elasticOut,
    );
    return AnimatedBuilder(
      animation: _ctaController,
      builder: (context, child) => Opacity(
        opacity: animation.value.clamp(0.0, 1.0),
        child: Transform.scale(
          scale: 0.5 + animation.value * 0.5,
          child: child,
        ),
      ),
      child: _MagneticButton(
        onTap: () => context.go('/projects'),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 36, vertical: 18),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [theme.colorScheme.primary, theme.colorScheme.tertiary],
            ),
            borderRadius: BorderRadius.circular(14),
            boxShadow: [
              BoxShadow(
                color: theme.colorScheme.primary.withValues(alpha: 0.3),
                blurRadius: 30,
                offset: const Offset(0, 10),
              ),
              BoxShadow(
                color: theme.colorScheme.primary.withValues(alpha: 0.1),
                blurRadius: 60,
                spreadRadius: 10,
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'EXPLORE MY WORK',
                style: theme.textTheme.labelLarge?.copyWith(
                  color: theme.colorScheme.onPrimary,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 2.0,
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
    );
  }
}

/// Magnetic hover button — slightly translates toward cursor.
class _MagneticButton extends StatefulWidget {
  const _MagneticButton({required this.child, required this.onTap});
  final Widget child;
  final VoidCallback onTap;

  @override
  State<_MagneticButton> createState() => _MagneticButtonState();
}

class _MagneticButtonState extends State<_MagneticButton> {
  final ValueNotifier<Offset> _offset = ValueNotifier(Offset.zero);
  final ValueNotifier<bool> _isHovered = ValueNotifier(false);

  @override
  void dispose() {
    _offset.dispose();
    _isHovered.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => _isHovered.value = true,
      onExit: (_) {
        _isHovered.value = false;
        _offset.value = Offset.zero;
      },
      onHover: (event) {
        if (!_isHovered.value) return;
        final renderBox = context.findRenderObject() as RenderBox?;
        if (renderBox == null) return;
        final size = renderBox.size;
        final center = Offset(size.width / 2, size.height / 2);
        final delta = event.localPosition - center;
        _offset.value = Offset(delta.dx * 0.2, delta.dy * 0.2);
      },
      child: GestureDetector(
        onTap: widget.onTap,
        child: ListenableBuilder(
          listenable: Listenable.merge([_offset, _isHovered]),
          builder: (context, _) {
            return AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              curve: Curves.easeOutCubic,
              // ignore: deprecated_member_use
              transform: Matrix4.identity()
                // ignore: deprecated_member_use
                ..translate(_offset.value.dx, _offset.value.dy)
                // ignore: deprecated_member_use
                ..scale(_isHovered.value ? 1.06 : 1.0),
              transformAlignment: Alignment.center,
              child: widget.child,
            );
          },
        ),
      ),
    );
  }
}
