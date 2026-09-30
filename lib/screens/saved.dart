import 'package:flutter/material.dart';
import 'package:dakika/theme/tokens.dart';

/// Saved screen — saved stories, read later, downloaded digests.
class SavedScreen extends StatelessWidget {
  const SavedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final tokens = Theme.of(context).brightness == Brightness.dark
        ? darkTokens
        : lightTokens;

    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(Space.md),
                child: Text(
                  'Saved',
                  style: Theme.of(context).textTheme.displayLarge,
                ),
              ),
            ),

            // Empty state
            SliverFillRemaining(
              hasScrollBody: false,
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.bookmark_outline,
                      size: 64,
                      color: tokens.inkSecondary.withValues(alpha: 0.5),
                    ),
                    const SizedBox(height: Space.md),
                    Text(
                      'No saved stories yet',
                      style: Theme.of(context).textTheme.headlineLarge,
                    ),
                    const SizedBox(height: Space.sm),
                    Text(
                      'Swipe right on any story to save it here.',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: tokens.inkSecondary,
                          ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
