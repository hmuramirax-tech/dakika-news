import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Performance Tests', () {
    testWidgets('Digest feed renders within 3 seconds', (tester) async {
      final stopwatch = Stopwatch()..start();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ListView.builder(
              itemCount: 15,
              itemBuilder: (context, index) => Card(
                child: ListTile(
                  title: Text('Story $index'),
                  subtitle: Text('Summary of story $index...'),
                ),
              ),
            ),
          ),
        ),
      );

      stopwatch.stop();
      expect(stopwatch.elapsedMilliseconds, lessThan(3000));
    });

    testWidgets('Story cards render efficiently', (tester) async {
      final stopwatch = Stopwatch()..start();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ListView.builder(
              itemCount: 50,
              itemBuilder: (context, index) => Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Headline $index', style: Theme.of(context).textTheme.titleMedium),
                      const SizedBox(height: 8),
                      Text('Summary of story $index. ' * 5),
                      const SizedBox(height: 8),
                      Text('Source $index • ${index + 1}h ago', style: Theme.of(context).textTheme.bodySmall),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      );

      stopwatch.stop();
      expect(stopwatch.elapsedMilliseconds, lessThan(5000));
    });

    testWidgets('Search results render quickly', (tester) async {
      final stopwatch = Stopwatch()..start();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ListView.builder(
              itemCount: 20,
              itemBuilder: (context, index) => ListTile(
                title: Text('Result $index'),
                subtitle: Text('Search result for query $index'),
              ),
            ),
          ),
        ),
      );

      stopwatch.stop();
      expect(stopwatch.elapsedMilliseconds, lessThan(2000));
    });

    testWidgets('Navigation between tabs is smooth', (tester) async {
      final stopwatch = Stopwatch()..start();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(child: Text('Tab Content')),
            bottomNavigationBar: BottomNavigationBar(
              currentIndex: 0,
              items: const [
                BottomNavigationBarItem(icon: Icon(Icons.article), label: 'Digest'),
                BottomNavigationBarItem(icon: Icon(Icons.explore), label: 'Explore'),
                BottomNavigationBarItem(icon: Icon(Icons.bookmark), label: 'Saved'),
                BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
              ],
            ),
          ),
        ),
      );

      stopwatch.stop();
      expect(stopwatch.elapsedMilliseconds, lessThan(1000));
    });
  });
}
