import 'package:flutter/material.dart';

/// Hero name with gradient underline. First word plain, rest with gradient.
class HeroNameBlock extends StatelessWidget {
  const HeroNameBlock({
    super.key,
    required this.name,
    required this.theme,
    required this.isDesktop,
    required this.nameAnimationValue,
    required this.underlineAnimationValue,
  });

  final String name;
  final ThemeData theme;
  final bool isDesktop;
  final double nameAnimationValue;
  final double underlineAnimationValue;

  static const double _underlineWidthDesktop = 300.0;
  static const double _underlineWidthMobile = 200.0;

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: nameAnimationValue.clamp(0.0, 1.0),
      child: Transform.translate(
        offset: Offset(0, 40 * (1 - nameAnimationValue)),
        child: Column(
          crossAxisAlignment: isDesktop
              ? CrossAxisAlignment.start
              : CrossAxisAlignment.center,
          children: [
            ..._buildNameParts(context),
            const SizedBox(height: 8),
            _buildUnderline(),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildNameParts(BuildContext context) {
    final screenWidth = MediaQuery.sizeOf(context).width;
    final parts = name.trim().split(RegExp(r'\s+'));
    final first = parts.isNotEmpty ? parts.first : '';
    final rest = parts.length > 1 ? parts.sublist(1).join(' ') : '';
    final double fontSize = isDesktop
        ? 80
        : screenWidth < 400
        ? 36
        : 48;

    return [
      if (first.isNotEmpty)
        FittedBox(
          fit: BoxFit.scaleDown,
          alignment: isDesktop ? Alignment.centerLeft : Alignment.center,
          child: Text(
            first,
            style: theme.textTheme.displayLarge?.copyWith(
              fontSize: fontSize,
              height: 1.0,
            ),
            textAlign: isDesktop ? TextAlign.start : TextAlign.center,
          ),
        ),
      if (rest.isNotEmpty)
        FittedBox(
          fit: BoxFit.scaleDown,
          alignment: isDesktop ? Alignment.centerLeft : Alignment.center,
          child: ShaderMask(
            shaderCallback: (bounds) => LinearGradient(
              colors: [
                theme.colorScheme.primary,
                theme.colorScheme.tertiary,
                theme.colorScheme.primary,
              ],
            ).createShader(bounds),
            child: Text(
              rest,
              style: theme.textTheme.displayLarge?.copyWith(
                fontSize: fontSize,
                height: 1.0,
                color: Colors.white,
              ),
              textAlign: isDesktop ? TextAlign.start : TextAlign.center,
            ),
          ),
        ),
    ];
  }

  Widget _buildUnderline() {
    final width =
        (isDesktop ? _underlineWidthDesktop : _underlineWidthMobile) *
        underlineAnimationValue;
    return Container(
      width: width,
      height: 3,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            theme.colorScheme.primary,
            theme.colorScheme.tertiary,
            theme.colorScheme.primary.withValues(alpha: 0.0),
          ],
        ),
        borderRadius: BorderRadius.circular(2),
      ),
    );
  }
}
