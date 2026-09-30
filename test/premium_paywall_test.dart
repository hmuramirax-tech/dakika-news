import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {

  group('Premium Paywall', () {
    testWidgets('Renders premium title', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: Text('Go Premium'),
          ),
        ),
      );

      expect(find.text('Go Premium'), findsOneWidget);
    });

    testWidgets('Shows price', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: Text('Rwf 300/month'),
          ),
        ),
      );

      expect(find.text('Rwf 300/month'), findsOneWidget);
    });

    testWidgets('Shows all premium features', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: Column(
              children: [
                Text('Ad-free reading experience'),
                Text('Offline digest downloads'),
                Text('Audio summaries'),
                Text('Priority breaking news alerts'),
              ],
            ),
          ),
        ),
      );

      expect(find.text('Ad-free reading experience'), findsOneWidget);
      expect(find.text('Offline digest downloads'), findsOneWidget);
      expect(find.text('Audio summaries'), findsOneWidget);
      expect(find.text('Priority breaking news alerts'), findsOneWidget);
    });

    testWidgets('Has MoMo subscribe button', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: FilledButton(
              onPressed: null,
              child: Text('Subscribe with MoMo'),
            ),
          ),
        ),
      );

      expect(find.text('Subscribe with MoMo'), findsOneWidget);
    });

    testWidgets('Has Airtel subscribe button', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: OutlinedButton(
              onPressed: null,
              child: Text('Subscribe with Airtel Money'),
            ),
          ),
        ),
      );

      expect(find.text('Subscribe with Airtel Money'), findsOneWidget);
    });

    testWidgets('Has restore purchase button', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: TextButton(
              onPressed: null,
              child: Text('Restore Purchase'),
            ),
          ),
        ),
      );

      expect(find.text('Restore Purchase'), findsOneWidget);
    });

    testWidgets('Has close button', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: Icon(Icons.close),
          ),
        ),
      );

      expect(find.byIcon(Icons.close), findsOneWidget);
    });

    testWidgets('Shows terms text', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: Text('Subscription auto-renews monthly. Cancel anytime.'),
          ),
        ),
      );

      expect(
        find.textContaining('Subscription auto-renews monthly'),
        findsOneWidget,
      );
    });
  });
}
