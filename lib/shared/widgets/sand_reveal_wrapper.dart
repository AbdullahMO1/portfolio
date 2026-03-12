import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:visibility_detector/visibility_detector.dart';

/// Sand reveal wrapper — triggers a cinematic dune-rise animation when the
/// widget scrolls into viewport.
///
/// Uses [VisibilityDetector] so the animation only plays when actually visible
/// (not while pre-built off-screen in a PageView).
/// The clip uses a sine-wave edge to mimic a rising sand dune.
class SandRevealWrapper extends StatefulWidget {
  const SandRevealWrapper({
    super.key,
    required this.child,
    this.delay = Duration.zero,
    this.direction = RevealDirection.fromBottom,
    this.visibilityThreshold = 0.02,
  });

  final Widget child;
  final Duration delay;
  final RevealDirection direction;

  /// Fraction of the widget that must be visible before the animation starts.
  final double visibilityThreshold;

  @override
  State<SandRevealWrapper> createState() => _SandRevealWrapperState();
}

class _SandRevealWrapperState extends State<SandRevealWrapper>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  bool _triggered = false;

  // Unique key per widget instance so VisibilityDetector doesn't share state
  late final String _visKey;

  @override
  void initState() {
    super.initState();
    _visKey = UniqueKey().toString();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onVisibilityChanged(VisibilityInfo info) {
    if (!_triggered && info.visibleFraction >= widget.visibilityThreshold) {
      _triggered = true;
      // Use addPostFrameCallback to avoid "build mid-cycle" errors on Web/Desktop
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        Future.delayed(widget.delay, () {
          if (mounted) _controller.forward();
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return VisibilityDetector(
      key: Key(_visKey),
      onVisibilityChanged: _onVisibilityChanged,
      child: AnimatedBuilder(
        animation: _animation,
        builder: (context, child) {
          final value = _animation.value;
          return Opacity(
            opacity: value.clamp(0.0, 1.0),
            child: ClipPath(
              clipper: _WavySandClipper(
                progress: value,
                direction: widget.direction,
              ),
              child: child,
            ),
          );
        },
        child: widget.child,
      ),
    );
  }
}

/// Clips with a sine-wave leading edge to mimic a rising desert dune.
class _WavySandClipper extends CustomClipper<Path> {
  const _WavySandClipper({required this.progress, required this.direction});

  final double progress;
  final RevealDirection direction;

  @override
  Path getClip(Size size) {
    final path = Path();

    switch (direction) {
      case RevealDirection.fromBottom:
        final revealTop = size.height * (1.0 - progress);
        _addWavyReveal(path, size, revealTop, fromTop: false);

      case RevealDirection.fromTop:
        final revealBottom = size.height * progress;
        _addWavyReveal(path, size, revealBottom, fromTop: true);

      case RevealDirection.fromLeft:
        path.addRect(Rect.fromLTWH(0, 0, size.width * progress, size.height));

      case RevealDirection.fromRight:
        final x = size.width * (1.0 - progress);
        path.addRect(Rect.fromLTWH(x, 0, size.width * progress, size.height));

      case RevealDirection.scale:
        final cx = size.width / 2;
        final cy = size.height / 2;
        path.addRect(
          Rect.fromCenter(
            center: Offset(cx, cy),
            width: size.width * progress,
            height: size.height * progress,
          ),
        );
    }

    return path;
  }

  /// Adds a region bounded by a wavy sine-wave line.
  void _addWavyReveal(
    Path path,
    Size size,
    double edgeY, {
    required bool fromTop,
  }) {
    const waveCount = 6;
    const waveAmplitude = 8.0;
    final wavelength = size.width / waveCount;

    if (fromTop) {
      // Reveal from top: filled region goes from y=0 down to wavy edgeY
      path.moveTo(0, 0);
      path.lineTo(size.width, 0);
      path.lineTo(size.width, edgeY);
      for (int i = waveCount; i >= 0; i--) {
        final x = i * wavelength;
        final waveY =
            edgeY + math.sin((i / waveCount) * 2 * math.pi) * waveAmplitude;
        path.lineTo(x, waveY);
      }
      path.close();
    } else {
      // Reveal from bottom: filled region goes from wavy edgeY down to bottom
      path.moveTo(0, size.height);
      path.lineTo(size.width, size.height);
      path.lineTo(size.width, edgeY);
      for (int i = waveCount; i >= 0; i--) {
        final x = i * wavelength;
        final waveY =
            edgeY + math.sin((i / waveCount) * 2 * math.pi) * waveAmplitude;
        path.lineTo(x, waveY);
      }
      path.close();
    }
  }

  @override
  bool shouldReclip(covariant _WavySandClipper oldClipper) =>
      oldClipper.progress != progress;
}

enum RevealDirection { fromTop, fromBottom, fromLeft, fromRight, scale }
