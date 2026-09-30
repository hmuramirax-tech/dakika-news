import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dakika/theme/tokens.dart';
import 'package:dakika/l10n/app_localizations.dart';
import 'package:dakika/services/referral_service.dart';
import 'package:dakika/services/analytics_service.dart';

/// Referral screen — invite friends, track referrals, earn rewards.
class ReferralScreen extends ConsumerStatefulWidget {
  const ReferralScreen({super.key});

  @override
  ConsumerState<ReferralScreen> createState() => _ReferralScreenState();
}

class _ReferralScreenState extends ConsumerState<ReferralScreen> {
  final _referralService = ReferralService();
  final _analyticsService = AnalyticsService();

  Map<String, dynamic> _stats = {
    'total': 0,
    'completed': 0,
    'pending': 0,
    'rewards_given': 0,
  };
  String? _referralCode;
  String? _referralLink;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadReferralData();
  }

  Future<void> _loadReferralData() async {
    try {
      final stats = await _referralService.getReferralStats();
      final code = await _referralService.getMyReferralCode();

      setState(() {
        _stats = stats;
        _referralCode = code;
        _referralLink = 'https://onenews.app/ref/${code ?? ''}';
        _loading = false;
      });

      await _analyticsService.trackReferral(
        code: code ?? '',
        action: 'view',
      );
    } catch (e) {
      setState(() => _loading = false);
    }
  }

  Future<void> _shareReferral() async {
    await _analyticsService.trackReferral(
      code: _referralCode ?? '',
      action: 'share',
    );

    // TODO: Use share_plus to share the referral link
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Referral link: $_referralLink'),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  Future<void> _copyCode() async {
    // TODO: Copy to clipboard
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Referral code copied!'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final tokens = Theme.of(context).brightness == Brightness.dark
        ? darkTokens
        : lightTokens;
    final tr = context.tr;

    return Scaffold(
      appBar: AppBar(
        title: Text(tr('profile_referrals')),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.all(Space.md),
              children: [
                // Header
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(Space.lg),
                    child: Column(
                      children: [
                        Icon(
                          Icons.card_giftcard,
                          size: 48,
                          color: tokens.accent,
                        ),
                        const SizedBox(height: Space.md),
                        Text(
                          'Invite Friends, Earn Premium',
                          style: Theme.of(context).textTheme.headlineLarge,
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: Space.sm),
                        Text(
                          'Share your referral code. When friends sign up, you both get 1 month of Premium free.',
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                color: tokens.inkSecondary,
                              ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: Space.lg),

                // Referral code
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(Space.lg),
                    child: Column(
                      children: [
                        Text(
                          'Your Referral Code',
                          style: Theme.of(context).textTheme.labelMedium,
                        ),
                        const SizedBox(height: Space.sm),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: Space.lg,
                                vertical: Space.md,
                              ),
                              decoration: BoxDecoration(
                                color: tokens.accent.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(Radii.md),
                                border: Border.all(
                                  color: tokens.accent.withValues(alpha: 0.3),
                                ),
                              ),
                              child: Text(
                                _referralCode ?? '------',
                                style: Theme.of(context).textTheme.displayLarge?.copyWith(
                                      color: tokens.accent,
                                      letterSpacing: 0.1,
                                    ),
                              ),
                            ),
                            const SizedBox(width: Space.sm),
                            IconButton(
                              onPressed: _copyCode,
                              icon: const Icon(Icons.copy),
                              tooltip: 'Copy code',
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: Space.lg),

                // Stats
                Row(
                  children: [
                    Expanded(
                      child: _StatCard(
                        label: 'Total',
                        value: '${_stats['total'] ?? 0}',
                        icon: Icons.people,
                        color: Colors.blue,
                      ),
                    ),
                    const SizedBox(width: Space.sm),
                    Expanded(
                      child: _StatCard(
                        label: 'Completed',
                        value: '${_stats['completed'] ?? 0}',
                        icon: Icons.check_circle,
                        color: Colors.green,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: Space.sm),
                Row(
                  children: [
                    Expanded(
                      child: _StatCard(
                        label: 'Pending',
                        value: '${_stats['pending'] ?? 0}',
                        icon: Icons.hourglass_empty,
                        color: Colors.orange,
                      ),
                    ),
                    const SizedBox(width: Space.sm),
                    Expanded(
                      child: _StatCard(
                        label: 'Rewards',
                        value: '${_stats['rewards_given'] ?? 0}',
                        icon: Icons.star,
                        color: Colors.purple,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: Space.lg),

                // Share button
                SizedBox(
                  width: double.infinity,
                  child: FilledButton.icon(
                    onPressed: _shareReferral,
                    icon: const Icon(Icons.share),
                    label: const Text('Share Referral Link'),
                    style: FilledButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: Space.md),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(Radii.md),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: Space.md),

                // How it works
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(Space.md),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'How It Works',
                          style: Theme.of(context).textTheme.headlineLarge,
                        ),
                        const SizedBox(height: Space.sm),
                        _StepRow(
                          number: '1',
                          text: 'Share your referral code with friends',
                        ),
                        _StepRow(
                          number: '2',
                          text: 'They sign up with your code',
                        ),
                        _StepRow(
                          number: '3',
                          text: 'You both get 1 month Premium free',
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color color;

  const _StatCard({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(Space.md),
        child: Column(
          children: [
            Icon(icon, color: color, size: 24),
            const SizedBox(height: Space.xs),
            Text(
              value,
              style: Theme.of(context).textTheme.displayLarge?.copyWith(
                    fontSize: 20,
                  ),
            ),
            Text(
              label,
              style: Theme.of(context).textTheme.labelSmall,
            ),
          ],
        ),
      ),
    );
  }
}

class _StepRow extends StatelessWidget {
  final String number;
  final String text;

  const _StepRow({
    required this.number,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: Space.sm),
      child: Row(
        children: [
          CircleAvatar(
            radius: 14,
            backgroundColor: Theme.of(context).colorScheme.primary,
            child: Text(
              number,
              style: const TextStyle(color: Colors.white, fontSize: 12),
            ),
          ),
          const SizedBox(width: Space.md),
          Expanded(
            child: Text(
              text,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
        ],
      ),
    );
  }
}
