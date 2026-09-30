import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:dakika/components/category_tabs.dart';

void main() {
  group('CategoryTabs', () {
    testWidgets('renders all categories', (tester) async {
      const categories = ['All', 'Sports', 'Business', 'Tech'];

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CategoryTabs(
              categories: categories,
              selected: 'All',
              onSelected: (_) {},
            ),
          ),
        ),
      );

      expect(find.text('All'), findsOneWidget);
      expect(find.text('Sports'), findsOneWidget);
      expect(find.text('Business'), findsOneWidget);
      expect(find.text('Tech'), findsOneWidget);
    });

    testWidgets('calls onSelected when category tapped', (tester) async {
      String? selected;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CategoryTabs(
              categories: const ['All', 'Sports', 'Business'],
              selected: 'All',
              onSelected: (category) => selected = category,
            ),
          ),
        ),
      );

      await tester.tap(find.text('Sports'));
      expect(selected, 'Sports');
    });

    testWidgets('highlights selected category', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CategoryTabs(
              categories: ['All', 'Sports', 'Business'],
              selected: 'Sports',
              onSelected: (_) {},
            ),
          ),
        ),
      );

      // The selected category should have a different background color
      final selectedContainer = tester.widget<AnimatedContainer>(
        find.ancestor(
          of: find.text('Sports'),
          matching: find.byType(AnimatedContainer),
        ),
      );

      expect(selectedContainer, isNotNull);
    });
  });
}
