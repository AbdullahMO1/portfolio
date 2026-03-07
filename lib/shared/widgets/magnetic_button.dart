import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

/// Persian Prince themed magnetic button with desert magic effects
class MagneticButton extends StatefulWidget {
  const MagneticButton({
    super.key,
    required this.child,
    required this.onTap,
    this.magneticStrength = 0.3,
    this.scaleOnHover = 1.05,
    this.duration = const Duration(milliseconds: 200),
    this.curve = Curves.easeOutCubic,
    this.persianTheme = false,
  });

  final Widget child;
  final VoidCallback onTap;
  final double magneticStrength;
  final double scaleOnHover;
  final Duration duration;
  final Curve curve;
  final bool persianTheme; // Apply Persian Prince styling

  @override
  State<MagneticButton> createState() => _MagneticButtonState();
}

class _MagneticButtonState extends State<MagneticButton>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late AnimationController _shimmerController;
  late Animation<double> _shimmerAnimation;
  late AnimationController _carpetController;
  late Animation<double> _carpetFloatAnimation;

  Offset _targetOffset = Offset.zero;
  Offset _currentOffset = Offset.zero;
  bool _isHovered = false;

  late Ticker _ticker;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(duration: widget.duration, vsync: this);
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: widget.scaleOnHover,
    ).animate(CurvedAnimation(parent: _controller, curve: widget.curve));

    // Persian magic shimmer effect
    _shimmerController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _shimmerAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _shimmerController, curve: Curves.easeInOutSine),
    );

    // Magic carpet floating effect
    _carpetController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );
    _carpetFloatAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _carpetController, curve: Curves.easeInOutBack),
    );

    // Smooth offset interpolation ticker
    _ticker = createTicker((_) {
      if (_currentOffset != _targetOffset) {
        setState(() {
          _currentOffset =
              Offset.lerp(_currentOffset, _targetOffset, 0.2) ?? _targetOffset;
        });
      }
    });
    _ticker.start();
  }

  @override
  void dispose() {
    _ticker.dispose();
    _controller.dispose();
    _shimmerController.dispose();
    _carpetController.dispose();
    super.dispose();
  }

  void _updateMousePosition(Offset position) {
    final renderBox = context.findRenderObject() as RenderBox?;
    if (renderBox == null) return;

    final size = renderBox.size;
    final localPosition = renderBox.globalToLocal(position);
    final center = Offset(size.width / 2, size.height / 2);

    // Calculate magnetic pull towards cursor (Persian magic effect)
    final delta = localPosition - center;
    final distance = delta.distance;

    if (distance < 100) {
      // Enhanced magnetic range for Persian theme
      final pullStrength = (1 - distance / 100) * widget.magneticStrength;
      _targetOffset = delta * pullStrength;
    } else {
      _targetOffset = Offset.zero;
    }
  }

  void _onMouseEnter(PointerEvent event) {
    setState(() {
      _isHovered = true;
    });
    _controller.forward();
    _updateMousePosition(event.position);

    // Start Persian shimmer effect
    if (widget.persianTheme) {
      _shimmerController.repeat();
      _carpetController.repeat();
    }
  }

  void _onMouseExit(PointerEvent event) {
    setState(() {
      _isHovered = false;
      _targetOffset = Offset.zero;
    });
    _controller.reverse();

    // Stop Persian effects
    if (widget.persianTheme) {
      _shimmerController.reset();
      _carpetController.reset();
    }
  }

  void _onMouseMove(PointerEvent event) {
    if (_isHovered) {
      _updateMousePosition(event.position);
    }
  }

  void _onTap() {
    widget.onTap();

    // Persian magic lamp effect on tap
    if (widget.persianTheme) {
      _controller.reset();
      _controller.forward().then((_) {
        _controller.reverse().then((_) {
          _controller.forward();
        });
      });
    } else {
      // Add a little bounce effect on tap
      _controller.reverse().then((_) {
        _controller.forward();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget buttonChild = widget.child;

    // Apply Persian Prince theme styling
    if (widget.persianTheme) {
      buttonChild = AnimatedBuilder(
        animation: _shimmerAnimation,
        builder: (context, child) {
          return Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  const Color(0xFFD4AF37), // Persian Gold
                  const Color(0xFFF78C4C), // Sunset Orange
                  const Color(0xFF8B4513), // Camel Brown
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFFD4AF37).withOpacity(0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: child,
          );
        },
        child: buttonChild,
      );
    }

    return MouseRegion(
      onEnter: _onMouseEnter,
      onExit: _onMouseExit,
      onHover: _onMouseMove,
      child: GestureDetector(
        onTap: _onTap,
        child: AnimatedBuilder(
          animation: Listenable.merge([
            _controller,
            _shimmerController,
            _carpetController,
          ]),
          builder: (context, child) {
            double yOffset = 0.0;
            if (widget.persianTheme && _isHovered) {
              yOffset = _carpetFloatAnimation.value * 10; // Magic carpet float
            }

            return Transform.translate(
              offset: _currentOffset + Offset(0, yOffset),
              child: Transform.scale(
                scale: _scaleAnimation.value,
                child: buttonChild,
              ),
            );
          },
          child: buttonChild,
        ),
      ),
    );
  }
}

/// Simple magnetic button wrapper for quick usage
class SimpleMagneticButton extends StatelessWidget {
  const SimpleMagneticButton({
    super.key,
    required this.child,
    required this.onTap,
    this.strength = 0.2,
  });

  final Widget child;
  final VoidCallback onTap;
  final double strength;

  @override
  Widget build(BuildContext context) {
    return MagneticButton(
      magneticStrength: strength,
      onTap: onTap,
      child: child,
    );
  }
}
