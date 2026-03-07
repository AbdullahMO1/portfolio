import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:portoflio/core/config/story_config.dart';
import 'package:portoflio/core/providers/place_progress_provider.dart';
import 'package:portoflio/core/providers/portfolio_provider.dart';
import 'package:portoflio/core/providers/story_config_provider.dart';
import 'package:portoflio/features/home/widgets/about_teaser_section.dart';
import 'package:portoflio/features/home/widgets/curated_portfolio_section.dart';
import 'package:portoflio/features/home/widgets/experience_teaser_section.dart';
import 'package:portoflio/features/home/widgets/footer.dart';
import 'package:portoflio/features/home/widgets/hero_section.dart';
import 'package:portoflio/features/home/widgets/skillset_section.dart';
import 'package:portoflio/shared/widgets/cinematic_video_background.dart';
import 'package:portoflio/shared/widgets/place_overlay.dart';
import 'package:portoflio/shared/widgets/sand_reveal_wrapper.dart';
import 'package:portoflio/theme/app_theme.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  final PageController _pageController = PageController();
  late final ValueNotifier<double> _placeProgress;

  @override
  void initState() {
    super.initState();
    _placeProgress = ref.read(homePlaceProgressProvider);
    _pageController.addListener(_onScroll);
  }

  void _onScroll() {
    if (!_pageController.hasClients) return;
    final page = _pageController.page ?? 0.0;
    const maxPage = 5.0; // Hero, Skills, Portfolio, Experience, About, Footer
    final progress = (page / maxPage).clamp(0.0, 1.0);

    // Smoothly map page to place progress (0 to 5.0)
    _placeProgress.value = progress * 5.0;
    ref.read(homeScrollProgressProvider).value = progress;
  }

  @override
  void dispose() {
    _pageController.removeListener(_onScroll);
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final asyncResume = ref.watch(portfolioDataProvider);
    final resume = asyncResume.value;
    final name = resume?.meta.name ?? 'Abdullah Mohammed';
    final tagline = resume?.meta.tagline ?? 'Senior Mobile & Flutter Engineer';
    final story = ref.watch(storyConfigProvider);
    final heroChapter = story.chapterBySectionKey('hero');

    final sections = [
      SizedBox.expand(
        child: HeroSection(
          name: name,
          tagline: tagline,
          storyPreamble: heroChapter?.subtitle,
          storyLine: heroChapter?.storyLine,
        ),
      ),
      const SizedBox.expand(child: SandRevealWrapper(child: SkillsetSection())),
      const SizedBox.expand(
        child: SandRevealWrapper(child: CuratedPortfolioSection()),
      ),
      const SizedBox.expand(
        child: SandRevealWrapper(child: ExperienceTeaserSection()),
      ),
      const SizedBox.expand(
        child: SandRevealWrapper(child: AboutTeaserSection()),
      ),
      const SizedBox.expand(child: Footer()),
    ];

    return Stack(
      children: [
        Positioned.fill(
          child: CinematicVideoBackground(
            opacity: 0.85,
            placeProgress: _placeProgress,
          ),
        ),
        Positioned.fill(child: PlaceOverlay(placeProgress: _placeProgress)),

        PageView(
          controller: _pageController,
          scrollDirection: Axis.vertical,
          children: sections.map((s) => s).toList(),
        ),

        // Scroll Progress Indicator (road/path style)
        if (MediaQuery.sizeOf(context).width > 600)
          Positioned(
            right: 20,
            top: 0,
            bottom: 0,
            child: Center(
              child: RepaintBoundary(
                child: _StoryScrollIndicator(
                  controller: _pageController,
                  placeProgress: _placeProgress,
                  story: story,
                ),
              ),
            ),
          ),

        FloatingBackToTop(
          onTap: () => _pageController.animateToPage(
            0,
            duration: const Duration(milliseconds: 1000),
            curve: Curves.easeInOutQuart,
          ),
        ),
      ],
    );
  }
}

class FloatingBackToTop extends StatelessWidget {
  const FloatingBackToTop({super.key, required this.onTap});
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    // Simplified for now, just a FAB or similar logic could go here
    return Positioned(
      right: 24,
      bottom: 24,
      child: FloatingActionButton.small(
        onPressed: onTap,
        backgroundColor: Theme.of(
          context,
        ).colorScheme.primary.withValues(alpha: 0.2),
        child: const Icon(Icons.arrow_upward),
      ),
    );
  }
}

class _StoryScrollIndicator extends StatelessWidget {
  const _StoryScrollIndicator({
    required this.controller,
    required this.placeProgress,
    required this.story,
  });

  final PageController controller;
  final ValueNotifier<double> placeProgress;
  final StoryConfig story;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ListenableBuilder(
      listenable: Listenable.merge([controller, placeProgress]),
      builder: (context, _) {
        double progress = 0;
        if (controller.hasClients) {
          final page = controller.page ?? 0.0;
          const maxPage =
              5.0; // Hero, Skills, Portfolio, Experience, About, Footer
          progress = (page / maxPage).clamp(0.0, 1.0);
        }
        if (progress.isNaN || progress.isInfinite) progress = 0;

        final places = story.places;

        return SizedBox(
          width: 40,
          height: 240,
          child: CustomPaint(
            painter: _RoadIndicatorPainter(
              progress: progress,
              placeProgress: placeProgress.value,
              places: places,
              trackColor: AppTheme.saffronLight.withValues(alpha: 0.2),
              fillColor: theme.colorScheme.primary,
              dotColor: AppTheme.saffronLight,
            ),
          ),
        );
      },
    );
  }
}

class _RoadIndicatorPainter extends CustomPainter {
  _RoadIndicatorPainter({
    required this.progress,
    required this.placeProgress,
    required this.places,
    required this.trackColor,
    required this.fillColor,
    required this.dotColor,
  });

  final double progress;
  final double placeProgress;
  final List<StoryPlace> places;
  final Color trackColor;
  final Color fillColor;
  final Color dotColor;

  @override
  void paint(Canvas canvas, Size size) {
    final centerX = size.width / 2;
    final trackHeight = size.height;

    // Track
    canvas.drawLine(
      Offset(centerX, 0),
      Offset(centerX, trackHeight),
      Paint()
        ..color = trackColor
        ..strokeWidth = 2,
    );

    // Filled portion
    canvas.drawLine(
      Offset(centerX, 0),
      Offset(centerX, trackHeight * progress),
      Paint()
        ..color = fillColor
        ..strokeWidth = 2,
    );

    // Place dots
    for (int i = 0; i < places.length; i++) {
      final y = (i / (places.length - 1)) * trackHeight;
      final isPast = progress >= (i / (places.length - 1));
      final isCurrent = (placeProgress - i).abs() < 0.5;

      final dotRadius = isCurrent ? 5.0 : 3.0;
      final paint = Paint()
        ..color = isPast ? fillColor : dotColor.withValues(alpha: 0.4)
        ..style = PaintingStyle.fill;

      canvas.drawCircle(Offset(centerX, y), dotRadius, paint);

      if (isCurrent) {
        canvas.drawCircle(
          Offset(centerX, y),
          dotRadius + 3,
          Paint()
            ..color = fillColor.withValues(alpha: 0.3)
            ..style = PaintingStyle.stroke
            ..strokeWidth = 1.5,
        );
      }
    }

    // Current position dot with glow
    final currentY = trackHeight * progress;
    canvas.drawCircle(
      Offset(centerX, currentY),
      6,
      Paint()
        ..color = fillColor.withValues(alpha: 0.2)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4),
    );
    canvas.drawCircle(Offset(centerX, currentY), 3, Paint()..color = fillColor);
  }

  @override
  bool shouldRepaint(covariant _RoadIndicatorPainter oldDelegate) =>
      progress != oldDelegate.progress ||
      placeProgress != oldDelegate.placeProgress;
}
