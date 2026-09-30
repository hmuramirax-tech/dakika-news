import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dakika/theme/tokens.dart';
import 'package:dakika/l10n/app_localizations.dart';
import 'package:dakika/providers/providers.dart';
import 'package:dakika/screens/notification_settings.dart';
import 'package:dakika/screens/premium_paywall.dart';
import 'package:dakika/screens/about_screen.dart';
import 'package:dakika/screens/terms_screen.dart';

/// Settings screen — user preferences and app configuration.
class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tokens = Theme.of(context).brightness == Brightness.dark
        ? darkTokens
        : lightTokens;
    final tr = context.tr;
    final prefs = ref.watch(userPreferencesProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(tr('profile_title')),
      ),
      body: ListView(
        padding: const EdgeInsets.all(Space.md),
        children: [
          // User info
          Card(
            child: ListTile(
              leading: CircleAvatar(
                radius: 24,
                backgroundColor: tokens.accent,
                child: Text(
                  'U',
                  style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                        color: Colors.white,
                      ),
                ),
              ),
              title: Text(tr('profile_user')),
              subtitle: Text('+250 7XX XXX XXX'),
            ),
          ),
          const SizedBox(height: Space.sm),

          // Subscription
          Card(
            child: ListTile(
              leading: Icon(Icons.star, color: tokens.accentWarm),
              title: Text(tr('profile_free_tier')),
              subtitle: Text(tr('profile_upgrade_subtitle')),
              trailing: FilledButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const PremiumPaywallScreen(),
                    ),
                  );
                },
                child: Text(tr('profile_upgrade')),
              ),
            ),
          ),
          const SizedBox(height: Space.sm),

          // Preferences
          Card(
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.language),
                  title: Text(tr('profile_language')),
                  subtitle: Text(prefs.language),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => _showLanguagePicker(context, ref),
                ),
                Divider(height: 1, color: tokens.rule),
                ListTile(
                  leading: const Icon(Icons.notifications_outlined),
                  title: Text(tr('profile_notifications')),
                  subtitle: Text(tr('profile_notifications_sub')),
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
                SwitchListTile(
                  secondary: const Icon(Icons.data_saver_outlined),
                  title: Text(tr('profile_data_saver')),
                  subtitle: Text(tr('profile_data_saver_sub')),
                  value: prefs.dataSaver,
                  onChanged: (value) {
                    ref.read(userPreferencesProvider.notifier).setDataSaver(value);
                  },
                ),
                Divider(height: 1, color: tokens.rule),
                ListTile(
                  leading: const Icon(Icons.density_medium),
                  title: Text(tr('profile_display_density')),
                  subtitle: Text(prefs.displayDensity),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => _showDensityPicker(context, ref),
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
                  title: Text(tr('profile_about')),
                  subtitle: Text('${tr('profile_version')} 0.1.0'),
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
                  title: Text(tr('profile_terms')),
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
    );
  }

  void _showLanguagePicker(BuildContext context, WidgetRef ref) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: const Text('English'),
                trailing: ref.read(userPreferencesProvider).language == 'English'
                    ? const Icon(Icons.check)
                    : null,
                onTap: () {
                  ref.read(userPreferencesProvider.notifier).setLanguage('English');
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: const Text('Kinyarwanda'),
                trailing: ref.read(userPreferencesProvider).language == 'Kinyarwanda'
                    ? const Icon(Icons.check)
                    : null,
                onTap: () {
                  ref.read(userPreferencesProvider.notifier).setLanguage('Kinyarwanda');
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _showDensityPicker(BuildContext context, WidgetRef ref) {
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
                trailing: ref.read(userPreferencesProvider).displayDensity == 'Comfortable'
                    ? const Icon(Icons.check)
                    : null,
                onTap: () {
                  ref.read(userPreferencesProvider.notifier).setDisplayDensity('Comfortable');
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: const Text('Compact'),
                subtitle: const Text('Reduced spacing, smaller text'),
                trailing: ref.read(userPreferencesProvider).displayDensity == 'Compact'
                    ? const Icon(Icons.check)
                    : null,
                onTap: () {
                  ref.read(userPreferencesProvider.notifier).setDisplayDensity('Compact');
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
