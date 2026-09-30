import 'package:flutter/material.dart';
import 'package:dakika/theme/tokens.dart';
import 'package:dakika/l10n/app_localizations.dart';

/// About screen — app info, version, team.
class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final tokens = Theme.of(context).brightness == Brightness.dark
        ? darkTokens
        : lightTokens;
    final tr = context.tr;

    return Scaffold(
      appBar: AppBar(
        title: Text(tr('profile_about')),
      ),
      body: ListView(
        padding: const EdgeInsets.all(Space.md),
        children: [
          const SizedBox(height: Space.lg),

          // App icon
          Center(
            child: Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: tokens.accent.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(Radii.lg),
              ),
              child: Icon(
                Icons.article_rounded,
                size: 40,
                color: tokens.accent,
              ),
            ),
          ),
          const SizedBox(height: Space.md),

          // App name
          Center(
            child: Text(
              'DAKIKA',
              style: Theme.of(context).textTheme.displayLarge,
            ),
          ),
          Center(
            child: Text(
              '${tr('profile_version')} 0.1.0',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: tokens.inkSecondary,
                  ),
            ),
          ),
          const SizedBox(height: Space.lg),

          // Description
          Card(
            child: Padding(
              padding: const EdgeInsets.all(Space.md),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Our Mission',
                    style: Theme.of(context).textTheme.headlineLarge,
                  ),
                  const SizedBox(height: Space.sm),
                  Text(
                    'DAKIKA distills East African news into 60-second reads, '
                    'designed for busy professionals who want to stay informed '
                    'without spending hours scrolling.',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: Space.sm),

          // Features
          Card(
            child: Padding(
              padding: const EdgeInsets.all(Space.md),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'What We Do',
                    style: Theme.of(context).textTheme.headlineLarge,
                  ),
                  const SizedBox(height: Space.sm),
                  _FeatureItem(
                    icon: Icons.timer_outlined,
                    text: '60-second AI summaries',
                  ),
                  _FeatureItem(
                    icon: Icons.language,
                    text: 'Kinyarwanda, English & Swahili',
                  ),
                  _FeatureItem(
                    icon: Icons.phone_android,
                    text: 'Mobile money subscriptions',
                  ),
                  _FeatureItem(
                    icon: Icons.download_outlined,
                    text: 'Offline-first design',
                  ),
                  _FeatureItem(
                    icon: Icons.verified_outlined,
                    text: 'Source attribution on every story',
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: Space.sm),

          // Team
          Card(
            child: Padding(
              padding: const EdgeInsets.all(Space.md),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Team',
                    style: Theme.of(context).textTheme.headlineLarge,
                  ),
                  const SizedBox(height: Space.sm),
                  Text(
                    'DAKIKA is built by a small team of passionate '
                    'technologists and journalists based in Kigali, Rwanda.',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: Space.lg),

          // Contact
          Center(
            child: Text(
              'hello@onenews.rw',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: tokens.accent,
                  ),
            ),
          ),
          const SizedBox(height: Space.sm),
          Center(
            child: Text(
              'Kigali, Rwanda',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: tokens.inkSecondary,
                  ),
            ),
          ),
          const SizedBox(height: Space.lg),
        ],
      ),
    );
  }
}

class _FeatureItem extends StatelessWidget {
  final IconData icon;
  final String text;

  const _FeatureItem({
    required this.icon,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: Space.xs),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Theme.of(context).colorScheme.primary),
          const SizedBox(width: Space.sm),
          Text(
            text,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }
}
