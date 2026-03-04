import 'dart:ui' as ui;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

/// Interactive shader background using a GLSL Fragment Shader.
///
/// Renders an animated plasma/particle-wave effect that responds
/// to cursor movement. Uses [Ticker] for frame-accurate time updates
/// and a [CustomPainter] for efficient GPU-driven rendering.
///
/// Performance: [RepaintBoundary] isolates shader repaints; [ValueNotifier]
/// limits rebuilds to the paint layer only. On low-end/small viewports,
/// falls back to gradient to reduce GPU load. Ticker runs at 30fps on
/// small screens to reduce draw call frequency.
class ShaderBackground extends StatefulWidget {
  const ShaderBackground({
    super.key,
    this.scrollController,
    this.mousePosition,
  });

  final ScrollController? scrollController;

  /// External mouse position (e.g. from Listener in parent). When the background
  /// is behind content, its own MouseRegion never receives hover events.
  final ValueListenable<Offset>? mousePosition;

  @override
  State<ShaderBackground> createState() => _ShaderBackgroundState();
}

class _ShaderBackgroundState extends State<ShaderBackground> with SingleTickerProviderStateMixin {
  ui.FragmentShader? _shader;
  late Ticker _ticker;
  final ValueNotifier<double> _time = ValueNotifier(0.0);
  final ValueNotifier<Offset> _mousePosition = ValueNotifier(Offset.zero);
  Offset _targetMousePosition = Offset.zero;
  final Stopwatch _stopwatch = Stopwatch();
  final ValueNotifier<double> _scrollProgress = ValueNotifier(0.0);

  static const double _mouseLerpSpeed = 6.0;

  /// Viewport thresholds for performance tiers.
  static const double _lowEndMaxWidth = 600;
  static const double _lowEndMaxHeight = 450;
  static const double _reducedFpsMinWidth = 600;
  static const double _reducedFpsMaxWidth = 900;

  int _frameCount = 0;
  double _lastViewportWidth = 0;

  bool _isLowEndViewport(Size size) =>
      size.width < _lowEndMaxWidth || size.height < _lowEndMaxHeight;

  bool get _useReducedFramerate =>
      _lastViewportWidth >= _reducedFpsMinWidth &&
      _lastViewportWidth < _reducedFpsMaxWidth;

  @override
  void initState() {
    super.initState();
    _loadShader();
    _ticker = createTicker(_onTick)..start();
    _stopwatch.start();
    widget.scrollController?.addListener(_onScroll);
    widget.mousePosition?.addListener(_onExternalMouse);
  }

  @override
  void didUpdateWidget(ShaderBackground oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.scrollController != oldWidget.scrollController) {
      oldWidget.scrollController?.removeListener(_onScroll);
      widget.scrollController?.addListener(_onScroll);
    }
    if (widget.mousePosition != oldWidget.mousePosition) {
      oldWidget.mousePosition?.removeListener(_onExternalMouse);
      widget.mousePosition?.addListener(_onExternalMouse);
    }
  }

  void _onExternalMouse() {
    _targetMousePosition = widget.mousePosition!.value;
  }

  void _onScroll() {
    if (widget.scrollController != null &&
        widget.scrollController!.hasClients &&
        widget.scrollController!.positions.isNotEmpty) {
      final pos = widget.scrollController!.position;
      if (pos.hasContentDimensions && pos.maxScrollExtent > 0) {
        _scrollProgress.value = (pos.pixels / pos.maxScrollExtent).clamp(0.0, 1.0);
      }
    }
  }

  Future<void> _loadShader() async {
    try {
      final program = await ui.FragmentProgram.fromAsset('assets/shaders/hero_bg.frag');
      if (mounted) {
        setState(() {
          _shader = program.fragmentShader();
        });
      }
    } catch (e) {
      debugPrint('Shader load failed: $e');
    }
  }

  double _lastTime = 0.0;

  void _onTick(Duration elapsed) {
    // Reduce to ~30fps on medium viewports to lower draw call frequency
    if (_useReducedFramerate && ++_frameCount % 2 != 0) return;

    final t = _stopwatch.elapsedMilliseconds / 1000.0;
    final dt = t - _lastTime;
    _lastTime = t;
    _time.value = t;

    final lerpFactor = (dt * _mouseLerpSpeed).clamp(0.0, 1.0);
    final current = _mousePosition.value;
    _mousePosition.value = Offset(
      current.dx + (_targetMousePosition.dx - current.dx) * lerpFactor,
      current.dy + (_targetMousePosition.dy - current.dy) * lerpFactor,
    );
  }

  @override
  void dispose() {
    widget.scrollController?.removeListener(_onScroll);
    widget.mousePosition?.removeListener(_onExternalMouse);
    _ticker.dispose();
    _stopwatch.stop();
    _shader?.dispose();
    _time.dispose();
    _mousePosition.dispose();
    _scrollProgress.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    _lastViewportWidth = size.width;

    // Low-end/small viewport: use gradient fallback to reduce GPU load
    if (_isLowEndViewport(size)) {
      return RepaintBoundary(
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                const Color(0xFF0F0A2A),
                Theme.of(context).colorScheme.primary.withValues(alpha: 0.3),
                const Color(0xFF0F0A2A),
              ],
            ),
          ),
        ),
      );
    }

    if (_shader == null) {
      return Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              const Color(0xFF0F0A2A),
              Theme.of(context).colorScheme.primary.withValues(alpha: 0.3),
              const Color(0xFF0F0A2A),
            ],
          ),
        ),
      );
    }

    return RepaintBoundary(
      child: ListenableBuilder(
        listenable: Listenable.merge([_time, _mousePosition, _scrollProgress]),
        builder: (context, _) {
          return CustomPaint(
            painter: _ShaderPainter(
              shader: _shader!,
              time: _time.value,
              mousePosition: _mousePosition.value,
              scrollProgress: _scrollProgress.value,
            ),
            size: Size.infinite,
          );
        },
      ),
    );
  }
}

class _ShaderPainter extends CustomPainter {
  _ShaderPainter({required this.shader, required this.time, required this.mousePosition, required this.scrollProgress});

  final ui.FragmentShader shader;
  final double time;
  final Offset mousePosition;
  final double scrollProgress;

  @override
  void paint(Canvas canvas, Size size) {
    shader
      ..setFloat(0, size.width)
      ..setFloat(1, size.height)
      ..setFloat(2, time)
      ..setFloat(3, mousePosition.dx)
      ..setFloat(4, mousePosition.dy)
      ..setFloat(5, scrollProgress);

    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), Paint()..shader = shader);
  }

  @override
  bool shouldRepaint(_ShaderPainter oldDelegate) => true;
}
