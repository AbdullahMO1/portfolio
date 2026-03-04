import 'dart:math' as math;

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

typedef TiltHoverBuilder = Widget Function(
  BuildContext context,
  bool isHovered,
);

/// Reusable "floating weighted card" hover effect:
/// - Tracks mouse position within the widget (normalized -1..1)
/// - Smoothly lerps toward the target for a weight/inertia feel
/// - Optional Z lift on hover
/// - Spring-back to flat on exit
class TiltHoverCard extends StatefulWidget {
  const TiltHoverCard({
    required this.builder,
    super.key,
    this.alignment = Alignment.center,
    this.perspective = 0.001,
    this.tiltStrength = 0.14,
    this.followSpeed = 12.0,
    this.hoverLift = 6.0,
    this.invertTilt = true,
    this.resetDuration = const Duration(milliseconds: 500),
    this.resetCurve = Curves.easeOutBack,
  });

  final TiltHoverBuilder builder;
  final Alignment alignment;
  final double perspective;
  final double tiltStrength;
  final double followSpeed;
  final double hoverLift;
  final bool invertTilt;
  final Duration resetDuration;
  final Curve resetCurve;

  @override
  State<TiltHoverCard> createState() => _TiltHoverCardState();
}

class _TiltHoverCardState extends State<TiltHoverCard>
    with TickerProviderStateMixin {
  bool _isHovered = false;
  Offset _targetOffset = Offset.zero;
  Offset _displayOffset = Offset.zero;

  late final AnimationController _resetController;
  late Animation<Offset> _resetAnimation;

  late final Ticker _ticker;
  Duration? _lastTick;

  @override
  void initState() {
    super.initState();
    _resetController = AnimationController(
      duration: widget.resetDuration,
      vsync: this,
    );
    _resetAnimation = Tween<Offset>(begin: Offset.zero, end: Offset.zero).animate(
      CurvedAnimation(parent: _resetController, curve: widget.resetCurve),
    );
    _resetController.addListener(() {
      setState(() {
        _targetOffset = _resetAnimation.value;
        _displayOffset = _resetAnimation.value;
      });
    });

    _ticker = createTicker(_onTick);
  }

  @override
  void dispose() {
    _ticker.dispose();
    _resetController.dispose();
    super.dispose();
  }

  void _onTick(Duration elapsed) {
    final last = _lastTick;
    _lastTick = elapsed;
    if (last == null) return;

    final dtSeconds = (elapsed - last).inMicroseconds / 1e6;
    if (dtSeconds <= 0) return;

    // Frame-rate independent smoothing.
    final alpha = 1 - math.exp(-widget.followSpeed * dtSeconds);
    final next = Offset.lerp(_displayOffset, _targetOffset, alpha)!;

    final changed = (next.dx - _displayOffset.dx).abs() > 0.0001 ||
        (next.dy - _displayOffset.dy).abs() > 0.0001;
    if (changed) {
      setState(() => _displayOffset = next);
    }

    final close = (next.dx - _targetOffset.dx).abs() < 0.002 &&
        (next.dy - _targetOffset.dy).abs() < 0.002;
    if (close) {
      _ticker.stop();
      _lastTick = null;
    }
  }

  void _startFollow() {
    if (!_ticker.isActive) {
      _lastTick = null;
      _ticker.start();
    }
  }

  void _onHover(PointerEvent event) {
    final renderBox = context.findRenderObject() as RenderBox?;
    if (renderBox == null) return;
    final size = renderBox.size;
    final dx = (event.localPosition.dx / size.width - 0.5) * 2.0;
    final dy = (event.localPosition.dy / size.height - 0.5) * 2.0;
    final next = Offset(dx.clamp(-1.0, 1.0), dy.clamp(-1.0, 1.0));
    if (_targetOffset.dx != next.dx || _targetOffset.dy != next.dy) {
      setState(() => _targetOffset = next);
      _startFollow();
    }
  }

  void _onExit(PointerExitEvent event) {
    setState(() => _isHovered = false);
    _ticker.stop();
    _lastTick = null;

    _targetOffset = _displayOffset;
    _resetAnimation =
        Tween<Offset>(begin: _displayOffset, end: Offset.zero).animate(
      CurvedAnimation(parent: _resetController, curve: widget.resetCurve),
    );
    _resetController
      ..reset()
      ..forward();
  }

  @override
  Widget build(BuildContext context) {
    final rotateY = (widget.invertTilt ? -_displayOffset.dx : _displayOffset.dx) *
        widget.tiltStrength;
    final rotateX = (widget.invertTilt ? _displayOffset.dy : -_displayOffset.dy) *
        widget.tiltStrength;

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: _onExit,
      onHover: _onHover,
      child: Transform(
        alignment: widget.alignment,
        transform: Matrix4.identity()
          ..setEntry(3, 2, widget.perspective)
          ..rotateX(rotateX)
          ..rotateY(rotateY)
          ..translate(0.0, 0.0, _isHovered ? widget.hoverLift : 0.0),
        child: widget.builder(context, _isHovered),
      ),
    );
  }
}

