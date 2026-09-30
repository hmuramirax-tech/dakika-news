import 'package:flutter/material.dart';

/// Design tokens for DAKIKA.
/// Sourced from docs/UIUX-Requirements.md Section 10.
class AppTokens {
  final Color ground;
  final Color surface;
  final Color ink;
  final Color inkSecondary;
  final Color accent;
  final Color accentWarm;
  final Color accentCool;
  final Color danger;
  final Color rule;

  const AppTokens({
    required this.ground,
    required this.surface,
    required this.ink,
    required this.inkSecondary,
    required this.accent,
    required this.accentWarm,
    required this.accentCool,
    required this.danger,
    required this.rule,
  });
}

const lightTokens = AppTokens(
  ground: Color(0xFFFAFAF8),
  surface: Color(0xFFFFFFFF),
  ink: Color(0xFF1A1A18),
  inkSecondary: Color(0xFF6B6B60),
  accent: Color(0xFF1B7A3D),
  accentWarm: Color(0xFFD97706),
  accentCool: Color(0xFF2563EB),
  danger: Color(0xFFDC2626),
  rule: Color(0xFFE5E5DE),
);

const darkTokens = AppTokens(
  ground: Color(0xFF0F0F0E),
  surface: Color(0xFF1A1A18),
  ink: Color(0xFFF5F5F0),
  inkSecondary: Color(0xFFA0A098),
  accent: Color(0xFF4ADE80),
  accentWarm: Color(0xFFFBBF24),
  accentCool: Color(0xFF60A5FA),
  danger: Color(0xFFF87171),
  rule: Color(0xFF2A2A26),
);

/// Spacing scale — 4/8/16/24/32/48
abstract final class Space {
  static const double xs = 4;
  static const double sm = 8;
  static const double md = 16;
  static const double lg = 24;
  static const double xl = 32;
  static const double xxl = 48;
}

/// Radius scale
abstract final class Radii {
  static const double sm = 4;
  static const double md = 8;
  static const double lg = 16;
  static const double full = 9999;
}

/// Motion durations
abstract final class Motion {
  static const Duration fast = Duration(milliseconds: 120);
  static const Duration normal = Duration(milliseconds: 250);
  static const Duration slow = Duration(milliseconds: 400);

  static const Curve enter = Cubic(0.16, 1.0, 0.3, 1.0);
  static const Curve exit = Cubic(0.7, 0.0, 0.84, 0.0);
  static const Curve inOut = Cubic(0.65, 0.0, 0.35, 1.0);
}

/// Category colors for story tags
const categoryColors = <String, Color>{
  'Sports': Color(0xFF1B7A3D),
  'Business': Color(0xFF2563EB),
  'Tech': Color(0xFF7C3AED),
  'Politics': Color(0xFFD97706),
  'Entertainment': Color(0xFFDB2777),
  'Health': Color(0xFF0891B2),
  'General': Color(0xFF6B6B60),
};
