import 'package:go_router/go_router.dart';
import 'package:portoflio/features/about/about_screen.dart';
import 'package:portoflio/features/contact/contact_screen.dart';
import 'package:portoflio/features/experience/experience_screen.dart';
import 'package:portoflio/features/home/home_screen.dart';
import 'package:portoflio/features/projects/project_detail_screen.dart';
import 'package:portoflio/features/projects/projects_screen.dart';
import 'package:portoflio/features/skills/skills_screen.dart';
import 'package:portoflio/router/route_transitions.dart';
import 'package:portoflio/shared/widgets/app_shell.dart';

/// GoRouter configuration with ShellRoute for persistent navigation,
/// deep linking support, and custom page transitions.
final GoRouter appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    ShellRoute(
      builder: (context, state, child) {
        // Determine the current navigation index from the location
        final location = state.uri.path;
        final index = _locationToIndex(location);

        return AppShell(
          currentIndex: index,
          onDestinationSelected: (i) {
            context.go(_indexToLocation(i));
          },
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
