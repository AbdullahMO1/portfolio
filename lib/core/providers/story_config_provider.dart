import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:portoflio/core/config/story_config.dart';

/// Provides story configuration for narrative sections and journey progress
final storyConfigProvider = Provider<StoryConfig>((ref) {
  return const StoryConfig(
    chapters: [
      StoryChapter(
        key: 'hero',
        title: 'From the Sands, a Builder',
        subtitle: 'Where curiosity meets craft',
        storyLine:
            'Some chase gold, others chase stars — I chase clean code and problems worth solving.',
        persianElement: 'prince',
        animationTriggers: [
          AnimationTrigger(
            type: AnimationType.sunsetGlow,
            target: 'background',
            duration: Duration(seconds: 2),
          ),
          AnimationTrigger(
            type: AnimationType.princeWalk,
            target: 'prince_character',
            delay: Duration(milliseconds: 500),
          ),
        ],
      ),
      StoryChapter(
        key: 'skills',
        title: 'Skills',
        subtitle: 'Sharp tools, steady hands',
        storyLine:
            'Knowing your tools is half the work. The other half is knowing when to put them down and think.',
        persianElement: 'craft',
        animationTriggers: [
          AnimationTrigger(
            type: AnimationType.magicCarpet,
            target: 'skills_carousel',
            duration: Duration(milliseconds: 1500),
          ),
          AnimationTrigger(
            type: AnimationType.sandReveal,
            target: 'skill_items',
          ),
        ],
      ),
      StoryChapter(
        key: 'portfolio',
        title: 'Projects',
        subtitle: 'Built, shipped, and learned from',
        storyLine:
            'You don\'t really understand a problem until you\'ve shipped a solution for it.',
        persianElement: 'caravan',
        animationTriggers: [
          AnimationTrigger(
            type: AnimationType.caravanMove,
            target: 'project_caravan',
            duration: Duration(seconds: 3),
          ),
          AnimationTrigger(
            type: AnimationType.oasisShimmer,
            target: 'project_oasis',
          ),
        ],
      ),
      StoryChapter(
        key: 'experience',
        title: 'Experience',
        subtitle: 'Where I\'ve grown, who I\'ve grown with',
        storyLine: 'The best lessons came from the teams, not the textbooks.',
        persianElement: 'oasis',
        animationTriggers: [
          AnimationTrigger(
            type: AnimationType.oasisShimmer,
            target: 'experience_oasis',
            duration: Duration(seconds: 2),
          ),
          AnimationTrigger(
            type: AnimationType.starTwinkle,
            target: 'achievement_stars',
          ),
        ],
      ),
      StoryChapter(
        key: 'about',
        title: 'About Me',
        subtitle: 'The short version',
        storyLine:
            'I care about the craft — clean code, honest work, and making things people actually enjoy using.',
        persianElement: 'palace',
        animationTriggers: [
          AnimationTrigger(
            type: AnimationType.palaceRise,
            target: 'about_palace',
            duration: Duration(seconds: 2),
          ),
          AnimationTrigger(
            type: AnimationType.sunsetGlow,
            target: 'legacy_glow',
          ),
        ],
      ),
    ],
    places: [
      StoryPlace(
        name: 'Home',
        description: 'Start here',
        position: 0.0,
        persianLandmark: 'starting_oasis',
      ),
      StoryPlace(
        name: 'Skills',
        description: 'What I work with',
        position: 1.0,
        persianLandmark: 'skills_market',
      ),
      StoryPlace(
        name: 'Projects',
        description: 'What I\'ve built',
        position: 2.0,
        persianLandmark: 'project_crossroads',
      ),
      StoryPlace(
        name: 'Experience',
        description: 'Where I\'ve been',
        position: 3.0,
        persianLandmark: 'experience_oasis',
      ),
      StoryPlace(
        name: 'About',
        description: 'Who I am',
        position: 4.0,
        persianLandmark: 'legacy_palace',
      ),
    ],
  );
});
