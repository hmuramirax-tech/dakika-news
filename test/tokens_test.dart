import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:dakika/theme/tokens.dart';

void main() {
  group('AppTokens', () {
    test('light tokens have correct values', () {
      expect(lightTokens.ground, const Color(0xFFFAFAF8));
      expect(lightTokens.surface, const Color(0xFFFFFFFF));
      expect(lightTokens.ink, const Color(0xFF1A1A18));
      expect(lightTokens.accent, const Color(0xFF1B7A3D));
      expect(lightTokens.accentWarm, const Color(0xFFD97706));
      expect(lightTokens.accentCool, const Color(0xFF2563EB));
      expect(lightTokens.danger, const Color(0xFFDC2626));
      expect(lightTokens.rule, const Color(0xFFE5E5DE));
    });

    test('dark tokens have correct values', () {
      expect(darkTokens.ground, const Color(0xFF0F0F0E));
      expect(darkTokens.surface, const Color(0xFF1A1A18));
      expect(darkTokens.ink, const Color(0xFFF5F5F0));
      expect(darkTokens.accent, const Color(0xFF4ADE80));
      expect(darkTokens.accentWarm, const Color(0xFFFBBF24));
      expect(darkTokens.accentCool, const Color(0xFF60A5FA));
      expect(darkTokens.danger, const Color(0xFFF87171));
      expect(darkTokens.rule, const Color(0xFF2A2A26));
    });
  });

  group('Space', () {
    test('has correct spacing values', () {
      expect(Space.xs, 4);
      expect(Space.sm, 8);
      expect(Space.md, 16);
      expect(Space.lg, 24);
      expect(Space.xl, 32);
      expect(Space.xxl, 48);
    });
  });

  group('Radii', () {
    test('has correct radius values', () {
      expect(Radii.sm, 4);
      expect(Radii.md, 8);
      expect(Radii.lg, 16);
      expect(Radii.full, 9999);
    });
  });

  group('Motion', () {
    test('has correct duration values', () {
      expect(Motion.fast, const Duration(milliseconds: 120));
      expect(Motion.normal, const Duration(milliseconds: 250));
      expect(Motion.slow, const Duration(milliseconds: 400));
    });

    test('has correct easing curves', () {
      expect(Motion.enter, const Cubic(0.16, 1.0, 0.3, 1.0));
      expect(Motion.exit, const Cubic(0.7, 0.0, 0.84, 0.0));
      expect(Motion.inOut, const Cubic(0.65, 0.0, 0.35, 1.0));
    });
  });

  group('categoryColors', () {
    test('has all required categories', () {
      expect(categoryColors.containsKey('Sports'), isTrue);
      expect(categoryColors.containsKey('Business'), isTrue);
      expect(categoryColors.containsKey('Tech'), isTrue);
      expect(categoryColors.containsKey('Politics'), isTrue);
      expect(categoryColors.containsKey('Entertainment'), isTrue);
      expect(categoryColors.containsKey('Health'), isTrue);
      expect(categoryColors.containsKey('General'), isTrue);
    });
  });
}
