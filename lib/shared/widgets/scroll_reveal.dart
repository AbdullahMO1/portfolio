import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/scheduler.dart';

/// Reusable scroll-triggered reveal animation widget.
///
/// Wraps any child and animates it into view when it enters the viewport.
/// Configurable direction, delay, curve, and parallax offset.
///
/// Uses a [Visibility]-like detection approach via layout callbacks
/// to determine when the widget enters the visible area.
///
/// Performance: Throttles visibility checks to once per frame during scroll.
class ScrollReveal extends StatefulWidget {
  const ScrollReveal({
    required this.child,
    this.delay = Duration.zero,
    this.duration = const Duration(milliseconds: 800),
    this.curve = Curves.easeOutCubic,
    this.direction = RevealDirection.fromBottom,
    this.offset = 60.0,
    this.parallaxFactor = 0.0,
    super.key,
  });

  final Widget child;
  final Duration delay;
  final Duration duration;
  final Curve curve;
  final RevealDirection direction;

  /// How far the widget slides from its reveal direction.
  final double offset;

  /// Optional parallax factor (0.0 = none, 1.0 = full scroll speed).
  final double parallaxFactor;

  @override
  State<ScrollReveal> createState() => _ScrollRevealState();
}

enum RevealDirection { fromBottom, fromLeft, fromRight, scale, fromTop }

class _ScrollRevealState extends State<ScrollReveal>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _opacity;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _scaleAnimation;
  bool _hasTriggered = false;
  bool _checkScheduled = false;
  final GlobalKey _itemKey = GlobalKey();

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

    // Schedule a post-frame check in case widget is already visible
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkVisibility();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _checkVisibility() {
    if (_hasTriggered || !mounted) return;

    final renderObject = _itemKey.currentContext?.findRenderObject();
    if (renderObject == null || renderObject is! RenderBox) return;

    final viewport = RenderAbstractViewport.maybeOf(renderObject);
    if (viewport == null) {
      // Not inside a scroll view — trigger immediately
      _trigger();
      return;
    }

    final revealOffset = viewport.getOffsetToReveal(renderObject, 0.0);
    final viewportDimension = (viewport as RenderObject).paintBounds.height;
    final scrollOffset = revealOffset.offset;
    final itemHeight = renderObject.size.height;

    // Get the current scroll offset
    final scrollable = Scrollable.maybeOf(_itemKey.currentContext!);
    if (scrollable == null) {
      _trigger();
      return;
    }
    final currentScroll = scrollable.position.pixels;

    // Check if item is within viewport (with some buffer)
    final itemTop = scrollOffset - currentScroll;
    final buffer = viewportDimension * 0.15;
    if (itemTop < viewportDimension - buffer && itemTop + itemHeight > buffer) {
      _trigger();
    }
  }

  void _trigger() {
    if (_hasTriggered) return;
    _hasTriggered = true;

    if (widget.delay > Duration.zero) {
      Future.delayed(widget.delay, () {
        if (mounted) _controller.forward();
      });
    } else {
      _controller.forward();
    }
  }

  @override
  Widget build(BuildContext context) {
    return NotificationListener<ScrollNotification>(
      onNotification: (notification) {
        _scheduleVisibilityCheck();
        return false;
      },
      child: AnimatedBuilder(
        key: _itemKey,
        animation: _controller,
        builder: (context, child) {
          return Transform.translate(
            offset: _slideAnimation.value,
            child: Transform.scale(
              scale: _scaleAnimation.value,
              child: Opacity(
                opacity: _opacity.value.clamp(0.0, 1.0),
                child: child,
              ),
            ),
          );
        },
        child: widget.child,
      ),
    );
  }
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
