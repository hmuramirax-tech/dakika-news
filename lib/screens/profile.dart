import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dakika/theme/tokens.dart';
import 'package:dakika/l10n/app_localizations.dart';
import 'package:dakika/l10n/translations.dart';
import 'package:dakika/providers/providers.dart';
import 'package:dakika/screens/referral_screen.dart';
import 'package:dakika/screens/admin_dashboard.dart';
import 'package:dakika/screens/premium_paywall.dart';
import 'package:dakika/screens/notification_settings.dart';
import 'package:dakika/screens/about_screen.dart';
import 'package:dakika/screens/terms_screen.dart';

/// Profile screen — user info, language, subscription, settings.
class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tokens = Theme.of(context).brightness == Brightness.dark
        ? darkTokens
        : lightTokens;

    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(Space.md),
          children: [
            Text(
              'Profile',
              style: Theme.of(context).textTheme.displayLarge,
            ),
            const SizedBox(height: Space.lg),

            // User info
            Row(
              children: [
                CircleAvatar(
                  radius: 32,
                  backgroundColor: tokens.accent,
                  child: Text(
                    'U',
                    style: Theme.of(context).textTheme.displayLarge?.copyWith(
                          color: Colors.white,
                          fontSize: 28,
                        ),
                  ),
                ),
                const SizedBox(width: Space.md),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'User',
                      style: Theme.of(context).textTheme.headlineLarge,
                    ),
                    Text(
                      '+250 7XX XXX XXX',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: tokens.inkSecondary,
                          ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: Space.lg),

            // Subscription tier
            Card(
              child: ListTile(
                leading: Icon(Icons.star, color: tokens.accentWarm),
                title: Text(context.tr('profile_free_tier')),
                subtitle: Text(context.tr('profile_upgrade_subtitle')),
                trailing: FilledButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const PremiumPaywallScreen(),
                      ),
                    );
                  },
                  child: Text(context.tr('profile_upgrade')),
                ),
              ),
            ),
            const SizedBox(height: Space.sm),

            // Settings
            Card(
              child: Column(
                children: [
                  ListTile(
                    leading: const Icon(Icons.language),
                    title: Text(context.tr('profile_language')),
                    subtitle: Text(ref.watch(userPreferencesProvider).language),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () => showLanguagePicker(context),
                  ),
                  Divider(height: 1, color: tokens.rule),
                  ListTile(
                    leading: const Icon(Icons.notifications_outlined),
                    title: Text(context.tr('profile_notifications')),
                    subtitle: Text(context.tr('profile_notifications_sub')),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const NotificationSettingsScreen(),
                        ),
                      );
                    },
                  ),
                  Divider(height: 1, color: tokens.rule),
                  ListTile(
                    leading: const Icon(Icons.save_outlined),
                    title: const Text('Data Saver'),
                    subtitle: const Text('Reduce image quality, limit prefetch'),
                    trailing: Switch(
                      value: false,
                      onChanged: (value) {
                        // TODO: Toggle data saver
                      },
                    ),
                  ),
                  Divider(height: 1, color: tokens.rule),
                  ListTile(
                    leading: const Icon(Icons.density_medium),
                    title: const Text('Display Density'),
                    subtitle: const Text('Comfortable'),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () {
                      _showDensityPicker(context);
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: Space.sm),

            // Referrals & Admin
            Card(
              child: Column(
                children: [
                  ListTile(
                    leading: const Icon(Icons.card_giftcard),
                    title: const Text('Referrals'),
                    subtitle: const Text('Invite friends, get Premium free'),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const ReferralScreen(),
                        ),
                      );
                    },
                  ),
                  Divider(height: 1, color: tokens.rule),
                  ListTile(
                    leading: const Icon(Icons.admin_panel_settings_outlined),
                    title: const Text('Admin Dashboard'),
                    subtitle: const Text('Content management & analytics'),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const AdminDashboardScreen(),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: Space.sm),

            // About
            Card(
              child: Column(
                children: [
                  ListTile(
                    leading: const Icon(Icons.info_outline),
                    title: Text(context.tr('profile_about')),
                    subtitle: Text('${context.tr('profile_version')} 0.1.0'),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const AboutScreen(),
                        ),
                      );
                    },
                  ),
                  Divider(height: 1, color: tokens.rule),
                  ListTile(
                    leading: const Icon(Icons.description_outlined),
                    title: Text(context.tr('profile_terms')),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const TermsScreen(),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showDensityPicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: const Text('Comfortable'),
                subtitle: const Text('Full spacing, larger text'),
                trailing: Icon(
                  Icons.check,
                  color: Theme.of(context).colorScheme.primary,
                ),
                onTap: () => Navigator.pop(context),
              ),
              ListTile(
                title: const Text('Compact'),
                subtitle: const Text('Reduced spacing, smaller text'),
                onTap: () => Navigator.pop(context),
              ),
            ],
          ),
        );
      },
    );
  }
}
