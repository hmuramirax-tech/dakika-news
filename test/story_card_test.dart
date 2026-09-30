import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:dakika/components/story_card.dart';

void main() {
  group('StoryCard', () {
    testWidgets('renders headline, summary, source', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: StoryCard(
              headline: 'Test Headline',
              summary: 'Test summary content',
              source: 'The New Times',
              category: 'Business',
              publishedAt: '2h ago',
              readingTime: '1 min',
            ),
          ),
        ),
      );

      expect(find.text('Test Headline'), findsOneWidget);
      expect(find.text('Test summary content'), findsOneWidget);
      expect(find.text('The New Times'), findsOneWidget);
      expect(find.text('2h ago'), findsOneWidget);
      expect(find.text('1 min'), findsOneWidget);
    });

    testWidgets('renders category tag', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: StoryCard(
              headline: 'Test Headline',
              summary: 'Test summary content',
              source: 'The New Times',
              category: 'Sports',
              publishedAt: '2h ago',
              readingTime: '1 min',
            ),
          ),
        ),
      );

      expect(find.text('SPORTS'), findsOneWidget);
    });

    testWidgets('calls onTap when tapped', (tester) async {
      bool tapped = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: StoryCard(
              headline: 'Test Headline',
              summary: 'Test summary content',
              source: 'The New Times',
              category: 'Business',
              publishedAt: '2h ago',
              readingTime: '1 min',
              onTap: () => tapped = true,
            ),
          ),
        ),
      );

      await tester.tap(find.text('Test Headline'));
      expect(tapped, isTrue);
    });

    testWidgets('calls onSave when save button tapped', (tester) async {
      bool saved = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: StoryCard(
              headline: 'Test Headline',
              summary: 'Test summary content',
              source: 'The New Times',
              category: 'Business',
              publishedAt: '2h ago',
              readingTime: '1 min',
              onSave: () => saved = true,
            ),
          ),
        ),
      );

      await tester.tap(find.byIcon(Icons.bookmark_outline));
      expect(saved, isTrue);
    });

    testWidgets('calls onShare when share button tapped', (tester) async {
      bool shared = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: StoryCard(
              headline: 'Test Headline',
              summary: 'Test summary content',
              source: 'The New Times',
              category: 'Business',
              publishedAt: '2h ago',
              readingTime: '1 min',
              onShare: () => shared = true,
            ),
          ),
        ),
      );

      await tester.tap(find.byIcon(Icons.share_outlined));
      expect(shared, isTrue);
    });

    testWidgets('truncates long headline to 2 lines', (tester) async {
      final longHeadline = 'This is a very long headline that should be truncated to two lines because it exceeds the maximum allowed length for a story card headline';

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: StoryCard(
              headline: longHeadline,
              summary: 'Test summary',
              source: 'Source',
              category: 'General',
              publishedAt: '1h ago',
              readingTime: '1 min',
            ),
          ),
        ),
      );

      final headlineWidget = tester.widget<Text>(find.text(longHeadline));
      expect(headlineWidget.maxLines, 2);
      expect(headlineWidget.overflow, TextOverflow.ellipsis);
    });
  });
}
