import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:dakika/components/ring.dart';
import 'package:dakika/theme/tokens.dart';

/// Splash screen — 1.5 seconds max.
/// The ring draws itself from 0% to 100% as the loading indicator.
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 1500), () {
      if (mounted) context.go('/');
    });
  }

  @override
  Widget build(BuildContext context) {
    final tokens = Theme.of(context).brightness == Brightness.dark
        ? darkTokens
        : lightTokens;

    return Scaffold(
      backgroundColor: tokens.ground,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Ring draws itself — the loading indicator
            const SixtySecondRing(
              progress: 1.0,
              size: 80,
              strokeWidth: 4,
              showLabel: false,
            ),
            const SizedBox(height: Space.lg),
            Text(
              'DAKIKA',
              style: Theme.of(context).textTheme.displayLarge?.copyWith(
                    fontSize: 32,
                  ),
            ),
            const SizedBox(height: Space.xs),
            Text(
              'Read the day in 60 seconds',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: tokens.inkSecondary,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
