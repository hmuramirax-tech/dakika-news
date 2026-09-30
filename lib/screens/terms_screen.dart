import 'package:flutter/material.dart';
import 'package:dakika/theme/tokens.dart';
import 'package:dakika/l10n/app_localizations.dart';

/// Terms & Privacy screen.
class TermsScreen extends StatelessWidget {
  const TermsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final tokens = Theme.of(context).brightness == Brightness.dark
        ? darkTokens
        : lightTokens;
    final tr = context.tr;

    return Scaffold(
      appBar: AppBar(
        title: Text(tr('profile_terms')),
      ),
      body: ListView(
        padding: const EdgeInsets.all(Space.md),
        children: [
          _Section(
            title: 'Terms of Service',
            content: [
              'By using DAKIKA, you agree to these terms. DAKIKA aggregates news from credible sources and provides AI-generated summaries for informational purposes only.',
              'We do not produce original journalism. All stories are attributed to their original sources.',
              'You may not use DAKIKA for any unlawful purpose or in any way that could harm the service or other users.',
            ],
          ),
          _Section(
            title: 'Subscription Terms',
            content: [
              'Premium subscriptions cost Rwf 300/month and auto-renew unless cancelled.',
              'You can cancel your subscription at any time in the app settings.',
              'Refunds are available within 7 days of purchase if you are unsatisfied.',
              'Failed payments will be retried after 24 hours. If payment fails after 72 hours, your subscription will be downgraded to Free tier.',
            ],
          ),
          _Section(
            title: 'Privacy Policy',
            content: [
              'We collect minimal data: phone number, reading history, and app usage analytics.',
              'Your phone number is encrypted at rest and never shared with third parties.',
              'Reading history is anonymized for analytics and retained for 90 days.',
              'You can opt out of analytics tracking at any time in Settings.',
              'You can request data deletion by contacting us. We will respond within 30 days.',
            ],
          ),
          _Section(
            title: 'Data Protection Compliance',
            content: [
              'DAKIKA complies with the Rwanda Data Protection Law (2021).',
              'We follow data minimization principles — only collecting what is necessary.',
              'All data is stored securely with encryption at rest and in transit.',
              'We do not sell your personal data to third parties.',
            ],
          ),
          _Section(
            title: 'Contact',
            content: [
              'For questions about these terms, contact us at:',
              'Email: legal@onenews.rw',
              'Address: Kigali, Rwanda',
            ],
          ),
          const SizedBox(height: Space.lg),
          Center(
            child: Text(
              'Last updated: September 2026',
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
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

class _Section extends StatelessWidget {
  final String title;
  final List<String> content;

  const _Section({
    required this.title,
    required this.content,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(Space.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: Theme.of(context).textTheme.headlineLarge,
            ),
            const SizedBox(height: Space.sm),
            ...content.map((text) => Padding(
                  padding: const EdgeInsets.only(bottom: Space.sm),
                  child: Text(
                    text,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                )),
          ],
        ),
      ),
    );
  }
}
