import 'package:flutter/material.dart';
import 'package:dakika/theme/tokens.dart';

/// Full Article view — displays the original article with AI summary box.
class FullArticleScreen extends StatelessWidget {
  final String articleId;

  const FullArticleScreen({super.key, required this.articleId});

  @override
  Widget build(BuildContext context) {
    final tokens = Theme.of(context).brightness == Brightness.dark
        ? darkTokens
        : lightTokens;

    // TODO: Fetch article from Supabase using articleId
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: Space.sm,
                vertical: Space.sm,
              ),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: () => Navigator.pop(context),
                  ),
                  Expanded(
                    child: Text(
                      'The New Times',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: tokens.accentCool,
                            fontWeight: FontWeight.w500,
                          ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.share_outlined),
                    onPressed: () {
                      // TODO: Share article
                    },
                  ),
                ],
              ),
            ),

            // Article content
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: Space.md),
                children: [
                  // Headline
                  Text(
                    'Rwanda GDP Growth Exceeds Expectations in Q3 2026',
                    style: Theme.of(context).textTheme.displayLarge,
                  ),
                  const SizedBox(height: Space.sm),

                  // Byline
                  Row(
                    children: [
                      Text(
                        'By Staff Reporter',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: tokens.inkSecondary,
                            ),
                      ),
                      const SizedBox(width: Space.sm),
                      Text(
                        '•',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: tokens.inkSecondary,
                            ),
                      ),
                      const SizedBox(width: Space.sm),
                      Text(
                        '2h ago',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: tokens.inkSecondary,
                            ),
                      ),
                      const SizedBox(width: Space.sm),
                      Text(
                        '•',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: tokens.inkSecondary,
                            ),
                      ),
                      const SizedBox(width: Space.sm),
                      Text(
                        '3 min read',
                        style: Theme.of(context).textTheme.labelSmall,
                      ),
                    ],
                  ),
                  const SizedBox(height: Space.md),

                  // Hero image placeholder
                  Container(
                    height: 200,
                    decoration: BoxDecoration(
                      color: tokens.rule,
                      borderRadius: BorderRadius.circular(Radii.md),
                    ),
                    child: Center(
                      child: Icon(
                        Icons.image_outlined,
                        size: 48,
                        color: tokens.inkSecondary.withValues(alpha: 0.5),
                      ),
                    ),
                  ),
                  const SizedBox(height: Space.md),

                  // AI Summary box
                  Container(
                    padding: const EdgeInsets.all(Space.md),
                    decoration: BoxDecoration(
                      color: tokens.accent.withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(Radii.md),
                      border: Border.all(
                        color: tokens.accent.withValues(alpha: 0.2),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.auto_awesome,
                                size: 16, color: tokens.accent),
                            const SizedBox(width: Space.xs),
                            Text(
                              'AI SUMMARY',
                              style: Theme.of(context)
                                  .textTheme
                                  .labelMedium
                                  ?.copyWith(
                                    color: tokens.accent,
                                    fontWeight: FontWeight.w600,
                                  ),
                            ),
                          ],
                        ),
                        const SizedBox(height: Space.sm),
                        Text(
                          'The National Institute of Statistics reported 8.2% growth driven by services and agriculture sectors, surpassing the projected 7.5% target.',
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: Space.md),

                  // Article body placeholder
                  Text(
                    'Lorem ipsum dolor sit amet, consectetur adipiscing elit. '
                    'Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. '
                    'Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris '
                    'nisi ut aliquip ex ea commodo consequat.\n\n'
                    'Duis aute irure dolor in reprehenderit in voluptate velit esse '
                    'cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat '
                    'cupidatat non proident, sunt in culpa qui officia deserunt '
                    'mollit anim id est laborum.\n\n'
                    'Sed ut perspiciatis unde omnis iste natus error sit voluptatem '
                    'accusantium doloremque laudantium, totam rem aperiam, eaque ipsa '
                    'quae ab illo inventore veritatis et quasi architecto beatae vitae '
                    'dicta sunt explicabo.',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          height: 1.7,
                        ),
                  ),
                  const SizedBox(height: Space.xxl),
                ],
              ),
            ),

            // Bottom bar
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: Space.md,
                vertical: Space.sm,
              ),
              decoration: BoxDecoration(
                color: tokens.surface,
                border: Border(top: BorderSide(color: tokens.rule)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  IconButton(
                    icon: const Icon(Icons.bookmark_outline),
                    onPressed: () {
                      // TODO: Save article
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.share_outlined),
                    onPressed: () {
                      // TODO: Share article
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.volume_up_outlined),
                    onPressed: () {
                      // TODO: Play audio summary
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.open_in_browser),
                    onPressed: () {
                      // TODO: Open in external browser
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
