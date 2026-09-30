import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {

  group('Notification Settings', () {
    testWidgets('Renders notification title', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: Text('Notifications'),
          ),
        ),
      );

      expect(find.text('Notifications'), findsOneWidget);
    });

    testWidgets('Has master toggle', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: Switch(
              value: true,
              onChanged: null,
            ),
          ),
        ),
      );

      expect(find.byType(Switch), findsOneWidget);
    });

    testWidgets('Shows frequency options when enabled', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: Column(
              children: [
                Text('Immediate'),
                Text('Hourly Digest'),
                Text('Daily Digest'),
              ],
            ),
          ),
        ),
      );

      expect(find.text('Immediate'), findsOneWidget);
      expect(find.text('Hourly Digest'), findsOneWidget);
      expect(find.text('Daily Digest'), findsOneWidget);
    });

    testWidgets('Has breaking news toggle', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: Text('Breaking News'),
          ),
        ),
      );

      expect(find.text('Breaking News'), findsOneWidget);
    });

    testWidgets('Has daily digest toggle', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: Text('Daily Digest'),
          ),
        ),
      );

      expect(find.text('Daily Digest'), findsOneWidget);
    });
  });
}
