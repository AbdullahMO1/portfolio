import 'dart:async';
import 'dart:math' show min;

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:portoflio/shared/widgets/magnetic_button.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:portoflio/shared/widgets/tilt_hover_card.dart';
import 'package:portoflio/theme/app_theme.dart';

/// Full-viewport hero section with name and tagline from resume (Gist/local).
/// - 3D perspective tilt on mouse movement
/// - Typewriter effect on tagline
/// - Animated gradient underline sweep
/// - Staggered entrance animations
/// - Scroll-fade (opacity + scale reduces on scroll)
/// - Magnetic hover CTA
class HeroSection extends StatefulWidget {
  const HeroSection({
    super.key,
    required this.name,
    required this.tagline,
    this.storyPreamble,
    this.storyLine,
  });

  final String name;
  final String tagline;
  final String? storyPreamble;
  final String? storyLine;

  @override
  State<HeroSection> createState() => _HeroSectionState();
}

class _HeroSectionState extends State<HeroSection>
    with TickerProviderStateMixin {
  late AnimationController _nameController;
  late AnimationController _taglineController;
  late AnimationController _ctaController;
  late AnimationController _underlineController;

  final ValueNotifier<String> _displayedTagline = ValueNotifier('');
  final ValueNotifier<bool> _showCursor = ValueNotifier(true);
  Timer? _typewriterTimer;
  Timer? _cursorTimer;
  int _charIndex = 0;

  @override
  void initState() {
    super.initState();
    _nameController = AnimationController(
      duration: const Duration(milliseconds: 350),
      vsync: this,
    );
    _taglineController = AnimationController(
      duration: const Duration(milliseconds: 250),
      vsync: this,
    );
    _ctaController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _underlineController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );

    _nameController.forward();
    final tagline = widget.tagline;
    Future.delayed(const Duration(milliseconds: 200), () {
      if (mounted) {
        _underlineController.forward();
        _startTypewriter(tagline);
      }
    });
    Future.delayed(Duration(milliseconds: 500 + tagline.length * 18), () {
      if (mounted) _taglineController.forward();
    });
    Future.delayed(Duration(milliseconds: 650 + tagline.length * 18), () {
      if (mounted) _ctaController.forward();
    });

    _cursorTimer = Timer.periodic(const Duration(milliseconds: 400), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }
      _showCursor.value = !_showCursor.value;
    });
  }

  @override
  void didUpdateWidget(covariant HeroSection oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.tagline != widget.tagline) {
      _typewriterTimer?.cancel();
      _charIndex = 0;
      _displayedTagline.value = '';
      _startTypewriter(widget.tagline);
    }
  }

  void _startTypewriter(String fullTagline) {
    _typewriterTimer?.cancel();
    _typewriterTimer = Timer.periodic(const Duration(milliseconds: 22), (
      timer,
    ) {
      if (!mounted) {
        timer.cancel();
        return;
      }
      if (_charIndex < fullTagline.length) {
        _charIndex++;
        _displayedTagline.value = fullTagline.substring(0, _charIndex);
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
    _displayedTagline.dispose();
    _showCursor.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final size = MediaQuery.sizeOf(context);
    final isDesktop = size.width >= 1200;

    final double horizontalPadding;
    if (size.width >= 1200) {
      horizontalPadding = 72;
    } else if (size.width >= 768) {
      horizontalPadding = 40;
    } else {
      horizontalPadding = 20;
    }

    return ConstrainedBox(
      constraints: BoxConstraints(minHeight: size.height),
      child: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: horizontalPadding,
            vertical: isDesktop ? 0 : 48,
          ),
          child: isDesktop
              ? Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      flex: 7,
                      child: _buildLeftColumn(theme, isDesktop),
                    ),
                    const SizedBox(width: 48),
                    Expanded(flex: 5, child: _buildPortraitCard(theme)),
                  ],
                )
              : Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildPillTag(theme),
                    const SizedBox(height: 24),
                    _buildPortraitCard(theme),
                    const SizedBox(height: 24),
                    _buildLeftColumn(theme, isDesktop),
                  ],
                ),
        ),
      ),
    );
  }

  Widget _buildPillTag(ThemeData theme) {
    final screenWidth = MediaQuery.sizeOf(context).width;
    return AnimatedBuilder(
      animation: _nameController,
      builder: (context, child) => Opacity(
        opacity: CurvedAnimation(
          parent: _nameController,
          curve: const Cubic(0.16, 1, 0.3, 1),
        ).value.clamp(0.0, 1.0),
        child: child,
      ),
      child:
          Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(999),
                  border: Border.all(
                    color: theme.colorScheme.primary.withValues(alpha: 0.3),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: theme.colorScheme.primary,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Flexible(
                      child: Text(
                        'OPEN FOR GLOBAL COLLABORATIONS',
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: theme.colorScheme.primary,
                          fontWeight: FontWeight.w800,
                          letterSpacing: screenWidth < 360 ? 0.5 : 1.5,
                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                    ),
                  ],
                ),
              )
              .animate(onPlay: (c) => c.repeat())
              .shimmer(
                duration: 2400.ms,
                delay: 1800.ms,
                color: theme.colorScheme.primary.withValues(alpha: 0.35),
              ),
    );
  }

  Widget _buildLeftColumn(ThemeData theme, bool isDesktop) {
    return Column(
      crossAxisAlignment: isDesktop
          ? CrossAxisAlignment.start
          : CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildPillTag(theme),
        const SizedBox(height: 20),
        // Arabesque ornamental divider
        _ArabesqueDivider(
          align: isDesktop ? Alignment.centerLeft : Alignment.center,
        ),
        const SizedBox(height: 20),
        if (widget.storyPreamble != null) ...[
          Text(
            widget.storyPreamble!,
            style: AppTheme.narrativeStyle(
              fontSize: isDesktop ? 20 : 16,
              color: theme.colorScheme.primary.withValues(alpha: 0.8),
            ),
            textAlign: isDesktop ? TextAlign.start : TextAlign.center,
          ),
          const SizedBox(height: 16),
        ],
        _buildName(theme, isDesktop),
        const SizedBox(height: 20),
        _buildSubtitle(theme, isDesktop),
        const SizedBox(height: 32),
        _buildCTA(theme, isDesktop),
      ],
    );
  }

  Widget _buildPortraitCard(ThemeData theme) {
    final screenWidth = MediaQuery.sizeOf(context).width;
    final double size = screenWidth < 768
        ? min(300.0, screenWidth - 48)
        : 400.0;
    return TiltHoverCard(
      tiltStrength: 0.14,
      followSpeed: 12.0,
      hoverLift: 6.0,
      resetDuration: const Duration(milliseconds: 500),
      resetCurve: Curves.easeOutBack,
      builder: (context, isHovered) => AnimatedBuilder(
        animation: _nameController,
        builder: (context, child) => Opacity(
          opacity: CurvedAnimation(
            parent: _nameController,
            curve: const Cubic(0.16, 1, 0.3, 1),
          ).value.clamp(0.0, 1.0),
          child: child,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: size,
              height: size * 1.25,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: theme.colorScheme.primary.withValues(alpha: 0.3),
                ),
                boxShadow: [
                  BoxShadow(
                    color: theme.colorScheme.primary.withValues(alpha: 0.2),
                    blurRadius: 40,
                    spreadRadius: 2,
                  ),
                  BoxShadow(
                    color: theme.colorScheme.scrim.withValues(alpha: 0.3),
                    blurRadius: 24,
                    offset: const Offset(0, 12),
                  ),
                ],
              ),
              clipBehavior: Clip.antiAlias,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  // Zoom slightly and align so face is centered (crops background)
                  Transform.scale(
                    scale: 1.15,
                    alignment: const Alignment(0, -0.25),
                    child: Image.asset(
                      'assets/images/avatar.jpeg',
                      fit: BoxFit.cover,
                      alignment: const Alignment(0, -0.35),
                      errorBuilder: (context, error, stackTrace) => Container(
                        color: theme.colorScheme.surfaceContainerHighest,
                        child: Icon(
                          Icons.person_rounded,
                          size: size * 0.4,
                          color: theme.colorScheme.primary,
                        ),
                      ),
                    ),
                  ),
                  // Stronger gradient to fade out background and keep focus on face
                  Positioned(
                    left: 0,
                    right: 0,
                    top: 0,
                    bottom: 0,
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.transparent,
                            theme.colorScheme.surface.withValues(alpha: 0.2),
                            theme.colorScheme.surface.withValues(alpha: 0.85),
                          ],
                          stops: const [0.0, 0.5, 1.0],
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    left: 24,
                    right: 24,
                    bottom: 24,
                    child: Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.surface.withValues(alpha: 0.7),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: theme.colorScheme.primary.withValues(
                            alpha: 0.15,
                          ),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'CURRENT FOCUS',
                            style: theme.textTheme.labelSmall?.copyWith(
                              color: theme.colorScheme.primary,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 1.5,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Senior & Team Leading Mobile Engineer',
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w700,
                              color: theme.colorScheme.onSurface,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
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
          ..._buildNameParts(theme, isDesktop),
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

  List<Widget> _buildNameParts(ThemeData theme, bool isDesktop) {
    final screenWidth = MediaQuery.sizeOf(context).width;
    final parts = widget.name.trim().split(RegExp(r'\s+'));
    final first = parts.isNotEmpty ? parts.first : '';
    final rest = parts.length > 1 ? parts.sublist(1).join(' ') : '';
    final double fontSize = isDesktop
        ? 80
        : screenWidth < 400
        ? 36
        : 48;
    return [
      if (first.isNotEmpty)
        FittedBox(
          fit: BoxFit.scaleDown,
          alignment: isDesktop ? Alignment.centerLeft : Alignment.center,
          child: Text(
            first,
            style: theme.textTheme.displayLarge?.copyWith(
              fontSize: fontSize,
              height: 1.0,
            ),
            textAlign: isDesktop ? TextAlign.start : TextAlign.center,
          ),
        ),
      if (rest.isNotEmpty)
        FittedBox(
          fit: BoxFit.scaleDown,
          alignment: isDesktop ? Alignment.centerLeft : Alignment.center,
          child: ShaderMask(
            shaderCallback: (bounds) => LinearGradient(
              colors: [
                theme.colorScheme.primary,
                theme.colorScheme.tertiary,
                theme.colorScheme.primary,
              ],
            ).createShader(bounds),
            child: Text(
              rest,
              style: theme.textTheme.displayLarge?.copyWith(
                fontSize: fontSize,
                height: 1.0,
                color: Colors.white,
              ),
              textAlign: isDesktop ? TextAlign.start : TextAlign.center,
            ),
          ),
        ),
    ];
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
      child: ValueListenableBuilder<String>(
        valueListenable: _displayedTagline,
        builder: (context, displayed, _) {
          return ValueListenableBuilder<bool>(
            valueListenable: _showCursor,
            builder: (context, showCursor, _) {
              return Column(
                crossAxisAlignment: isDesktop
                    ? CrossAxisAlignment.start
                    : CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    displayed + (showCursor ? '▌' : ''),
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                      height: 1.8,
                    ),
                    textAlign: isDesktop ? TextAlign.start : TextAlign.center,
                  ),
                  if (widget.storyLine != null) ...[
                    const SizedBox(height: 16),
                    // Accented story line with left gold border
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      decoration: BoxDecoration(
                        border: Border(
                          left: BorderSide(
                            color: theme.colorScheme.primary.withValues(
                              alpha: 0.6,
                            ),
                            width: 3,
                          ),
                        ),
                        color: theme.colorScheme.primary.withValues(
                          alpha: 0.04,
                        ),
                        borderRadius: const BorderRadius.only(
                          topRight: Radius.circular(8),
                          bottomRight: Radius.circular(8),
                        ),
                      ),
                      child: Text(
                        widget.storyLine!,
                        style: AppTheme.narrativeStyle(
                          fontSize: isDesktop ? 16 : 14,
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                        textAlign: TextAlign.start,
                      ),
                    ),
                  ],
                ],
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildCTA(ThemeData theme, bool isDesktop) {
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
      child: Wrap(
        spacing: 16,
        runSpacing: 12,
        alignment: isDesktop ? WrapAlignment.start : WrapAlignment.center,
        children: [
          MagneticButton(
            onTap: () => context.go('/projects'),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    theme.colorScheme.primary,
                    theme.colorScheme.tertiary,
                  ],
                ),
                borderRadius: BorderRadius.circular(999),
                boxShadow: [
                  BoxShadow(
                    color: theme.colorScheme.primary.withValues(alpha: 0.3),
                    blurRadius: 30,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Explore My Work',
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
          ),
          MagneticButton(
            onTap: () async {
              final uri = Uri.parse(
                'https://drive.google.com/file/d/1P60t-1uPkw2bb6J-G8Y8POp6NM6A2X1M/view?usp=sharing',
              );
              if (await canLaunchUrl(uri)) {
                await launchUrl(uri, mode: LaunchMode.externalApplication);
              }
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
              decoration: BoxDecoration(
                color: theme.colorScheme.surface.withValues(alpha: 0.7),
                borderRadius: BorderRadius.circular(999),
                border: Border.all(
                  color: theme.colorScheme.primary.withValues(alpha: 0.2),
                ),
              ),
              child: Text(
                'View Resume',
                style: theme.textTheme.labelLarge?.copyWith(
                  color: theme.colorScheme.onSurface,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Arabesque ornamental divider for HeroSection ────────────────────────────

class _ArabesqueDivider extends StatelessWidget {
  const _ArabesqueDivider({required this.align});
  final Alignment align;

  @override
  Widget build(BuildContext context) {
    const gold = AppTheme.saffron;
    return Align(
      alignment: align,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _line(gold, 24),
          _gem(gold, 8),
          _line(gold, 48),
          _gem(gold, 12),
          _line(gold, 48),
          _gem(gold, 8),
          _line(gold, 24),
        ],
      ),
    );
  }

  Widget _line(Color c, double w) => Container(
    width: w,
    height: 1,
    margin: const EdgeInsets.symmetric(horizontal: 2),
    decoration: BoxDecoration(
      gradient: LinearGradient(
        colors: [
          c.withValues(alpha: 0.0),
          c.withValues(alpha: 0.7),
          c.withValues(alpha: 0.0),
        ],
      ),
    ),
  );

  Widget _gem(Color c, double size) => Container(
    width: size,
    height: size,
    decoration: BoxDecoration(
      color: c.withValues(alpha: 0.15),
      border: Border.all(color: c.withValues(alpha: 0.5), width: 1),
      shape: BoxShape.rectangle,
      borderRadius: BorderRadius.circular(2),
    ),
    child: Center(
      child: Container(
        width: size * 0.4,
        height: size * 0.4,
        decoration: BoxDecoration(
          color: c.withValues(alpha: 0.6),
          shape: BoxShape.circle,
        ),
      ),
    ),
  );
}
