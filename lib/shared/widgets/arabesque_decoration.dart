import 'package:flutter/material.dart';

/// Arabesque decoration widget for ornamental design elements
class ArabesqueDecoration extends StatelessWidget {
  const ArabesqueDecoration({
    super.key,
    required this.color,
    required this.width,
    required this.height,
    this.opacity = 1.0,
  });

  final Color color;
  final double width;
  final double height;
  final double opacity;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(width, height),
      painter: _ArabesquePainter(color: color.withValues(alpha: opacity)),
    );
  }
}

class _ArabesquePainter extends CustomPainter {
  const _ArabesquePainter({required this.color});

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;

    final path = Path();

    // Create a simple arabesque pattern
    final centerX = size.width / 2;
    final centerY = size.height / 2;

    // Draw flowing curves
    path.moveTo(0, centerY);
    path.cubicTo(
      centerX * 0.3,
      centerY - size.height * 0.3,
      centerX * 0.7,
      centerY + size.height * 0.3,
      centerX,
      centerY,
    );
    path.cubicTo(
      centerX * 1.3,
      centerY - size.height * 0.3,
      centerX * 1.7,
      centerY + size.height * 0.3,
      size.width,
      centerY,
    );

    canvas.drawPath(path, paint);

    // Add decorative circles
    final circlePaint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    canvas.drawCircle(Offset(centerX * 0.25, centerY), 2, circlePaint);
    canvas.drawCircle(Offset(centerX * 0.75, centerY), 2, circlePaint);
    canvas.drawCircle(Offset(centerX * 1.25, centerY), 2, circlePaint);
  }

  @override
  bool shouldRepaint(covariant _ArabesquePainter oldDelegate) {
    return oldDelegate.color != color;
  }
}
