import 'package:flutter/material.dart';
import 'package:portoflio/shared/widgets/scroll_reveal.dart';

/// Experience timeline with:
/// - Animated connector that draws itself on scroll
/// - Cards slide in from alternating left/right
/// - Glassmorphism containers with gold accents
/// - ScrollReveal stagger per entry
class ExperienceScreen extends StatelessWidget {
  const ExperienceScreen({super.key});

  static const List<Map<String, dynamic>> _experiences = [
    {
      'company': 'Tech Innovations Inc.',
      'role': 'Senior Flutter Developer & Team Lead',
      'period': '2023 – Present',
      'location': 'Remote',
      'highlights': [
        'Led a team of 8 developers building a financial services app',
        'Architected the app using Clean Architecture with BLoC pattern',
        'Reduced app startup time by 40% through shader warm-up and deferred loading',
        'Introduced Golden Testing with 95% visual regression coverage',
      ],
    },
    {
      'company': 'Digital Solutions Ltd.',
      'role': 'Flutter Developer',
      'period': '2021 – 2023',
      'location': 'Cairo, Egypt',
      'highlights': [
        'Built 5+ production Flutter apps from scratch',
        'Implemented real-time features using WebSocket and Firebase',
        'Maintained CI/CD pipelines with GitHub Actions and Fastlane',
      ],
    },
    {
      'company': 'StartUp Studio',
      'role': 'Mobile Developer',
      'period': '2020 – 2021',
      'location': 'Alexandria, Egypt',
      'highlights': [
        'Transitioned the team from native Android to Flutter',
        'Built custom UI components and animation systems',
        'Integrated REST APIs and local storage with Hive',
      ],
    },
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final screenWidth = MediaQuery.sizeOf(context).width;
    final isDesktop = screenWidth >= 1200;

    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(
        horizontal: isDesktop ? 100 : 24,
        vertical: 80,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const ScrollReveal(
            child: Center(
              child: Column(
                children: [
                  Text(
                    'Experience',
                    style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 12),
                  _ExperienceDivider(),
                ],
              ),
            ),
          ),
          const SizedBox(height: 50),
          ...List.generate(_experiences.length, (index) {
            final exp = _experiences[index];
            return ScrollReveal(
              delay: Duration(milliseconds: index * 150),
              direction: index.isEven
                  ? RevealDirection.fromLeft
                  : RevealDirection.fromRight,
              offset: 80,
              child: _GlassTimelineEntry(
                index: index,
                isLast: index == _experiences.length - 1,
                company: exp['company'] as String,
                role: exp['role'] as String,
                period: exp['period'] as String,
                location: exp['location'] as String,
                highlights: exp['highlights'] as List<String>,
                theme: theme,
              ),
            );
          }),
        ],
      ),
    );
  }
}

class _ExperienceDivider extends StatelessWidget {
  const _ExperienceDivider();
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      width: 60,
      height: 3,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [theme.colorScheme.primary, theme.colorScheme.tertiary],
        ),
        borderRadius: BorderRadius.circular(2),
      ),
    );
  }
}

class _GlassTimelineEntry extends StatefulWidget {
  const _GlassTimelineEntry({
    required this.index,
    required this.isLast,
    required this.company,
    required this.role,
    required this.period,
    required this.location,
    required this.highlights,
    required this.theme,
  });

  final int index;
  final bool isLast;
  final String company;
  final String role;
  final String period;
  final String location;
  final List<String> highlights;
  final ThemeData theme;

  @override
  State<_GlassTimelineEntry> createState() => _GlassTimelineEntryState();
}

class _GlassTimelineEntryState extends State<_GlassTimelineEntry> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Timeline connector
          SizedBox(
            width: 40,
            child: Column(
              children: [
                // Gold dot with glow
                Container(
                  width: 16,
                  height: 16,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      colors: [
                        widget.theme.colorScheme.primary,
                        widget.theme.colorScheme.tertiary,
                      ],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: widget.theme.colorScheme.primary.withValues(
                          alpha: 0.5,
                        ),
                        blurRadius: 12,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                ),
                if (!widget.isLast)
                  Expanded(
                    child: Container(
                      width: 2,
                      margin: const EdgeInsets.symmetric(vertical: 6),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            widget.theme.colorScheme.primary.withValues(
                              alpha: 0.5,
                            ),
                            widget.theme.colorScheme.primary.withValues(
                              alpha: 0.05,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(width: 20),
          // Glassmorphism card
          Expanded(
            child: MouseRegion(
              onEnter: (_) => setState(() => _isHovered = true),
              onExit: (_) => setState(() => _isHovered = false),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                margin: const EdgeInsets.only(bottom: 36),
                padding: const EdgeInsets.all(28),
                decoration: BoxDecoration(
                  color: widget.theme.colorScheme.surfaceContainerHigh
                      .withValues(alpha: _isHovered ? 0.4 : 0.25),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: _isHovered
                        ? widget.theme.colorScheme.primary.withValues(
                            alpha: 0.3,
                          )
                        : widget.theme.colorScheme.outline.withValues(
                            alpha: 0.08,
                          ),
                  ),
                  boxShadow: _isHovered
                      ? [
                          BoxShadow(
                            color: widget.theme.colorScheme.primary.withValues(
                              alpha: 0.08,
                            ),
                            blurRadius: 30,
                          ),
                        ]
                      : null,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.role,
                                style: widget.theme.textTheme.titleMedium
                                    ?.copyWith(
                                      fontWeight: FontWeight.w600,
                                      color: widget.theme.colorScheme.onSurface,
                                    ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                widget.company,
                                style: widget.theme.textTheme.bodyLarge
                                    ?.copyWith(
                                      color: widget.theme.colorScheme.primary,
                                      fontWeight: FontWeight.w500,
                                    ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 7,
                          ),
                          decoration: BoxDecoration(
                            color: widget.theme.colorScheme.primary.withValues(
                              alpha: 0.1,
                            ),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: widget.theme.colorScheme.primary
                                  .withValues(alpha: 0.2),
                            ),
                          ),
                          child: Text(
                            widget.period,
                            style: widget.theme.textTheme.bodySmall?.copyWith(
                              color: widget.theme.colorScheme.primary,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      '📍 ${widget.location}',
                      style: widget.theme.textTheme.bodySmall?.copyWith(
                        color: widget.theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: 18),
                    ...widget.highlights.map(
                      (h) => Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top: 6),
                              child: Container(
                                width: 6,
                                height: 6,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: widget.theme.colorScheme.primary
                                      .withValues(alpha: 0.6),
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                h,
                                style: widget.theme.textTheme.bodyMedium,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
