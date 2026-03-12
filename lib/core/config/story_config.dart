import 'package:flutter/material.dart';
import 'package:flutter/animation.dart';

/// Story configuration model for narrative sections and places
class StoryConfig {
  const StoryConfig({
    required this.chapters,
    required this.places,
    this.persianTheme = const PersianTheme(),
  });

  final List<StoryChapter> chapters;
  final List<StoryPlace> places;
  final PersianTheme persianTheme;
}

/// Individual story chapter/section
class StoryChapter {
  const StoryChapter({
    required this.key,
    required this.title,
    required this.subtitle,
    required this.storyLine,
    this.animationTriggers = const [],
    this.persianElement = '',
    this.ambientSound,
  });

  final String key;
  final String title;
  final String subtitle;
  final String storyLine;
  final List<AnimationTrigger> animationTriggers;
  final String persianElement; // 'prince', 'caravan', 'oasis', 'palace', etc.
  final String? ambientSound; // Path to ambient sound file
}

/// Story place for journey/progress indicators
class StoryPlace {
  const StoryPlace({
    required this.name,
    required this.description,
    required this.position,
    this.transitionEffects = const [],
    this.persianLandmark = '',
  });

  final String name;
  final String description;
  final double position;
  final List<String> transitionEffects;
  final String persianLandmark; // 'oasis', 'caravan_stop', 'palace_gate', etc.
}

/// Persian theme configuration for colors and motifs
class PersianTheme {
  const PersianTheme({
    this.primaryGold = const Color(0xFFD4AF37),
    this.desertSand = const Color(0xFFF0D8B2),
    this.sunsetOrange = const Color(0xFFF78C4C),
    this.nightSky = const Color(0xFF0D0D26),
    this.oasisBlue = const Color(0xFF308BAD),
    this.palmGreen = const Color(0xFF228B22),
  });

  final Color primaryGold;
  final Color desertSand;
  final Color sunsetOrange;
  final Color nightSky;
  final Color oasisBlue;
  final Color palmGreen;
}

/// Animation trigger for story chapters
class AnimationTrigger {
  const AnimationTrigger({
    required this.type,
    required this.target,
    this.delay = Duration.zero,
    this.duration,
    this.curve,
  });

  final AnimationType type;
  final String target;
  final Duration delay;
  final Duration? duration;
  final Curve? curve;
}

/// Types of animations in the Persian Prince story
enum AnimationType {
  sandReveal,
  magicCarpet,
  princeWalk,
  caravanMove,
  oasisShimmer,
  palaceRise,
  starTwinkle,
  sunsetGlow,
}

extension StoryConfigExtensions on StoryConfig {
  /// Get chapter by section key
  StoryChapter? chapterBySectionKey(String key) {
    try {
      return chapters.firstWhere((chapter) => chapter.key == key);
    } catch (e) {
      return null;
    }
  }
}
