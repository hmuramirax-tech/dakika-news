import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dakika/theme/tokens.dart';
import 'package:dakika/l10n/app_localizations.dart';
import 'package:dakika/providers/providers.dart';
import 'package:dakika/services/subscription_service.dart';

/// Premium Paywall — subscription screen for upgrading to Premium.
class PremiumPaywallScreen extends ConsumerWidget {
  const PremiumPaywallScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tokens = Theme.of(context).brightness == Brightness.dark
        ? darkTokens
        : lightTokens;
    final tr = context.tr;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(Space.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: Space.lg),

              // Close button
              Align(
                alignment: Alignment.centerRight,
                child: IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.pop(context),
                ),
              ),

              // Hero icon
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: tokens.accent.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.star_rounded,
                  size: 40,
                  color: tokens.accentWarm,
                ),
              ),
              const SizedBox(height: Space.md),

              // Title
              Text(
                tr('premium_title'),
                style: Theme.of(context).textTheme.displayLarge,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: Space.sm),

              // Subtitle
              Text(
                tr('premium_subtitle'),
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: tokens.inkSecondary,
                    ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: Space.lg),

              // Price
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: Space.lg,
                  vertical: Space.md,
                ),
                decoration: BoxDecoration(
                  color: tokens.accent.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(Radii.lg),
                  border: Border.all(
                    color: tokens.accent.withValues(alpha: 0.2),
                  ),
                ),
                child: Column(
                  children: [
                    Text(
                      tr('premium_price'),
                      style:
                          Theme.of(context).textTheme.headlineLarge?.copyWith(
                                color: tokens.accent,
                                fontWeight: FontWeight.w700,
                              ),
                    ),
                    Text(
                      '≈ \$0.20/month',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: tokens.inkSecondary,
                          ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: Space.lg),

              // Features
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(Space.md),
                  child: Column(
                    children: [
                      _FeatureRow(
                        icon: Icons.block_outlined,
                        text: tr('premium_feature_1'),
                        tokens: tokens,
                      ),
                      const Divider(),
                      _FeatureRow(
                        icon: Icons.download_outlined,
                        text: tr('premium_feature_2'),
                        tokens: tokens,
                      ),
                      const Divider(),
                      _FeatureRow(
                        icon: Icons.headphones_outlined,
                        text: tr('premium_feature_3'),
                        tokens: tokens,
                      ),
                      const Divider(),
                      _FeatureRow(
                        icon: Icons.notifications_active_outlined,
                        text: tr('premium_feature_4'),
                        tokens: tokens,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: Space.lg),

              // Subscribe buttons
              SizedBox(
                width: double.infinity,
                child: FilledButton.icon(
                  onPressed: () {
                    _initiatePayment(context, 'mtn');
                  },
                  icon: const Icon(Icons.phone_android),
                  label: Text(tr('premium_subscribe')),
                  style: FilledButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: Space.md),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(Radii.md),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: Space.sm),

              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: () {
                    _initiatePayment(context, 'airtel');
                  },
                  icon: const Icon(Icons.phone_android),
                  label: Text(tr('premium_subscribe_airtel')),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: Space.md),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(Radii.md),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: Space.md),

              // Restore
              TextButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Restoring purchases...'),
                      duration: Duration(seconds: 2),
                    ),
                  );
                },
                child: Text(tr('premium_restore')),
              ),
              const SizedBox(height: Space.sm),

              // Terms
              Text(
                tr('premium_terms'),
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: tokens.inkSecondary,
                    ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: Space.lg),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _initiatePayment(BuildContext context, String provider) async {
    final subscriptionService = SubscriptionService();

    // TODO: Get phone number from user profile or prompt
    final phoneNumber = '+250788123456';

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );

    final result = await subscriptionService.initiatePayment(
      provider: provider,
      phoneNumber: phoneNumber,
    );

    if (context.mounted) Navigator.pop(context);

    if (result.success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Payment initiated. Please check your phone.'),
          duration: const Duration(seconds: 3),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(result.errorMessage ?? 'Payment failed'),
          duration: const Duration(seconds: 3),
        ),
      );
    }
  }
}

class _FeatureRow extends StatelessWidget {
  final IconData icon;
  final String text;
  final AppTokens tokens;

  const _FeatureRow({
    required this.icon,
    required this.text,
    required this.tokens,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: Space.sm),
      child: Row(
        children: [
          Icon(icon, color: tokens.accent, size: 24),
          const SizedBox(width: Space.md),
          Expanded(
            child: Text(
              text,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ),
        ],
      ),
    );
  }
}
