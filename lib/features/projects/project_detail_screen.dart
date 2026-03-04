import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Project detail screen accessed via deep link `/projects/:id`.
class ProjectDetailScreen extends StatelessWidget {
  const ProjectDetailScreen({required this.projectId, super.key});

  final String projectId;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final screenWidth = MediaQuery.sizeOf(context).width;
    final isDesktop = screenWidth >= 1200;

    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(
        horizontal: isDesktop ? 120 : 24,
        vertical: 60,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Back button
          TextButton.icon(
            onPressed: () => context.go('/projects'),
            icon: const Icon(Icons.arrow_back_rounded),
            label: const Text('Back to Projects'),
          ),
          const SizedBox(height: 24),
          // Project hero placeholder
          Container(
            width: double.infinity,
            height: 300,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  theme.colorScheme.primaryContainer,
                  theme.colorScheme.tertiaryContainer,
                ],
              ),
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.rocket_launch_rounded,
                    size: 64,
                    color: theme.colorScheme.onPrimaryContainer,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    projectId
                        .replaceAll('-', ' ')
                        .split(' ')
                        .map(
                          (w) => w.isNotEmpty
                              ? '${w[0].toUpperCase()}${w.substring(1)}'
                              : '',
                        )
                        .join(' '),
                    style: theme.textTheme.headlineMedium?.copyWith(
                      color: theme.colorScheme.onPrimaryContainer,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 32),
          Text(
            'Project Overview',
            style: theme.textTheme.headlineSmall?.copyWith(
              color: theme.colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'This project demonstrates advanced Flutter engineering practices '
            'including clean architecture, state management, and CI/CD integration. '
            'The full details will be populated from the GitHub Gist resume data.',
            style: theme.textTheme.bodyLarge?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 32),
          Wrap(
            spacing: 12,
            children: [
              ElevatedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.code_rounded),
                label: const Text('View Source'),
              ),
              OutlinedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.open_in_new_rounded),
                label: const Text('Live Demo'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
