import 'package:flutter/scheduler.dart';
import 'package:flutter/material.dart';

/// A wrapper that applies 3D perspective transformations based on
/// the widget's scroll position within the viewport.
///
/// Creates a "Three.js-like" effect where sections rotate or scale
/// into view as they move toward the center of the screen.
///
/// Performance: Throttles rebuilds to once per frame to avoid jank
/// during fast scrolling.
class ThreeDScrollWrapper extends StatefulWidget {
  const ThreeDScrollWrapper({
    required this.child,
    this.perspective = 0.0012,
    this.maxRotation = 0.4, // Around 23 degrees
    this.maxScale = 1.0,
    this.minScale = 0.85,
    this.baseOffset = 100.0,
    super.key,
  });

  final Widget child;
  final double perspective;
  final double maxRotation;
  final double maxScale;
  final double minScale;
  final double baseOffset;

  @override
  State<ThreeDScrollWrapper> createState() => _ThreeDScrollWrapperState();
}

class _ThreeDScrollWrapperState extends State<ThreeDScrollWrapper> {
  bool _scrollUpdateScheduled = false;

  void _onScrollUpdate() {
    if (_scrollUpdateScheduled || !mounted) return;
    _scrollUpdateScheduled = true;
    SchedulerBinding.instance.addPostFrameCallback((_) {
      _scrollUpdateScheduled = false;
      if (mounted) setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final scrollable = Scrollable.maybeOf(context);
        if (scrollable == null) return widget.child;

        return NotificationListener<ScrollNotification>(
          onNotification: (notification) {
            if (notification is ScrollUpdateNotification) {
              _onScrollUpdate();
            }
            return false;
          },
          child: Builder(
            builder: (context) {
              final renderObject = context.findRenderObject() as RenderBox?;
              final scrollPosition = scrollable.position;

              if (renderObject == null ||
                  !renderObject.hasSize ||
                  !scrollPosition.hasPixels) {
                return widget.child;
              }

              // Get actual viewport and position
              final viewport = scrollPosition.viewportDimension;
              final ancestor = scrollable.context.findRenderObject();
              if (ancestor == null) return widget.child;

              final itemPosition = renderObject
                  .localToGlobal(Offset.zero, ancestor: ancestor)
                  .dy;

              // Normalize position: -1.0 (top) to 1.0 (bottom), 0.0 is center
              final center = viewport / 2;
              final itemHeight = renderObject.size.height;
              final itemCenter = itemPosition + (itemHeight / 2);

              // how far from center (normalized -1 to 1)
              double delta = (itemCenter - center) / center;
              delta = delta.clamp(-1.2, 1.2);

              // Calculate transformations
              final rotationX = -delta * widget.maxRotation;
              final scale =
                  widget.minScale +
                  (widget.maxScale - widget.minScale) *
                      (1 - delta.abs().clamp(0.0, 1.0));
              final opacity = (1.1 - delta.abs()).clamp(0.0, 1.0);
              final verticalShift = delta * widget.baseOffset;

              return RepaintBoundary(
                child: Opacity(
                  opacity: opacity,
                  child: Transform(
                    alignment: Alignment.center,
                    transform: Matrix4.identity()
                      ..setEntry(3, 2, widget.perspective)
                      ..rotateX(rotationX)
                      // ignore: deprecated_member_use
                      ..scale(scale)
                      // ignore: deprecated_member_use
                      ..translate(0.0, verticalShift),
                    child: widget.child,
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
