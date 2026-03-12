import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:portoflio/core/config/story_config.dart';

/// Provides story configuration for narrative sections and journey progress
final storyConfigProvider = Provider<StoryConfig>((ref) {
  // Persian Prince desert journey configuration
  return const StoryConfig(
    chapters: [
      StoryChapter(
        key: 'hero',
        title: 'The Desert Beginning',
        subtitle: 'Where the Persian Prince\'s journey starts',
        storyLine:
            'In the golden sands of time, every great story begins with a single step across the desert.',
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
        title: 'The Prince\'s Craft',
        subtitle: 'Ancient wisdom forged in modern code',
        storyLine:
            'Like the master craftsmen of Persia, the Prince wields digital tools with precision and artistry.',
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
        title: 'The Digital Caravans',
        subtitle: 'Projects that traverse the digital desert',
        storyLine:
            'Each creation is a caravan carrying treasures across the vast landscape of technology.',
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
        title: 'The Oasis Journey',
        subtitle: 'Professional oases in the desert of career',
        storyLine:
            'Through vast deserts of challenges, the Prince discovered oases of opportunity and growth.',
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
        title: 'The Prince\'s Legacy',
        subtitle: 'The complete story behind the digital monarch',
        storyLine:
            'Beyond the code and algorithms lies the heart of a Prince dedicated to creating digital wonders.',
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
        name: 'Desert Dawn',
        description: 'The journey begins at sunrise',
        position: 0.0,
        persianLandmark: 'starting_oasis',
      ),
      StoryPlace(
        name: 'Craftsmen\'s Bazaar',
        description: 'Where skills are honed and mastered',
        position: 1.0,
        persianLandmark: 'skills_market',
      ),
      StoryPlace(
        name: 'Caravan Crossroads',
        description: 'Projects embark on their digital journeys',
        position: 2.0,
        persianLandmark: 'project_crossroads',
      ),
      StoryPlace(
        name: 'Oasis of Experience',
        description: 'Professional growth and achievements',
        position: 3.0,
        persianLandmark: 'experience_oasis',
      ),
      StoryPlace(
        name: 'The Royal Palace',
        description: 'Legacy and future aspirations',
        position: 4.0,
        persianLandmark: 'legacy_palace',
      ),
    ],
  );
});
