import 'dart:ui' as ui;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

/// Custom cursor effect overlay for desktop.
///
/// Shows a precise gold dot that replaces the system cursor with a
/// continuous ripple animation around it.
/// Uses [ValueNotifier] + [ListenableBuilder] to avoid full rebuilds on
/// every mouse move — only the cursor repaints.
class CustomCursorOverlay extends StatefulWidget {
  const CustomCursorOverlay({required this.child, super.key});

  final Widget child;

  @override
  State<CustomCursorOverlay> createState() => _CustomCursorOverlayState();
}

class _CustomCursorOverlayState extends State<CustomCursorOverlay>
    with SingleTickerProviderStateMixin {
  final ValueNotifier<Offset> _cursorPosition = ValueNotifier(Offset.zero);
  final ValueNotifier<bool> _isVisible = ValueNotifier(false);
  late AnimationController _rippleController;
  late Animation<double> _rippleAnimation;

  @override
  void initState() {
    super.initState();
    _rippleController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat();

    _rippleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _rippleController, curve: Curves.easeOut),
    );
  }

  @override
  void dispose() {
    _rippleController.dispose();
    _cursorPosition.dispose();
    _isVisible.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDesktop = MediaQuery.sizeOf(context).width >= 1024;

    return MouseRegion(
      cursor: isDesktop ? SystemMouseCursors.none : SystemMouseCursors.basic,
      onEnter: (_) => _isVisible.value = true,
      onExit: (_) => _isVisible.value = false,
      onHover: (event) {
        _cursorPosition.value = event.localPosition;
      },
      child: Stack(
        children: [
          widget.child,
          if (isDesktop)
            ListenableBuilder(
              listenable: Listenable.merge([_cursorPosition, _isVisible]),
              builder: (context, _) {
                if (!_isVisible.value) return const SizedBox.shrink();
                final pos = _cursorPosition.value;
                return Positioned(
                  left: pos.dx - 40,
                  top: pos.dy - 40,
                  child: IgnorePointer(
                    child: RepaintBoundary(
                      child: SizedBox(
                        width: 80,
                        height: 80,
                        child: AnimatedBuilder(
                          animation: _rippleAnimation,
                          builder: (context, child) {
                            return CustomPaint(
                              painter: _CursorRipplePainter(
                                progress: _rippleAnimation.value,
                                goldColor: const Color(0xFFD4AF37),
                              ),
                              size: const Size(80, 80),
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
        ],
      ),
    );
  }
}

/// Paints the cursor dot with expanding ripple rings and 3D depth.
class _CursorRipplePainter extends CustomPainter {
  _CursorRipplePainter({required this.progress, required this.goldColor});

  final double progress;
  final Color goldColor;

  static const double _dotRadius = 4.0;
  static const int _rippleCount = 2;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);

    for (int i = 0; i < _rippleCount; i++) {
      final phase = (progress + i / _rippleCount) % 1.0;
      final radius = 8.0 + phase * 28.0;
      final fade = (1.0 - phase).clamp(0.0, 1.0);

      // 1. Outer shadow — dark, blurred, offset (depth below)
      final shadowOffset = Offset(2, 2);
      final shadowPaint = Paint()
        ..color = Color.lerp(goldColor, Colors.black, 0.6)!
            .withValues(alpha: fade * 0.35)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3.0
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4);
      canvas.drawCircle(center + shadowOffset, radius, shadowPaint);

      // 2. Soft glow layer — thick blurred band
      final glowPaint = Paint()
        ..color = goldColor.withValues(alpha: fade * 0.2)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 6.0
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6);
      canvas.drawCircle(center, radius, glowPaint);

      // 3. Main ring — radial gradient for 3D dome/orb feel
      final innerR = radius - 2.0;
      final outerR = radius + 2.0;
      final gradientPaint = Paint()
        ..shader = ui.Gradient.radial(
          center,
          outerR,
          [
            goldColor.withValues(alpha: fade * 0.5),
            goldColor.withValues(alpha: fade * 0.15),
            goldColor.withValues(alpha: fade * 0.0),
          ],
          [0.0, (innerR / outerR), 1.0],
        )
        ..style = PaintingStyle.stroke
        ..strokeWidth = 4.0;
      canvas.drawCircle(center, radius, gradientPaint);
    }

    // Central dot — outer shadow for depth
    canvas.drawCircle(
      center + const Offset(1.5, 1.5),
      _dotRadius + 3,
      (Paint()
        ..color = Colors.black.withValues(alpha: 0.3)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3)),
    );
    // Outer glow
    canvas.drawCircle(
      center,
      _dotRadius + 4,
      Paint()
        ..color = goldColor.withValues(alpha: 0.2)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4),
    );
    // Core fill
    canvas.drawCircle(
      center,
      _dotRadius,
      Paint()..color = goldColor,
    );
    // Inner highlight
    canvas.drawCircle(
      center - const Offset(0.5, 0.5),
      _dotRadius - 1,
      Paint()
        ..color = goldColor.withValues(alpha: 0.4)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 0.5,
    );
  }

  @override
  bool shouldRepaint(_CursorRipplePainter oldDelegate) =>
      progress != oldDelegate.progress;
}
