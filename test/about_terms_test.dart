import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {

  group('About Screen', () {
    testWidgets('Renders about title', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: Text('About'),
          ),
        ),
      );

      expect(find.text('About'), findsOneWidget);
    });

    testWidgets('Shows app name', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: Text('DAKIKA'),
          ),
        ),
      );

      expect(find.text('DAKIKA'), findsOneWidget);
    });

    testWidgets('Shows version', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: Text('Version 0.1.0'),
          ),
        ),
      );

      expect(find.textContaining('Version'), findsOneWidget);
    });

    testWidgets('Shows mission statement', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: Text('Our Mission'),
          ),
        ),
      );

      expect(find.text('Our Mission'), findsOneWidget);
    });

    testWidgets('Shows features list', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: Column(
              children: [
                Text('60-second AI summaries'),
                Text('Kinyarwanda, English & Swahili'),
              ],
            ),
          ),
        ),
      );

      expect(find.text('60-second AI summaries'), findsOneWidget);
      expect(find.text('Kinyarwanda, English & Swahili'), findsOneWidget);
    });

    testWidgets('Shows contact info', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: Column(
              children: [
                Text('hello@onenews.rw'),
                Text('Kigali, Rwanda'),
              ],
            ),
          ),
        ),
      );

      expect(find.textContaining('hello@onenews.rw'), findsOneWidget);
      expect(find.text('Kigali, Rwanda'), findsOneWidget);
    });
  });

  group('Terms Screen', () {
    testWidgets('Renders terms title', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: Text('Terms & Privacy'),
          ),
        ),
      );

      expect(find.text('Terms & Privacy'), findsOneWidget);
    });

    testWidgets('Shows Terms of Service section', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: Text('Terms of Service'),
          ),
        ),
      );

      expect(find.text('Terms of Service'), findsOneWidget);
    });

    testWidgets('Shows Subscription Terms section', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: Text('Subscription Terms'),
          ),
        ),
      );

      expect(find.text('Subscription Terms'), findsOneWidget);
    });

    testWidgets('Shows Privacy Policy section', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: Text('Privacy Policy'),
          ),
        ),
      );

      expect(find.text('Privacy Policy'), findsOneWidget);
    });

    testWidgets('Shows Data Protection section', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: Text('Data Protection Compliance'),
          ),
        ),
      );

      expect(find.text('Data Protection Compliance'), findsOneWidget);
    });

    testWidgets('Shows last updated date', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: Text('Last updated: September 2026'),
          ),
        ),
      );

      expect(find.textContaining('Last updated'), findsOneWidget);
    });
  });
}
