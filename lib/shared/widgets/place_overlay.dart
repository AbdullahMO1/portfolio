import 'package:flutter/material.dart';

/// Place overlay widget for journey progress visualization
class PlaceOverlay extends StatelessWidget {
  const PlaceOverlay({super.key, required this.placeProgress});

  final ValueNotifier<double> placeProgress;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<double>(
      valueListenable: placeProgress,
      builder: (context, progress, child) {
        return CustomPaint(
          painter: _PlaceOverlayPainter(progress: progress),
          child: Container(),
        );
      },
    );
  }
}

class _PlaceOverlayPainter extends CustomPainter {
  const _PlaceOverlayPainter({required this.progress});

  final double progress;

  @override
  void paint(Canvas canvas, Size size) {
    // Draw subtle place-based overlay effects
    final paint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Colors.transparent,
          Colors.white.withValues(alpha: 0.05 * progress),
          Colors.transparent,
        ],
        stops: const [0.0, 0.5, 1.0],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));

    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), paint);

    // Add place-specific decorative elements
    if (progress > 1.0) {
      _drawPlaceMarkers(canvas, size, progress);
    }
  }

  void _drawPlaceMarkers(Canvas canvas, Size size, double progress) {
    final markerPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.1 * progress)
      ..style = PaintingStyle.fill;

    // Draw circular markers at different positions
    final positions = [
      Offset(size.width * 0.2, size.height * 0.3),
      Offset(size.width * 0.8, size.height * 0.2),
      Offset(size.width * 0.5, size.height * 0.7),
    ];

    for (int i = 0; i < positions.length; i++) {
      final markerProgress = ((progress - 1.0) * 2).clamp(0.0, 1.0);
      final radius = 3.0 + (markerProgress * 5.0);

      canvas.drawCircle(positions[i], radius, markerPaint);
    }
  }

  @override
  bool shouldRepaint(covariant _PlaceOverlayPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}
