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
import 'package:portoflio/shared/widgets/sand_reveal_wrapper.dart';
import 'package:portoflio/shared/widgets/shader_background.dart';
import 'package:portoflio/theme/app_theme.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  final ScrollController _scrollController = ScrollController();
  late final ValueNotifier<double> _placeProgress;

  @override
  void initState() {
    super.initState();
    _placeProgress = ref.read(homePlaceProgressProvider);
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;
    final maxExtent = _scrollController.position.maxScrollExtent;
    if (maxExtent <= 0) return;
    final progress = (_scrollController.offset / maxExtent).clamp(0.0, 1.0);

    _placeProgress.value = progress * 4.0;
    ref.read(homeScrollProgressProvider).value = progress;
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
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

    final viewportHeight = MediaQuery.sizeOf(context).height;

    final sections = [
      ConstrainedBox(
        constraints: BoxConstraints(minHeight: viewportHeight),
        child: HeroSection(
          name: name,
          tagline: tagline,
          storyPreamble: heroChapter?.subtitle,
          storyLine: heroChapter?.storyLine,
        ),
      ),
      const SandRevealWrapper(child: SkillsetSection()),
      const SandRevealWrapper(child: CuratedPortfolioSection()),
      const SandRevealWrapper(child: ExperienceTeaserSection()),
      const SandRevealWrapper(child: AboutTeaserSection()),
      const Footer(),
    ];

    return Stack(
      children: [
        Positioned.fill(
          child: ShaderBackground(
            scrollController: _scrollController,
            placeProgress: _placeProgress,
            scrollProgress: ref.read(homeScrollProgressProvider),
          ),
        ),

        CustomScrollView(
          controller: _scrollController,
          physics: const BouncingScrollPhysics(),
          slivers: [
            SliverList(
              delegate: SliverChildListDelegate(sections),
            ),
          ],
        ),

        if (MediaQuery.sizeOf(context).width > 600)
          Positioned(
            right: 20,
            top: 0,
            bottom: 0,
            child: Center(
              child: RepaintBoundary(
                child: _StoryScrollIndicator(
                  controller: _scrollController,
                  placeProgress: _placeProgress,
                  story: story,
                ),
              ),
            ),
          ),

        FloatingBackToTop(
          onTap: () => _scrollController.animateTo(
            0,
            duration: const Duration(milliseconds: 800),
            curve: Curves.easeInOutCubic,
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

  final ScrollController controller;
  final ValueNotifier<double> placeProgress;
  final StoryConfig story;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ListenableBuilder(
      listenable: Listenable.merge([controller, placeProgress]),
      builder: (context, _) {
        double progress = 0;
        if (controller.hasClients &&
            controller.position.hasContentDimensions) {
          final maxExtent = controller.position.maxScrollExtent;
          if (maxExtent > 0) {
            progress = (controller.offset / maxExtent).clamp(0.0, 1.0);
          }
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
