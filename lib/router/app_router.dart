import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:portoflio/core/providers/place_progress_provider.dart';
import 'package:portoflio/features/about/about_screen.dart';
import 'package:portoflio/features/contact/contact_screen.dart';
import 'package:portoflio/features/experience/experience_screen.dart';
import 'package:portoflio/features/home/home_screen.dart';
import 'package:portoflio/features/projects/project_detail_screen.dart';
import 'package:portoflio/features/projects/projects_screen.dart';
import 'package:portoflio/features/skills/skills_screen.dart';
import 'package:portoflio/router/route_transitions.dart';
import 'package:portoflio/shared/widgets/app_shell.dart';

final appRouterProvider = Provider<GoRouter>((ref) {
  final placeNotifier = ref.read(homePlaceProgressProvider);
  return _createRouter(placeNotifier);
});

GoRouter _createRouter(ValueNotifier<double> placeNotifier) => GoRouter(
  initialLocation: '/',
  routes: [
    ShellRoute(
      builder: (context, state, child) {
        final location = state.uri.path;
        final index = _locationToIndex(location);
        final isHome = index == 0;
        final ref = ProviderScope.containerOf(context);
        final scrollProgress = ref.read(homeScrollProgressProvider);

        return AppShell(
          currentIndex: index,
          onDestinationSelected: (i) {
            context.go(_indexToLocation(i));
          },
          placeProgress: isHome ? placeNotifier : null,
          scrollProgress: isHome ? scrollProgress : null,
          child: child,
        );
      },
      routes: [
        GoRoute(
          path: '/',
          pageBuilder: (context, state) => FadeSlideTransitionPage(
            key: state.pageKey,
            child: const HomeScreen(),
          ),
        ),
        GoRoute(
          path: '/about',
          pageBuilder: (context, state) => FadeSlideTransitionPage(
            key: state.pageKey,
            child: const AboutScreen(),
          ),
        ),
        GoRoute(
          path: '/skills',
          pageBuilder: (context, state) => FadeSlideTransitionPage(
            key: state.pageKey,
            child: const SkillsScreen(),
          ),
        ),
        GoRoute(
          path: '/experience',
          pageBuilder: (context, state) => FadeSlideTransitionPage(
            key: state.pageKey,
            child: const ExperienceScreen(),
          ),
        ),
        GoRoute(
          path: '/projects',
          pageBuilder: (context, state) => FadeSlideTransitionPage(
            key: state.pageKey,
            child: const ProjectsScreen(),
          ),
          routes: [
            GoRoute(
              path: ':id',
              pageBuilder: (context, state) {
                final projectId = state.pathParameters['id']!;
                return HeroExpandTransitionPage(
                  key: state.pageKey,
                  child: ProjectDetailScreen(projectId: projectId),
                );
              },
            ),
          ],
        ),
        GoRoute(
          path: '/contact',
          pageBuilder: (context, state) => FadeSlideTransitionPage(
            key: state.pageKey,
            child: const ContactScreen(),
          ),
        ),
      ],
    ),
  ],
);

int _locationToIndex(String location) {
  if (location.startsWith('/projects')) return 4;
  return switch (location) {
    '/' => 0,
    '/about' => 1,
    '/skills' => 2,
    '/experience' => 3,
    '/contact' => 5,
    _ => 0,
  };
}

String _indexToLocation(int index) {
  return switch (index) {
    0 => '/',
    1 => '/about',
    2 => '/skills',
    3 => '/experience',
    4 => '/projects',
    5 => '/contact',
    _ => '/',
  };
}
