import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:dakika/components/greeting.dart';

void main() {
  group('Greeting', () {
    testWidgets('renders greeting based on time of day', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: Greeting(),
          ),
        ),
      );

      // Should show one of the three greetings
      final hasGreeting = find.text('Good morning').evaluate().isNotEmpty ||
          find.text('Good afternoon').evaluate().isNotEmpty ||
          find.text('Good evening').evaluate().isNotEmpty;

      expect(hasGreeting, isTrue);
    });

    testWidgets('renders formatted date', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: Greeting(),
          ),
        ),
      );

      // Should show a date with weekday and month
      final dateFinder = find.byWidgetPredicate((widget) {
        if (widget is Text) {
          final text = widget.data ?? '';
          return text.contains('Monday') ||
              text.contains('Tuesday') ||
              text.contains('Wednesday') ||
              text.contains('Thursday') ||
              text.contains('Friday') ||
              text.contains('Saturday') ||
              text.contains('Sunday');
        }
        return false;
      });

      expect(dateFinder, findsOneWidget);
    });
  });
}
