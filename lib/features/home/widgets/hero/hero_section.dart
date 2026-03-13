import 'dart:async';

import 'package:flutter/material.dart';
import 'package:portoflio/features/home/widgets/hero/hero_content_column.dart';
import 'package:portoflio/features/home/widgets/hero/hero_pill_tag.dart';
import 'package:portoflio/features/home/widgets/hero/hero_portrait_card.dart';

/// Full-viewport hero: name, tagline (typewriter), portrait, CTAs.
/// Layout: desktop = row (content | portrait), mobile = column (pill, portrait, content).
class HeroSection extends StatefulWidget {
  const HeroSection({
    super.key,
    required this.name,
    required this.tagline,
    this.storyPreamble,
    this.storyLine,
  });

  final String name;
  final String tagline;
  final String? storyPreamble;
  final String? storyLine;

  @override
  State<HeroSection> createState() => _HeroSectionState();
}

class _HeroSectionState extends State<HeroSection>
    with TickerProviderStateMixin {
  late AnimationController _nameController;
  late AnimationController _taglineController;
  late AnimationController _ctaController;
  late AnimationController _underlineController;

  final ValueNotifier<String> _displayedTagline = ValueNotifier('');
  final ValueNotifier<bool> _showCursor = ValueNotifier(true);
  Timer? _typewriterTimer;
  Timer? _cursorTimer;
  int _charIndex = 0;

  static const _nameCurve = Cubic(0.16, 1, 0.3, 1);
  static const _typewriterCharMs = 22;
  static const _cursorBlinkMs = 400;

  @override
  void initState() {
    super.initState();
    _nameController = AnimationController(
      duration: const Duration(milliseconds: 350),
      vsync: this,
    );
    _taglineController = AnimationController(
      duration: const Duration(milliseconds: 250),
      vsync: this,
    );
    _ctaController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _underlineController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );

    _nameController.forward();
    final tagline = widget.tagline;
    Future.delayed(const Duration(milliseconds: 200), () {
      if (mounted) {
        _underlineController.forward();
        _startTypewriter(tagline);
      }
    });
    Future.delayed(Duration(milliseconds: 500 + tagline.length * 18), () {
      if (mounted) _taglineController.forward();
    });
    Future.delayed(Duration(milliseconds: 650 + tagline.length * 18), () {
      if (mounted) _ctaController.forward();
    });

    _cursorTimer = Timer.periodic(
      const Duration(milliseconds: _cursorBlinkMs),
      (timer) {
        if (!mounted) {
          timer.cancel();
          return;
        }
        _showCursor.value = !_showCursor.value;
      },
    );
  }

  @override
  void didUpdateWidget(covariant HeroSection oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.tagline != widget.tagline) {
      _typewriterTimer?.cancel();
      _charIndex = 0;
      _displayedTagline.value = '';
      _startTypewriter(widget.tagline);
    }
  }

  void _startTypewriter(String fullTagline) {
    _typewriterTimer?.cancel();
    _typewriterTimer = Timer.periodic(
      const Duration(milliseconds: _typewriterCharMs),
      (timer) {
        if (!mounted) {
          timer.cancel();
          return;
        }
        if (_charIndex < fullTagline.length) {
          _charIndex++;
          _displayedTagline.value = fullTagline.substring(0, _charIndex);
        } else {
          timer.cancel();
        }
      },
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _taglineController.dispose();
    _ctaController.dispose();
    _underlineController.dispose();
    _typewriterTimer?.cancel();
    _cursorTimer?.cancel();
    _displayedTagline.dispose();
    _showCursor.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final size = MediaQuery.sizeOf(context);
    final isDesktop = size.width >= 1200;
    final padding = _horizontalPadding(size.width);

    return ConstrainedBox(
      constraints: BoxConstraints(minHeight: size.height),
      child: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: padding,
            vertical: isDesktop ? 0 : 48,
          ),
          child: AnimatedBuilder(
            animation: Listenable.merge([
              _nameController,
              _taglineController,
              _ctaController,
              _underlineController,
              _displayedTagline,
              _showCursor,
            ]),
            builder: (context, _) {
              final nameValue = CurvedAnimation(
                parent: _nameController,
                curve: _nameCurve,
              ).value;
              final underlineValue = CurvedAnimation(
                parent: _underlineController,
                curve: Curves.easeOutExpo,
              ).value;

              if (isDesktop) {
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      flex: 7,
                      child: HeroContentColumn(
                        theme: theme,
                        isDesktop: true,
                        name: widget.name,
                        storyPreamble: widget.storyPreamble,
                        storyLine: widget.storyLine,
                        displayedTagline: _displayedTagline.value,
                        showCursor: _showCursor.value,
                        nameAnimationValue: nameValue,
                        underlineAnimationValue: underlineValue,
                        taglineAnimationValue: CurvedAnimation(
                          parent: _taglineController,
                          curve: Curves.easeOut,
                        ).value,
                        ctaAnimationValue: CurvedAnimation(
                          parent: _ctaController,
                          curve: Curves.elasticOut,
                        ).value,
                      ),
                    ),
                    const SizedBox(width: 48),
                    Expanded(
                      flex: 5,
                      child: HeroPortraitCard(
                        theme: theme,
                        nameAnimationValue: nameValue,
                      ),
                    ),
                  ],
                );
              }

              return Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  HeroPillTag(theme: theme, nameAnimationValue: nameValue),
                  const SizedBox(height: 24),
                  HeroPortraitCard(theme: theme, nameAnimationValue: nameValue),
                  const SizedBox(height: 24),
                  HeroContentColumn(
                    theme: theme,
                    isDesktop: false,
                    name: widget.name,
                    storyPreamble: widget.storyPreamble,
                    storyLine: widget.storyLine,
                    displayedTagline: _displayedTagline.value,
                    showCursor: _showCursor.value,
                    nameAnimationValue: nameValue,
                    underlineAnimationValue: underlineValue,
                    taglineAnimationValue: CurvedAnimation(
                      parent: _taglineController,
                      curve: Curves.easeOut,
                    ).value,
                    ctaAnimationValue: CurvedAnimation(
                      parent: _ctaController,
                      curve: Curves.elasticOut,
                    ).value,
                    showPill: false,
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  static double _horizontalPadding(double width) {
    if (width >= 1200) return 72;
    if (width >= 768) return 40;
    return 20;
  }
}
