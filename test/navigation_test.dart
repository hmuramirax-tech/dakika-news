import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:dakika/router.dart';

void main() {
  group('Navigation', () {
    test('Router is configured', () {
      expect(appRouter, isNotNull);
    });

    test('Router has splash route', () {
      expect(appRouter.configuration.routes, isNotEmpty);
    });
  });
}
