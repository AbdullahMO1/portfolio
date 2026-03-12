import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:portoflio/core/services/desert_audio_service.dart';

/// Persian Prince character widget with desert-themed animations
class PersianPrinceCharacter extends ConsumerStatefulWidget {
  const PersianPrinceCharacter({
    super.key,
    this.size = 80.0,
    this.state = PrinceState.idle,
    this.position = Offset.zero,
  });

  final double size;
  final PrinceState state;
  final Offset position;

  @override
  ConsumerState<PersianPrinceCharacter> createState() =>
      _PersianPrinceCharacterState();
}

class _PersianPrinceCharacterState extends ConsumerState<PersianPrinceCharacter>
    with TickerProviderStateMixin {
  late AnimationController _idleController;
  late AnimationController _walkController;
  late Animation<double> _idleAnimation;
  late Animation<double> _walkAnimation;

  PrinceState _currentState = PrinceState.idle;

  @override
  void initState() {
    super.initState();

    // Idle animation - subtle breathing
    _idleController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );
    _idleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _idleController, curve: Curves.easeInOutSine),
    );

    // Walking animation
    _walkController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _walkAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _walkController, curve: Curves.linear));

    _idleController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _idleController.dispose();
    _walkController.dispose();
    super.dispose();
  }

  /// Start walking animation
  void startWalking() {
    if (_currentState != PrinceState.walking) {
      setState(() {
        _currentState = PrinceState.walking;
      });
      _idleController.stop();
      _walkController.forward();

      // Play footstep sound
      final audioService = ref.read(desertAudioServiceProvider);
      audioService.playSoundEffect(DesertSound.footstepInSand);
    }
  }

  /// Stop walking animation
  void stopWalking() {
    if (_currentState != PrinceState.idle) {
      setState(() {
        _currentState = PrinceState.idle;
      });
      _walkController.stop();
      _idleController.forward();
    }
  }

  /// Play magic lamp animation
  void playMagicLamp() {
    // Add glow effect
    setState(() {
      _currentState = PrinceState.magic;
    });

    // Play magic lamp sound
    final audioService = ref.read(desertAudioServiceProvider);
    audioService.playSoundEffect(DesertSound.magicLamp);

    // Reset to idle after magic effect
    Future.delayed(const Duration(milliseconds: 1000), () {
      setState(() {
        _currentState = PrinceState.idle;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: widget.position.dx,
      top: widget.position.dy,
      child: SizedBox(
        width: widget.size,
        height: widget.size,
        child: AnimatedBuilder(
          animation: _idleController,
          builder: (context, child) {
            return AnimatedBuilder(
              animation: _walkController,
              builder: (context, child) {
                return _buildPrinceCharacter(child);
              },
              child: child,
            );
          },
          child: _buildPrinceCharacter(null),
        ),
      ),
    );
  }

  Widget _buildPrinceCharacter(Widget? child) {
    // Calculate animation values
    final idleValue = _idleAnimation.value;
    final walkValue = _walkAnimation.value;

    // Determine which animation is active
    final double yOffset = _currentState == PrinceState.walking
        ? walkValue *
              5.0 // Walking bob
        : idleValue * 2.0; // Idle breathing

    final double scale = 1.0 + (_currentState == PrinceState.magic ? 0.2 : 0.0);

    return Transform.translate(
      offset: Offset(0, yOffset),
      child: Transform.scale(
        scale: scale,
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Prince silhouette
            CustomPaint(
              painter: _PrincePainter(_currentState),
              child: const SizedBox.expand(),
            ),

            // Magic lamp glow effect
            if (_currentState == PrinceState.magic)
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    gradient: RadialGradient(
                      colors: [
                        const Color(
                          0xFFD4AF37,
                        ).withValues(alpha: 0.3), // Persian gold
                        const Color(
                          0xFFF78C4C,
                        ).withValues(alpha: 0.2), // Sunset orange
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
              ),

            // Child widget (if provided)
            ?child,
          ],
        ),
      ),
    );
  }
}

/// Persian Prince character states
enum PrinceState { idle, walking, magic }

/// Custom painter for Persian Prince character
class _PrincePainter extends CustomPainter {
  _PrincePainter(this.state);

  final PrinceState state;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color =
          const Color(0xFF8B4513) // Camel brown for Prince silhouette
      ..style = PaintingStyle.fill
      ..strokeWidth = 2.0;

    final centerX = size.width / 2;
    final centerY = size.height / 2;

    // Draw Prince silhouette based on state
    final path = Path();

    switch (state) {
      case PrinceState.idle:
        // Standing Prince with turban
        _drawIdlePrince(canvas, path, centerX, centerY);
        break;

      case PrinceState.walking:
        // Walking Prince with animated legs
        _drawWalkingPrince(canvas, path, centerX, centerY);
        break;

      case PrinceState.magic:
        // Magic Prince with glowing lamp
        _drawMagicPrince(canvas, path, centerX, centerY);
        break;
    }

    canvas.drawPath(path, paint);
  }

  void _drawIdlePrince(
    Canvas canvas,
    Path path,
    double centerX,
    double centerY,
  ) {
    // Body
    final bodyY = centerY - 10;
    const bodyHeight = 40.0;
    path.addRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(
          center: Offset(centerX, bodyY),
          width: 30,
          height: bodyHeight,
        ),
        const Radius.circular(4),
      ),
    );

    // Head with turban
    final headY = bodyY - 25;
    const headSize = 20.0;
    path.addOval(
      Rect.fromCenter(
        center: Offset(centerX, headY),
        width: headSize,
        height: headSize,
      ),
    );

    // Turban
    final turbanY = headY - 15;
    const turbanWidth = 25.0;
    const turbanHeight = 15.0;
    path.addRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(
          center: Offset(centerX, turbanY),
          width: turbanWidth,
          height: turbanHeight,
        ),
        const Radius.circular(6),
      ),
    );
  }

  void _drawWalkingPrince(
    Canvas canvas,
    Path path,
    double centerX,
    double centerY,
  ) {
    // Body with walking animation
    final bodyY = centerY - 10;
    const bodyHeight = 40.0;
    path.addRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(
          center: Offset(centerX, bodyY),
          width: 30,
          height: bodyHeight,
        ),
        const Radius.circular(4),
      ),
    );

    // Walking legs (animated)
    const legOffset = 10.0;
    for (int i = 0; i < 2; i++) {
      final legX = centerX + (i == 0 ? -legOffset : legOffset);
      final legY = bodyY + bodyHeight / 2;
      const legHeight = 20.0;

      path.addRRect(
        RRect.fromRectAndRadius(
          Rect.fromCenter(
            center: Offset(legX, legY),
            width: 8,
            height: legHeight,
          ),
          const Radius.circular(3),
        ),
      );
    }
  }

  void _drawMagicPrince(
    Canvas canvas,
    Path path,
    double centerX,
    double centerY,
  ) {
    // Body with magic pose
    final bodyY = centerY - 10;
    const bodyHeight = 40.0;
    path.addRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(
          center: Offset(centerX, bodyY),
          width: 30,
          height: bodyHeight,
        ),
        const Radius.circular(4),
      ),
    );

    // Head looking up with magic lamp
    final headY = bodyY - 25;
    const headSize = 20.0;
    path.addOval(
      Rect.fromCenter(
        center: Offset(centerX, headY),
        width: headSize,
        height: headSize,
      ),
    );

    // Magic lamp above head
    final lampY = headY - 35;
    const lampSize = 15.0;
    path.addOval(
      Rect.fromCenter(
        center: Offset(centerX, lampY),
        width: lampSize,
        height: lampSize,
      ),
    );

    // Magic glow effect
    final glowPaint = Paint()
      ..color = const Color(0xFFD4AF37)
          .withValues(alpha: 0.3) // Persian gold glow
      ..style = PaintingStyle.fill
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 10);

    canvas.drawCircle(Offset(centerX, lampY), lampSize * 2, glowPaint);
  }

  @override
  bool shouldRepaint(covariant _PrincePainter oldDelegate) =>
      state != oldDelegate.state;
}
