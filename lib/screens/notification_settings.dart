import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dakika/theme/tokens.dart';
import 'package:dakika/l10n/app_localizations.dart';
import 'package:dakika/providers/providers.dart';

/// Notification settings — breaking news, daily digest, frequency.
class NotificationSettingsScreen extends ConsumerWidget {
  const NotificationSettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tokens = Theme.of(context).brightness == Brightness.dark
        ? darkTokens
        : lightTokens;
    final tr = context.tr;
    final prefs = ref.watch(userPreferencesProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(tr('profile_notifications')),
      ),
      body: ListView(
        padding: const EdgeInsets.all(Space.md),
        children: [
          // Master toggle
          Card(
            child: SwitchListTile(
              secondary: const Icon(Icons.notifications_active),
              title: Text(tr('profile_notifications')),
              subtitle: Text(tr('profile_notifications_sub')),
              value: prefs.notificationsEnabled,
              onChanged: (value) {
                ref.read(userPreferencesProvider.notifier).setNotifications(value);
              },
            ),
          ),
          const SizedBox(height: Space.sm),

          // Frequency settings
          if (prefs.notificationsEnabled) ...[
            Card(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(
                      Space.md, Space.md, Space.md, Space.sm,
                    ),
                    child: Text(
                      'Frequency',
                      style: Theme.of(context).textTheme.headlineLarge,
                    ),
                  ),
                  _FrequencyOption(
                    label: tr('notif_immediate'),
                    subtitle: 'Get notified as soon as news breaks',
                    value: 'immediate',
                    groupValue: 'immediate',
                    onChanged: (value) {
                      // TODO: Persist notification frequency
                    },
                  ),
                  _FrequencyOption(
                    label: tr('notif_hourly'),
                    subtitle: 'Get a digest every hour',
                    value: 'hourly',
                    groupValue: 'immediate',
                    onChanged: (value) {
                      // TODO: Persist notification frequency
                    },
                  ),
                  _FrequencyOption(
                    label: tr('notif_daily_digest'),
                    subtitle: 'Get a summary at 6:00 AM, 12:00 PM, 6:00 PM',
                    value: 'daily',
                    groupValue: 'immediate',
                    onChanged: (value) {
                      // TODO: Persist notification frequency
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: Space.sm),

            // Breaking news toggle
            Card(
              child: SwitchListTile(
                secondary: Icon(Icons.warning_amber, color: tokens.accentWarm),
                title: Text(tr('notif_breaking')),
                subtitle: const Text('Urgent news alerts (max 3 per day)'),
                value: true,
                onChanged: (value) {
                  // TODO: Persist breaking news preference
                },
              ),
            ),
            const SizedBox(height: Space.sm),

            // Daily digest toggle
            Card(
              child: SwitchListTile(
                secondary: Icon(Icons.today, color: tokens.accent),
                title: Text(tr('notif_daily')),
                subtitle: const Text('Morning, afternoon & evening digests'),
                value: true,
                onChanged: (value) {
                  // TODO: Persist daily digest preference
                },
              ),
            ),
          ],

          if (!prefs.notificationsEnabled)
            Card(
              child: Padding(
                padding: const EdgeInsets.all(Space.lg),
                child: Column(
                  children: [
                    Icon(
                      Icons.notifications_off_outlined,
                      size: 48,
                      color: tokens.inkSecondary,
                    ),
                    const SizedBox(height: Space.sm),
                    Text(
                      'Notifications are turned off',
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    Text(
                      'Turn on notifications to stay updated',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: tokens.inkSecondary,
                          ),
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

class _FrequencyOption extends StatelessWidget {
  final String label;
  final String subtitle;
  final String value;
  final String groupValue;
  final ValueChanged<String?> onChanged;

  const _FrequencyOption({
    required this.label,
    required this.subtitle,
    required this.value,
    required this.groupValue,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return RadioListTile<String>(
      title: Text(label),
      subtitle: Text(subtitle),
      value: value,
      groupValue: groupValue,
      onChanged: onChanged,
    );
  }
}
