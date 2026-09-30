import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:dakika/components/ring.dart';
import 'package:dakika/theme/tokens.dart';

void main() {
  group('SixtySecondRing', () {
    testWidgets('renders with default size', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: Center(
              child: SixtySecondRing(progress: 0.5),
            ),
          ),
        ),
      );

      expect(find.byType(SixtySecondRing), findsOneWidget);
    });

    testWidgets('renders with custom size', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: Center(
              child: SixtySecondRing(
                progress: 0.5,
                size: 80,
                strokeWidth: 4,
              ),
            ),
          ),
        ),
      );

      expect(find.byType(SixtySecondRing), findsOneWidget);
    });

    testWidgets('shows percentage label by default', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: Center(
              child: SixtySecondRing(progress: 0.5),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('50%'), findsOneWidget);
    });

    testWidgets('hides label when showLabel is false', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: Center(
              child: SixtySecondRing(
                progress: 0.5,
                showLabel: false,
              ),
            ),
          ),
        ),
      );

      expect(find.text('50%'), findsNothing);
    });

    testWidgets('shows custom label', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: Center(
              child: SixtySecondRing(
                progress: 0.5,
                label: '3 min left',
              ),
            ),
          ),
        ),
      );

      expect(find.text('3 min left'), findsOneWidget);
    });

    testWidgets('animates progress changes', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: Center(
              child: SixtySecondRing(progress: 0.0),
            ),
          ),
        ),
      );

      expect(find.text('0%'), findsOneWidget);

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: Center(
              child: SixtySecondRing(progress: 1.0),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('100%'), findsOneWidget);
    });
  });
}
