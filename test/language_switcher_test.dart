import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:dakika/l10n/translations.dart';
import 'package:dakika/providers/providers.dart';

void main() {

  group('Language Switching', () {
    testWidgets('Default language is English', (tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: _TestApp(),
        ),
      );

      final container = ProviderScope.containerOf(
        tester.element(find.byType(_TestApp)),
      );

      expect(container.read(userPreferencesProvider).language, 'English');
    });

    testWidgets('Can switch to Kinyarwanda', (tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: _TestApp(),
        ),
      );

      final container = ProviderScope.containerOf(
        tester.element(find.byType(_TestApp)),
      );

      container.read(userPreferencesProvider.notifier).setLanguage('Kinyarwanda');

      expect(container.read(userPreferencesProvider).language, 'Kinyarwanda');
    });

    testWidgets('Translations work for English', (tester) async {
      final translations = AppTranslations.of('en');
      expect(translations('nav_digest'), 'Digest');
      expect(translations('nav_explore'), 'Explore');
      expect(translations('profile_language'), 'Language');
    });

    testWidgets('Translations work for Kinyarwanda', (tester) async {
      final translations = AppTranslations.of('rw');
      expect(translations('nav_digest'), 'Urupapuro');
      expect(translations('nav_explore'), 'Shakisha');
      expect(translations('profile_language'), 'Ururimi');
    });

    testWidgets('Falls back to English for unknown language', (tester) async {
      final translations = AppTranslations.of('fr');
      expect(translations('nav_digest'), 'Digest');
    });

    testWidgets('Returns key for missing translation', (tester) async {
      final translations = AppTranslations.of('en');
      expect(translations('nonexistent_key'), 'nonexistent_key');
    });
  });
}

class _TestApp extends StatelessWidget {
  const _TestApp();

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Scaffold(
        body: Text('Test'),
      ),
    );
  }
}
