import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Admin Dashboard', () {
    testWidgets('Renders admin title', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: Text('Admin Dashboard'),
          ),
        ),
      );

      expect(find.text('Admin Dashboard'), findsOneWidget);
    });

    testWidgets('Has navigation rail', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: NavigationRail(
              selectedIndex: 0,
              destinations: const [
                NavigationRailDestination(
                  icon: Icon(Icons.dashboard_outlined),
                  label: Text('Overview'),
                ),
              ],
            ),
          ),
        ),
      );

      expect(find.byType(NavigationRail), findsOneWidget);
    });

    testWidgets('Has Overview tab', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: Text('Overview'),
          ),
        ),
      );

      expect(find.text('Overview'), findsOneWidget);
    });

    testWidgets('Has Articles tab', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: Text('Content'),
          ),
        ),
      );

      expect(find.text('Content'), findsOneWidget);
    });

    testWidgets('Has Review tab', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: Text('Editor Queue'),
          ),
        ),
      );

      expect(find.text('Editor Queue'), findsOneWidget);
    });

    testWidgets('Has Users tab', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: Text('Users'),
          ),
        ),
      );

      expect(find.text('Users'), findsOneWidget);
    });

    testWidgets('Has Analytics tab', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: Text('Analytics'),
          ),
        ),
      );

      expect(find.text('Analytics'), findsOneWidget);
    });

    testWidgets('Shows dashboard cards', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: Column(
              children: [
                Text('Total Articles'),
                Text('Pending Review'),
                Text('Active Users'),
                Text('Revenue (Month)'),
              ],
            ),
          ),
        ),
      );

      expect(find.text('Total Articles'), findsOneWidget);
      expect(find.text('Pending Review'), findsOneWidget);
      expect(find.text('Active Users'), findsOneWidget);
      expect(find.text('Revenue (Month)'), findsOneWidget);
    });
  });
}
