import 'package:flutter/material.dart';
import 'package:portoflio/features/home/widgets/about_teaser_section.dart';
import 'package:portoflio/features/home/widgets/curated_portfolio_section.dart';
import 'package:portoflio/features/home/widgets/footer.dart';
import 'package:portoflio/features/home/widgets/hero_section.dart';
import 'package:portoflio/features/home/widgets/skillset_section.dart';
import 'package:portoflio/features/home/widgets/floating_back_to_top.dart';
import 'package:portoflio/shared/widgets/three_d_scroll_wrapper.dart';

/// Home screen — full-page 3D scroll experience.
///
/// Features:
/// - Single-page vertical scroll
/// - 3D perspective transitions via [ThreeDScrollWrapper]
/// - Persistent interactive shader background
/// - Premium custom cursor
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Scrollable content with 3D transitions
        CustomScrollView(
          controller: _scrollController,
          slivers: [
            // Hero Section
            const SliverToBoxAdapter(
              child: RepaintBoundary(child: HeroSection()),
            ),

            // The Skillset (4 cards)
            const SliverToBoxAdapter(
              child: RepaintBoundary(
                child: ThreeDScrollWrapper(child: SkillsetSection()),
              ),
            ),

            // Curated Portfolio (2–3 featured projects)
            const SliverToBoxAdapter(
              child: RepaintBoundary(
                child: ThreeDScrollWrapper(child: CuratedPortfolioSection()),
              ),
            ),

            // About teaser
            const SliverToBoxAdapter(
              child: RepaintBoundary(
                child: ThreeDScrollWrapper(child: AboutTeaserSection()),
              ),
            ),

            // Footer (Contact CTA inside)
            SliverToBoxAdapter(
              child: Footer(scrollController: _scrollController),
            ),
          ],
        ),

        // 3. Scroll Progress Indicator (Right) — hidden on small screens to avoid clutter
        if (MediaQuery.sizeOf(context).width > 600)
          Positioned(
            right: 20,
            top: 0,
            bottom: 0,
            child: Center(
              child: RepaintBoundary(
                child: _ScrollProgressIndicator(controller: _scrollController),
              ),
            ),
          ),

        // 4. Floating Back to Top (Bottom Right)
        FloatingBackToTop(scrollController: _scrollController),
      ],
    );
  }
}

/// A vertical scroll progress indicator.
class _ScrollProgressIndicator extends StatelessWidget {
  const _ScrollProgressIndicator({required this.controller});
  final ScrollController controller;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return AnimatedBuilder(
      animation: controller,
      builder: (context, _) {
        double progress = 0;
        // Use positions.first to avoid issues with .position if Multiple ScrollPositions are attached
        if (controller.hasClients && controller.positions.isNotEmpty) {
          final pos = controller.positions.first;
          if (pos.hasContentDimensions && pos.maxScrollExtent > 0) {
            progress = (pos.pixels / pos.maxScrollExtent).clamp(0.0, 1.0);
          }
        }

        // Ensure progress is a valid number
        if (progress.isNaN || progress.isInfinite) progress = 0;

        return Container(
          width: 2,
          height: 200,
          decoration: BoxDecoration(
            color: theme.colorScheme.outline.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(1),
          ),
          child: Stack(
            children: [
              Align(
                alignment: Alignment.topCenter,
                child: Container(
                  width: 2,
                  height: 200 * progress,
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primary,
                    borderRadius: BorderRadius.circular(1),
                    boxShadow: [
                      BoxShadow(
                        color: theme.colorScheme.primary.withValues(alpha: 0.5),
                        blurRadius: 4,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
