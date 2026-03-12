import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:portoflio/core/services/desert_audio_service.dart';

/// Magic carpet navigation widget for Persian Prince portfolio
class MagicCarpetNav extends ConsumerStatefulWidget {
  const MagicCarpetNav({
    super.key,
    required this.children,
    this.selected = 0,
    required this.onDestinationSelected,
  });

  final List<Widget> children;
  final int selected;
  final Function(int) onDestinationSelected;

  @override
  ConsumerState<MagicCarpetNav> createState() => _MagicCarpetNavState();
}

class _MagicCarpetNavState extends ConsumerState<MagicCarpetNav>
    with TickerProviderStateMixin {
  late AnimationController _floatController;
  late AnimationController _glowController;
  late Animation<double> _floatAnimation;
  late Animation<double> _glowAnimation;

  @override
  void initState() {
    super.initState();

    // Floating animation
    _floatController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );
    _floatAnimation = Tween<double>(begin: -5.0, end: 0.0).animate(
      CurvedAnimation(parent: _floatController, curve: Curves.easeInOutSine),
    );

    _floatController.repeat(reverse: true);

    // Glow animation
    _glowController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _glowAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _glowController, curve: Curves.easeInOutSine),
    );
  }

  @override
  void dispose() {
    _floatController.dispose();
    _glowController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            const Color(0xFFD4AF37).withValues(alpha: 0.1), // Persian gold
            const Color(0xFFF78C4C).withValues(alpha: 0.1), // Sunset orange
            const Color(0xFF8B4513).withValues(alpha: 0.1), // Camel brown
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFD4AF37).withValues(alpha: 0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          // Magic carpet header
          Container(
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFFD4AF37), Color(0xFFF78C4C)],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            child: Row(
              children: [
                // Magic lamp icon
                AnimatedBuilder(
                  animation: _glowController,
                  builder: (context, child) {
                    return Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: RadialGradient(
                          colors: [
                            const Color(0xFFF78C4C).withValues(alpha: 0.8),
                            const Color(0xFFD4AF37).withValues(alpha: 0.3),
                          ],
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(
                              0xFFD4AF37,
                            ).withValues(alpha: _glowAnimation.value * 0.5),
                            blurRadius: 15,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.auto_awesome,
                        color: Colors.white,
                        size: 24,
                      ),
                    );
                  },
                ),

                const SizedBox(width: 16),

                // Title
                const Expanded(
                  child: Text(
                    'Magic Carpet Navigation',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      shadows: [
                        Shadow(
                          color: Color(0xFF8B4513),
                          offset: Offset(0, 2),
                          blurRadius: 4,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Magic carpet body with navigation items
          Expanded(
            child: AnimatedBuilder(
              animation: _floatController,
              builder: (context, child) {
                return Transform.translate(
                  offset: Offset(0, _floatAnimation.value),
                  child: _buildMagicCarpet(
                    Row(
                      children: widget.children.asMap().entries.map((entry) {
                        final index = entry.key;
                        final isSelected = widget.selected == index;

                        return Expanded(
                          child: MouseRegion(
                            onEnter: (_) {},
                            onExit: (_) {},
                            child: _buildDestination(index, isSelected),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMagicCarpet(Widget? child) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            const Color(0xFFD4AF37).withValues(alpha: 0.2),
            const Color(0xFF8B4513).withValues(alpha: 0.3),
            const Color(0xFFD4AF37).withValues(alpha: 0.2),
          ],
        ),
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFD4AF37).withValues(alpha: 0.4),
            blurRadius: 30,
            offset: const Offset(0, 15),
          ),
        ],
      ),
      child: child ?? _buildCarpetPattern(),
    );
  }

  Widget _buildCarpetPattern() {
    return CustomPaint(
      painter: _CarpetPatternPainter(),
      child: const SizedBox.expand(),
    );
  }

  Widget _buildDestination(int index, bool isSelected) {
    final audioService = ref.read(desertAudioServiceProvider);

    return GestureDetector(
      onTap: () {
        widget.onDestinationSelected(index);

        // Play magic carpet sound
        audioService.playSoundEffect(DesertSound.magicCarpet);
      },
      child: AnimatedBuilder(
        animation: _glowController,
        builder: (context, child) {
          return Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: isSelected
                    ? [const Color(0xFFD4AF37), const Color(0xFFF78C4C)]
                    : [Colors.grey.shade400, Colors.grey.shade600],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(12),
              boxShadow: isSelected
                  ? [
                      BoxShadow(
                        color: const Color(0xFFD4AF37).withValues(alpha: 0.5),
                        blurRadius: 20,
                        offset: const Offset(0, 8),
                      ),
                    ]
                  : [],
            ),
            child: Column(
              children: [
                // Destination icon
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.9),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    _getDestinationIcon(index),
                    color: isSelected
                        ? const Color(0xFFD4AF37)
                        : Colors.grey.shade600,
                    size: 20,
                  ),
                ),

                const SizedBox(height: 4),

                // Destination name
                Expanded(
                  child: Text(
                    _getDestinationName(index),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: isSelected
                          ? const Color(0xFFD4AF37)
                          : Colors.grey.shade800,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  IconData _getDestinationIcon(int index) {
    switch (index) {
      case 0:
        return Icons.home; // Desert Beginning
      case 1:
        return Icons.construction; // Prince's Craft
      case 2:
        return Icons.workspaces_outline; // Digital Caravans
      case 3:
        return Icons.water_drop; // Oasis Journey
      case 4:
        return Icons.account_balance; // Prince's Legacy
      default:
        return Icons.star; // Horizon Beyond
    }
  }

  String _getDestinationName(int index) {
    switch (index) {
      case 0:
        return 'Desert Dawn';
      case 1:
        return 'Craftsmen\'s Bazaar';
      case 2:
        return 'Caravan Crossroads';
      case 3:
        return 'Oasis of Experience';
      case 4:
        return 'The Royal Palace';
      default:
        return 'Horizon Beyond';
    }
  }
}

/// Custom painter for magic carpet pattern
class _CarpetPatternPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFFD4AF37)
          .withValues(alpha: 0.1) // Persian gold pattern
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    // Draw Persian carpet pattern
    for (int i = 0; i < 8; i++) {
      for (int j = 0; j < 6; j++) {
        final x = (size.width / 8) * i + (size.width / 16);
        final y = (size.height / 6) * j + (size.height / 16);

        if ((i + j) % 2 == 0) {
          canvas.drawLine(
            Offset(x, y),
            Offset(x + size.width / 8, y + size.height / 8),
            paint,
          );
        }
      }
    }
  }

  @override
  bool shouldRepaint(covariant _CarpetPatternPainter oldDelegate) => true;
}
