import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:portoflio/core/config/story_config.dart';
import 'package:portoflio/core/providers/story_config_provider.dart';

/// Controller for managing Persian Prince story animation timeline
class AnimationTimelineController extends ChangeNotifier {
  AnimationTimelineController(this.ref, this.vsync) {
    _initialize();
  }

  final Ref ref;
  final TickerProvider vsync;
  final Map<String, AnimationController> _controllers = {};
  final Map<String, CurvedAnimation> _curvedAnimations = {};
  Timer? _timelineTimer;
  double _currentProgress = 0.0;
  int _currentChapterIndex = 0;

  double get currentProgress => _currentProgress;
  int get currentChapterIndex => _currentChapterIndex;

  /// Initialize animation controllers for the Persian Prince story
  void _initialize() {
    final story = ref.read(storyConfigProvider);

    // Create controllers for each animation trigger in the story
    for (final chapter in story.chapters) {
      for (final trigger in chapter.animationTriggers) {
        _createControllerForTrigger(trigger);
      }
    }
  }

  /// Create animation controller for a specific trigger
  void _createControllerForTrigger(AnimationTrigger trigger) {
    final controller = AnimationController(
      duration: trigger.duration ?? const Duration(milliseconds: 1000),
      vsync: vsync,
    );

    final curvedAnimation = CurvedAnimation(parent: controller, curve: trigger.curve ?? Curves.easeOutCubic);

    _controllers[trigger.target] = controller;
    _curvedAnimations[trigger.target] = curvedAnimation;
  }

  /// Trigger animations for a specific chapter
  void triggerChapterAnimations(String chapterKey) {
    final story = ref.read(storyConfigProvider);
    final chapter = story.chapters.firstWhere(
      (ch) => ch.key == chapterKey,
      orElse: () => throw Exception('Chapter not found: $chapterKey'),
    );

    // Update current chapter index
    _currentChapterIndex = story.chapters.indexOf(chapter);

    // Trigger all animations for this chapter with delays
    for (final trigger in chapter.animationTriggers) {
      _triggerWithDelay(trigger);
    }
  }

  /// Trigger animation with specified delay
  void _triggerWithDelay(AnimationTrigger trigger) {
    Future.delayed(trigger.delay, () {
      if (!_controllers.containsKey(trigger.target)) return;

      final controller = _controllers[trigger.target]!;

      // Reset and start animation
      controller.reset();
      controller.forward();

      // Notify listeners of animation state change
      notifyListeners();
    });
  }

  /// Update timeline progress based on scroll
  void updateProgress(double progress) {
    _currentProgress = progress.clamp(0.0, 1.0);

    // Determine which chapter should be active based on progress
    final story = ref.read(storyConfigProvider);
    final chapterCount = story.chapters.length;
    final targetChapterIndex = (_currentProgress * chapterCount).floor().clamp(0, chapterCount - 1);

    if (targetChapterIndex != _currentChapterIndex) {
      triggerChapterAnimations(story.chapters[targetChapterIndex].key);
    }

    notifyListeners();
  }

  /// Get animation value for a specific target
  double getAnimationValue(String target) {
    final animation = _curvedAnimations[target];
    return animation?.value ?? 0.0;
  }

  /// Check if animation is running for a target
  bool isAnimationRunning(String target) {
    final controller = _controllers[target];
    return controller?.isAnimating ?? false;
  }

  /// Reset all animations
  void resetAllAnimations() {
    for (final controller in _controllers.values) {
      controller.reset();
    }
    _currentProgress = 0.0;
    _currentChapterIndex = 0;
    notifyListeners();
  }

  /// Play Persian Prince entrance animation
  void playPrinceEntrance() {
    triggerChapterAnimations('hero');
  }

  /// Play magic carpet animation for skills section
  void playMagicCarpet() {
    triggerChapterAnimations('skills');
  }

  /// Play caravan animation for portfolio section
  void playCaravanJourney() {
    triggerChapterAnimations('portfolio');
  }

  /// Play oasis shimmer for experience section
  void playOasisShimmer() {
    triggerChapterAnimations('experience');
  }

  /// Play palace rise animation for about section
  void playPalaceRise() {
    triggerChapterAnimations('about');
  }

  @override
  void dispose() {
    _timelineTimer?.cancel();
    for (final controller in _controllers.values) {
      controller.dispose();
    }
    for (final animation in _curvedAnimations.values) {
      animation.dispose();
    }
    super.dispose();
  }
}

/// Provider for the animation timeline controller
final animationTimelineProvider = Provider<AnimationTimelineController>((ref) {
  // Note: This needs to be created with a vsync from the widget
  throw UnimplementedError('AnimationTimelineController requires vsync parameter - create manually in widget');
});

/// Utility class for Persian Prince animation effects
class PersianAnimationEffects {
  /// Sand reveal animation configuration
  static AnimationTrigger sandReveal({required String target, Duration? delay, Duration? duration}) {
    return AnimationTrigger(
      type: AnimationType.sandReveal,
      target: target,
      delay: delay ?? Duration.zero,
      duration: duration ?? const Duration(milliseconds: 800),
      curve: Curves.easeOutCubic,
    );
  }

  /// Magic carpet animation configuration
  static AnimationTrigger magicCarpet({required String target, Duration? delay, Duration? duration}) {
    return AnimationTrigger(
      type: AnimationType.magicCarpet,
      target: target,
      delay: delay ?? Duration.zero,
      duration: duration ?? const Duration(milliseconds: 1500),
      curve: Curves.easeInOutCubic,
    );
  }

  /// Prince walk animation configuration
  static AnimationTrigger princeWalk({required String target, Duration? delay, Duration? duration}) {
    return AnimationTrigger(
      type: AnimationType.princeWalk,
      target: target,
      delay: delay ?? Duration.zero,
      duration: duration ?? const Duration(milliseconds: 2000),
      curve: Curves.easeInOut,
    );
  }

  /// Oasis shimmer animation configuration
  static AnimationTrigger oasisShimmer({required String target, Duration? delay, Duration? duration}) {
    return AnimationTrigger(
      type: AnimationType.oasisShimmer,
      target: target,
      delay: delay ?? Duration.zero,
      duration: duration ?? const Duration(milliseconds: 1200),
      curve: Curves.easeOutBack,
    );
  }

  /// Sunset glow animation configuration
  static AnimationTrigger sunsetGlow({required String target, Duration? delay, Duration? duration}) {
    return AnimationTrigger(
      type: AnimationType.sunsetGlow,
      target: target,
      delay: delay ?? Duration.zero,
      duration: duration ?? const Duration(seconds: 2),
      curve: Curves.easeInOutSine,
    );
  }

  /// Palace rise animation configuration
  static AnimationTrigger palaceRise({required String target, Duration? delay, Duration? duration}) {
    return AnimationTrigger(
      type: AnimationType.palaceRise,
      target: target,
      delay: delay ?? Duration.zero,
      duration: duration ?? const Duration(milliseconds: 1800),
      curve: Curves.easeOutBack,
    );
  }
}
