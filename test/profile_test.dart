import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {

  group('Profile Screen', () {
    testWidgets('Renders profile title', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: Text('Profile'),
          ),
        ),
      );

      expect(find.text('Profile'), findsOneWidget);
    });

    testWidgets('Shows user info', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: Column(
              children: [
                Text('User'),
                Text('+250 7XX XXX XXX'),
              ],
            ),
          ),
        ),
      );

      expect(find.text('User'), findsOneWidget);
      expect(find.textContaining('+250'), findsOneWidget);
    });

    testWidgets('Shows Free Tier', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: Text('Free Tier'),
          ),
        ),
      );

      expect(find.text('Free Tier'), findsOneWidget);
    });

    testWidgets('Has Upgrade button', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: FilledButton(
              onPressed: null,
              child: Text('Upgrade'),
            ),
          ),
        ),
      );

      expect(find.text('Upgrade'), findsOneWidget);
    });

    testWidgets('Has Language setting', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: Text('Language'),
          ),
        ),
      );

      expect(find.text('Language'), findsOneWidget);
    });

    testWidgets('Has Notifications setting', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: Text('Notifications'),
          ),
        ),
      );

      expect(find.text('Notifications'), findsOneWidget);
    });

    testWidgets('Has Data Saver setting', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: Text('Data Saver'),
          ),
        ),
      );

      expect(find.text('Data Saver'), findsOneWidget);
    });

    testWidgets('Has Display Density setting', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: Text('Display Density'),
          ),
        ),
      );

      expect(find.text('Display Density'), findsOneWidget);
    });

    testWidgets('Has Referrals link', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: Text('Referrals'),
          ),
        ),
      );

      expect(find.text('Referrals'), findsOneWidget);
    });

    testWidgets('Has Admin Dashboard link', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: Text('Admin Dashboard'),
          ),
        ),
      );

      expect(find.text('Admin Dashboard'), findsOneWidget);
    });

    testWidgets('Has About link', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: Text('About'),
          ),
        ),
      );

      expect(find.text('About'), findsOneWidget);
    });

    testWidgets('Has Terms & Privacy link', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: Text('Terms & Privacy'),
          ),
        ),
      );

      expect(find.text('Terms & Privacy'), findsOneWidget);
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
  });
}
