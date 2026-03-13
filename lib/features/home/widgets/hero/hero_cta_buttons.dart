import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:portoflio/shared/widgets/magnetic_button.dart';
import 'package:url_launcher/url_launcher.dart';

/// Primary and secondary hero CTAs: Explore My Work, View Resume.
class HeroCtaButtons extends StatelessWidget {
  const HeroCtaButtons({
    super.key,
    required this.theme,
    required this.isDesktop,
    required this.ctaAnimationValue,
    this.resumeUrl =
        'https://drive.google.com/file/d/1P60t-1uPkw2bb6J-G8Y8POp6NM6A2X1M/view?usp=sharing',
  });

  final ThemeData theme;
  final bool isDesktop;
  final double ctaAnimationValue;
  final String resumeUrl;

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: ctaAnimationValue.clamp(0.0, 1.0),
      child: Transform.scale(
        scale: 0.5 + ctaAnimationValue * 0.5,
        child: Wrap(
          spacing: 16,
          runSpacing: 12,
          alignment: isDesktop ? WrapAlignment.start : WrapAlignment.center,
          children: [
            MagneticButton(
              onTap: () => context.go('/projects'),
              child: _buildPrimaryButton(context),
            ),
            MagneticButton(
              onTap: () => _openResume(context),
              child: _buildSecondaryButton(context),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPrimaryButton(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [theme.colorScheme.primary, theme.colorScheme.tertiary],
        ),
        borderRadius: BorderRadius.circular(999),
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.primary.withValues(alpha: 0.3),
            blurRadius: 30,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Explore My Work',
            style: theme.textTheme.labelLarge?.copyWith(
              color: theme.colorScheme.onPrimary,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(width: 8),
          Icon(
            Icons.arrow_forward_rounded,
            color: theme.colorScheme.onPrimary,
            size: 18,
          ),
        ],
      ),
    );
  }

  Widget _buildSecondaryButton(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface.withValues(alpha: 0.7),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(
          color: theme.colorScheme.primary.withValues(alpha: 0.2),
        ),
      ),
      child: Text(
        'View Resume',
        style: theme.textTheme.labelLarge?.copyWith(
          color: theme.colorScheme.onSurface,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }

  Future<void> _openResume(BuildContext context) async {
    final uri = Uri.parse(resumeUrl);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }
}
