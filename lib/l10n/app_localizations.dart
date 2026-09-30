import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dakika/l10n/translations.dart';
import 'package:dakika/providers/providers.dart';

/// Convenience accessor for translations.
/// Usage: `context.tr('nav_digest')`
extension AppLocalizationsExtension on BuildContext {
  AppStrings get tr {
    final language = ProviderScope.containerOf(this)
        .read(userPreferencesProvider)
        .language;
    final code = language == 'Kinyarwanda' ? 'rw' : 'en';
    return AppTranslations.of(code);
  }
}

/// Language picker bottom sheet.
void showLanguagePicker(BuildContext context) {
  final container = ProviderScope.containerOf(context);
  final currentLanguage = container.read(userPreferencesProvider).language;

  showModalBottomSheet(
    context: context,
    builder: (context) {
      return SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                'Select Language / Hitamo Ururimi',
                style: Theme.of(context).textTheme.headlineLarge,
              ),
            ),
            ...AppTranslations.supportedLanguages.map((lang) {
              final isSelected = currentLanguage == lang.nativeName;
              return ListTile(
                leading: CircleAvatar(
                  backgroundColor: isSelected
                      ? Theme.of(context).colorScheme.primary
                      : Theme.of(context).colorScheme.surface,
                  child: Text(
                    lang.code.toUpperCase(),
                    style: TextStyle(
                      color: isSelected
                          ? Colors.white
                          : Theme.of(context).colorScheme.onSurface,
                      fontWeight: FontWeight.w600,
                      fontSize: 12,
                    ),
                  ),
                ),
                title: Text(lang.nativeName),
                subtitle: Text(lang.name),
                trailing: isSelected
                    ? Icon(
                        Icons.check,
                        color: Theme.of(context).colorScheme.primary,
                      )
                    : null,
                onTap: () {
                  container
                      .read(userPreferencesProvider.notifier)
                      .setLanguage(lang.nativeName);
                  Navigator.pop(context);
                },
              );
            }),
            const SizedBox(height: 8),
          ],
        ),
      );
    },
  );
}
