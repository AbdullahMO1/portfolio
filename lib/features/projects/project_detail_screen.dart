import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:portoflio/core/models/resume_model.dart';
import 'package:portoflio/core/providers/portfolio_provider.dart';
import 'package:portoflio/features/projects/widgets/store_button.dart';
import 'package:url_launcher/url_launcher.dart';

/// Project detail screen accessed via deep link `/projects/:id`.
/// Data comes from resume (Gist or local).
class ProjectDetailScreen extends ConsumerWidget {
  const ProjectDetailScreen({required this.projectId, super.key});

  final String projectId;

  static ProjectEntry? _findProject(ResumeModel resume, String id) {
    try {
      return resume.projects.firstWhere((p) => p.id == id);
    } catch (_) {
      return null;
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final screenWidth = MediaQuery.sizeOf(context).width;
    final isDesktop = screenWidth >= 1200;
    final asyncResume = ref.watch(portfolioDataProvider);

    return AsyncValueExtensions(asyncResume).when(
      loading: () => const Center(
        child: Padding(
          padding: EdgeInsets.all(48),
          child: CircularProgressIndicator(),
        ),
      ),
      error: (err, _) => Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Failed to load project: $err',
                style: theme.textTheme.bodyLarge,
              ),
              const SizedBox(height: 16),
              TextButton.icon(
                onPressed: () => context.go('/projects'),
                icon: const Icon(Icons.arrow_back_rounded),
                label: const Text('Back to Projects'),
              ),
            ],
          ),
        ),
      ),
      data: (resume) {
        final project = _findProject(resume, projectId);
        final title = project != null
            ? project.title
            : projectId
                  .replaceAll('-', ' ')
                  .split(' ')
                  .map(
                    (w) => w.isNotEmpty
                        ? '${w[0].toUpperCase()}${w.substring(1)}'
                        : '',
                  )
                  .join(' ');
        final description =
            project?.description ??
            'This project demonstrates advanced Flutter engineering practices '
                'including clean architecture, state management, and CI/CD integration.';
        final googlePlayUrl = project?.googlePlayUrl;
        final appStoreUrl = project?.appStoreUrl;
        final githubUrl = project?.github;
        final liveDemoUrl = project?.liveDemoUrl ?? project?.demo;
        final responsibilities = project?.responsibilities ?? const [];
        final hardestFeatures = project?.hardestFeatures ?? const [];

        return SingleChildScrollView(
          padding: EdgeInsets.symmetric(
            horizontal: isDesktop ? 120 : 24,
            vertical: 60,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextButton.icon(
                onPressed: () => context.go('/projects'),
                icon: const Icon(Icons.arrow_back_rounded),
                label: const Text('Back to Projects'),
              ),
              const SizedBox(height: 24),
              ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: SizedBox(
                  width: double.infinity,
                  height: 300,
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      if (project?.imageUrl != null &&
                          project!.imageUrl!.isNotEmpty)
                        Image.network(
                          project.imageUrl!,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => Container(
                            decoration: BoxDecoration(
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
                              child: Icon(
                                Icons.rocket_launch_rounded,
                                size: 64,
                                color: theme.colorScheme.onPrimaryContainer,
                              ),
                            ),
                          ),
                        )
                      else
                        Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                theme.colorScheme.primaryContainer,
                                theme.colorScheme.tertiaryContainer,
                              ],
                            ),
                          ),
                        ),
                      Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.transparent,
                              Colors.black.withValues(alpha: 0.7),
                            ],
                            stops: const [0.3, 1.0],
                          ),
                        ),
                      ),
                      Positioned(
                        left: 24,
                        bottom: 24,
                        right: 24,
                        child: Text(
                          title,
                          style: theme.textTheme.headlineMedium?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Wrap(
                spacing: 12,
                runSpacing: 12,
                children: [
                  if (googlePlayUrl != null)
                    StoreButton(
                      store: StoreType.googlePlay,
                      url: googlePlayUrl,
                    ),
                  if (appStoreUrl != null)
                    StoreButton(store: StoreType.appStore, url: appStoreUrl),
                  if (githubUrl != null)
                    ElevatedButton.icon(
                      onPressed: () => launchUrl(Uri.parse(githubUrl)),
                      icon: const Icon(Icons.code_rounded),
                      label: const Text('View Source'),
                    ),
                  if (liveDemoUrl != null)
                    OutlinedButton.icon(
                      onPressed: () => launchUrl(Uri.parse(liveDemoUrl)),
                      icon: const Icon(Icons.open_in_new_rounded),
                      label: const Text('Live Demo'),
                    ),
                ],
              ),
              const SizedBox(height: 32),
              _SectionHeader(theme: theme, title: 'Overview'),
              const SizedBox(height: 16),
              Text(
                description,
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
              if (responsibilities.isNotEmpty) ...[
                const SizedBox(height: 40),
                _SectionHeader(theme: theme, title: 'My Role'),
                const SizedBox(height: 16),
                ...responsibilities.map<Widget>(
                  (e) => Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 8, right: 10),
                          child: Container(
                            width: 6,
                            height: 6,
                            decoration: BoxDecoration(
                              color: theme.colorScheme.primary,
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                        Expanded(
                          child: Text(
                            e.toString(),
                            style: theme.textTheme.bodyLarge?.copyWith(
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
              if (hardestFeatures.isNotEmpty) ...[
                const SizedBox(height: 40),
                _SectionHeader(theme: theme, title: 'Key Challenges'),
                const SizedBox(height: 16),
                ...hardestFeatures.map<Widget>(
                  (e) => Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 8, right: 10),
                          child: Container(
                            width: 6,
                            height: 6,
                            decoration: BoxDecoration(
                              color: theme.colorScheme.primary,
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                        Expanded(
                          child: Text(
                            e.toString(),
                            style: theme.textTheme.bodyLarge?.copyWith(
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ],
          ),
        );
      },
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.theme, required this.title});

  final ThemeData theme;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: theme.textTheme.headlineSmall?.copyWith(
            color: theme.colorScheme.primary,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          width: 60,
          height: 3,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [theme.colorScheme.primary, theme.colorScheme.tertiary],
            ),
            borderRadius: BorderRadius.circular(2),
          ),
        ),
      ],
    );
  }
}
