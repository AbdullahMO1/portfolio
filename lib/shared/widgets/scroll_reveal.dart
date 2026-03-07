import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/scheduler.dart';

enum RevealDirection { fromBottom, fromLeft, fromRight, scale, fromTop }

/// Reusable scroll-triggered reveal animation widget with Persian Prince desert theme.
///
/// Wraps any child and animates it into view when it enters the viewport.
/// Configurable direction, delay, curve, and parallax offset.
///
/// Uses desert-themed animations including sand reveal, magic carpet effects,
/// and Persian pattern transitions.
///
/// Performance: Throttles visibility checks to once per frame during scroll.
class ScrollReveal extends StatefulWidget {
  const ScrollReveal({
    super.key,
    required this.child,
    this.delay = Duration.zero,
    this.duration = const Duration(milliseconds: 800),
    this.curve = Curves.easeOutCubic,
    this.direction = RevealDirection.fromBottom,
    this.offset = 60.0,
    this.parallaxFactor = 0.0,
    this.persianEffect = false, // Enable Persian Prince desert effects
  });

  final Widget child;
  final Duration delay;
  final Duration duration;
  final Curve curve;
  final RevealDirection direction;
  final double offset;
  final double parallaxFactor;
  final bool persianEffect;

  @override
  State<ScrollReveal> createState() => _ScrollRevealState();
}

class _ScrollRevealState extends State<ScrollReveal>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _opacity;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _scaleAnimation;
  late AnimationController _sandController;
  late Animation<double> _sandWaveAnimation;
  late AnimationController _carpetController;
  late Animation<double> _carpetFloatAnimation;

  bool _hasTriggered = false;
  bool _checkScheduled = false;
  ScrollPosition? _scrollPosition;

  void _scheduleVisibilityCheck() {
    if (_checkScheduled || _hasTriggered || !mounted) return;
    _checkScheduled = true;
    SchedulerBinding.instance.addPostFrameCallback((_) {
      _checkScheduled = false;
      _checkVisibility();
    });
  }

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(duration: widget.duration, vsync: this);

    _opacity = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Interval(0, 0.6, curve: widget.curve),
      ),
    );

    final slideBegin = switch (widget.direction) {
      RevealDirection.fromBottom => Offset(0, widget.offset),
      RevealDirection.fromTop => Offset(0, -widget.offset),
      RevealDirection.fromLeft => Offset(-widget.offset, 0),
      RevealDirection.fromRight => Offset(widget.offset, 0),
      RevealDirection.scale => Offset.zero,
    };

    _slideAnimation = Tween<Offset>(
      begin: slideBegin,
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: widget.curve));

    _scaleAnimation = Tween<double>(
      begin: widget.direction == RevealDirection.scale ? 0.85 : 1.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: widget.curve));

    // Persian Prince desert effects
    if (widget.persianEffect) {
      // Sand wave animation
      _sandController = AnimationController(
        duration: const Duration(milliseconds: 2000),
        vsync: this,
      );
      _sandWaveAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(parent: _sandController, curve: Curves.easeInOutSine),
      );

      // Magic carpet float animation
      _carpetController = AnimationController(
        duration: const Duration(milliseconds: 1500),
        vsync: this,
      );
      _carpetFloatAnimation = Tween<double>(begin: -10.0, end: 0.0).animate(
        CurvedAnimation(parent: _carpetController, curve: Curves.easeOutBack),
      );
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _attachScrollListener();
      _checkVisibility();
    });
  }

  void _attachScrollListener() {
    final ctx = context;
    final scrollable = Scrollable.maybeOf(ctx);
    if (scrollable != null) {
      _scrollPosition = scrollable.position;
      _scrollPosition!.addListener(_scheduleVisibilityCheck);
    }
  }

  @override
  void dispose() {
    _scrollPosition?.removeListener(_scheduleVisibilityCheck);
    _controller.dispose();
    if (widget.persianEffect) {
      _sandController.dispose();
      _carpetController.dispose();
    }
    super.dispose();
  }

  void _checkVisibility() {
    if (_hasTriggered || !mounted) return;

    final renderObject = context.findRenderObject();

    if (renderObject == null || renderObject is! RenderBox) return;

    final viewport = RenderAbstractViewport.maybeOf(renderObject);
    if (viewport == null) {
      // Not inside a scroll view — trigger immediately
      _trigger();
      return;
    }

    final revealOffset = viewport.getOffsetToReveal(renderObject, 0.0);
    final viewportDimension = (viewport as RenderObject).paintBounds.height;
    final itemHeight = renderObject.size.height;

    // Get the current scroll offset
    final scrollable = Scrollable.maybeOf(context);

    if (scrollable == null) {
      _trigger();
      return;
    }
    final currentScroll = scrollable.position.pixels;

    // Check if item is within viewport (with desert buffer)
    final itemTop = revealOffset.offset - currentScroll;
    final buffer =
        viewportDimension * 0.2; // Increased buffer for Persian effects
    if (itemTop < viewportDimension - buffer && itemTop + itemHeight > buffer) {
      _trigger();
    }
  }

  void _trigger() {
    if (_hasTriggered) return;
    _hasTriggered = true;
    _scrollPosition?.removeListener(_scheduleVisibilityCheck);

    if (widget.delay > Duration.zero) {
      Future.delayed(widget.delay, () {
        if (mounted) _controller.forward();
      });
    } else {
      _controller.forward();
    }

    // Start Persian Prince effects
    if (widget.persianEffect) {
      _sandController.forward();
      _carpetController.forward();
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        // Calculate parallax offset for desert layers
        double parallaxOffset = 0.0;
        if (widget.parallaxFactor != 0.0) {
          final scrollable = Scrollable.maybeOf(context);
          if (scrollable != null) {
            parallaxOffset = scrollable.position.pixels * widget.parallaxFactor;
          }
        }

        Widget animatedChild = Transform.translate(
          offset: _slideAnimation.value + Offset(0, parallaxOffset),
          child: Transform.scale(
            scale: _scaleAnimation.value,
            child: Opacity(
              opacity: _opacity.value.clamp(0.0, 1.0),
              child: _buildPersianChild(child!),
            ),
          ),
        );

        // Add Persian Prince desert effects
        if (widget.persianEffect) {
          animatedChild = Stack(
            children: [
              // Sand wave effect
              Positioned.fill(
                child: CustomPaint(
                  painter: _SandWavePainter(_sandWaveAnimation.value),
                  child: const SizedBox.expand(),
                ),
              ),

              // Magic carpet float effect
              Positioned.fill(
                child: Transform.translate(
                  offset: Offset(0, _carpetFloatAnimation.value),
                  child: Opacity(
                    opacity: 0.3,
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            const Color(
                              0xFFD4AF37,
                            ).withOpacity(0.2), // Persian gold
                            const Color(
                              0xFFF78C4C,
                            ).withOpacity(0.1), // Sunset orange
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              animatedChild,
            ],
          );
        }

        return animatedChild;
      },
      child: widget.child,
    );
  }

  Widget _buildPersianChild(Widget child) {
    if (!widget.persianEffect) return child;

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: const Color(
              0xFFD4AF37,
            ).withOpacity(0.1), // Persian gold shadow
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: child,
    );
  }
}

/// Custom painter for desert sand wave effects
class _SandWavePainter extends CustomPainter {
  _SandWavePainter(this.waveProgress);

  final double waveProgress;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFFF0D8B2)
          .withOpacity(0.3) // Desert sand
      ..style = PaintingStyle.fill
      ..strokeWidth = 2.0;

    // Draw animated sand waves
    for (int i = 0; i < 5; i++) {
      final x = (size.width / 5) * i;
      final baseY = size.height * 0.7;
      final waveHeight = 20.0 * sin(waveProgress * 3.14159 + i * 0.5);
      final waveWidth = size.width / 5;

      final path = Path();
      path.moveTo(x - waveWidth / 2, baseY);

      for (int j = 0; j <= 20; j++) {
        final t = j / 20.0;
        final waveX = (x - waveWidth / 2) + waveWidth * t;
        final waveY = baseY + waveHeight * sin(t * 3.14159 * 2);

        if (j == 0) {
          path.moveTo(waveX, waveY);
        } else {
          path.lineTo(waveX, waveY);
        }
      }

      canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _SandWavePainter oldDelegate) =>
      waveProgress != oldDelegate.waveProgress;
}

/// Parallax layer that moves based on scroll offset.
///
/// Place inside a [Stack] within a scrollable view.
/// [factor] controls how fast this layer moves relative to scroll.
/// Negative factor = moves opposite to scroll (typical parallax).
class ParallaxLayer extends StatelessWidget {
  const ParallaxLayer({
    required this.child,
    this.factor = 0.3,
    this.mouseFactor = 0.0,
    this.mousePosition,
    super.key,
  });

  final Widget child;

  /// Scroll parallax factor (0.0 = static, 0.5 = half-speed, 1.0 = full speed).
  final double factor;

  /// How much the layer shifts based on mouse position.
  final double mouseFactor;

  /// Current mouse position (normalized 0-1).
  final Offset? mousePosition;

  @override
  Widget build(BuildContext context) {
    // We use a LayoutBuilder to compute effect dynamically
    return LayoutBuilder(
      builder: (context, constraints) {
        double scrollOffset = 0;
        final scrollable = Scrollable.maybeOf(context);
        if (scrollable != null) {
          scrollOffset = scrollable.position.pixels;
        }

        double dx = 0;
        double dy = -scrollOffset * factor;

        if (mousePosition != null && mouseFactor > 0) {
          dx += (mousePosition!.dx - 0.5) * mouseFactor * 50;
          dy += (mousePosition!.dy - 0.5) * mouseFactor * 30;
        }

        return Transform.translate(offset: Offset(dx, dy), child: child);
      },
    );
  }
}

/// Utility: Generates a random stagger delay for a list index.
Duration staggerDelay(int index, {int staggerMs = 80}) {
  return Duration(milliseconds: index * staggerMs);
}

/// Utility: Clamps a scroll progress value between 0.0 and 1.0
/// for a given scroll offset and range.
double scrollProgress(double offset, double start, double end) {
  return ((offset - start) / (end - start)).clamp(0.0, 1.0);
}
