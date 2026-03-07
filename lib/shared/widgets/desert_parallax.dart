import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

/// Persian Prince desert parallax widget for creating depth
class DesertParallax extends StatefulWidget {
  const DesertParallax({
    super.key,
    required this.child,
    this.parallaxFactor = 0.3,
    this.mouseFactor = 0.0,
    this.desertLayers = 3,
  });

  final Widget child;

  /// Scroll parallax factor (0.0 = static, 0.5 = half-speed, 1.0 = full-speed)
  final double parallaxFactor;

  /// Mouse interaction factor for desert wind effects
  final double mouseFactor;

  /// Number of desert parallax layers
  final int desertLayers;

  @override
  State<DesertParallax> createState() => _DesertParallaxState();
}

class _DesertParallaxState extends State<DesertParallax> {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        double scrollOffset = 0;
        final scrollable = Scrollable.maybeOf(context);
        if (scrollable != null) {
          scrollOffset = scrollable.position.pixels;
        }

        double dx = 0;
        double dy = -scrollOffset * widget.parallaxFactor;

        // Add mouse-based desert wind effect
        final mousePosition = _getMousePosition(context);
        if (mousePosition != null && widget.mouseFactor > 0) {
          dx += (mousePosition.dx - 0.5) * widget.mouseFactor * 50;
          dy += (mousePosition.dy - 0.5) * widget.mouseFactor * 30;
        }

        return Stack(
          children: [
            // Background desert sky layer
            if (widget.desertLayers >= 1)
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        const Color(0xFF0D0D26), // Night sky
                        const Color(0xFFF78C4C), // Sunset orange
                        const Color(0xFFF0D8B2), // Desert sand
                      ],
                      stops: const [0.0, 0.3, 1.0],
                    ),
                  ),
                ),
              ),

            // Middle dunes layer
            if (widget.desertLayers >= 2)
              Positioned.fill(
                child: Transform.translate(
                  offset: Offset(dx * 0.5, dy * 0.5),
                  child: Opacity(
                    opacity: 0.7,
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: RadialGradient(
                          center: const Alignment(0.3, 0.7),
                          radius: 1.2,
                          colors: [
                            const Color(
                              0xFFD4AF37,
                            ).withValues(alpha: 0.3), // Persian gold
                            const Color(
                              0xFF8B4513,
                            ).withValues(alpha: 0.2), // Camel brown
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),

            // Foreground sand particles
            if (widget.desertLayers >= 3)
              Positioned.fill(
                child: Transform.translate(
                  offset: Offset(dx * 0.8, dy * 0.8),
                  child: Opacity(opacity: 0.5, child: _buildSandParticles()),
                ),
              ),

            // Main content
            Positioned.fill(child: widget.child),
          ],
        );
      },
    );
  }

  Widget _buildSandParticles() {
    return CustomPaint(
      painter: _SandParticlesPainter(),
      child: const SizedBox.expand(),
    );
  }

  Offset? _getMousePosition(BuildContext context) {
    final renderBox = context.findRenderObject() as RenderBox?;
    if (renderBox == null) return null;

    final globalPosition = renderBox.localToGlobal(Offset.zero);
    final size = renderBox.size;

    return Offset(
      globalPosition.dx / size.width,
      globalPosition.dy / size.height,
    );
  }
}

/// Custom painter for desert sand particles
class _SandParticlesPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFFF0D8B2)
          .withValues(alpha: 0.6) // Desert sand
      ..strokeWidth = 1.0;

    // Draw floating sand particles
    for (int i = 0; i < 20; i++) {
      final x = (i * 73.0) % size.width;
      final y = ((i * 37.0) + 50) % size.height;
      final radius = 1.0 + (i % 3) * 0.5;

      canvas.drawCircle(Offset(x, y), radius, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _SandParticlesPainter oldDelegate) => true;
}
