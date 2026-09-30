import 'package:flutter/material.dart';
import 'package:dakika/theme/tokens.dart';

/// Story Card — the unit of consumption in OneNews.
/// Displays headline, summary, source, category, and reading time.
class StoryCard extends StatelessWidget {
  final String headline;
  final String summary;
  final String source;
  final String category;
  final String publishedAt;
  final String readingTime;
  final VoidCallback? onTap;
  final VoidCallback? onSave;
  final VoidCallback? onShare;

  const StoryCard({
    super.key,
    required this.headline,
    required this.summary,
    required this.source,
    required this.category,
    required this.publishedAt,
    required this.readingTime,
    this.onTap,
    this.onSave,
    this.onShare,
  });

  @override
  Widget build(BuildContext context) {
    final tokens = Theme.of(context).brightness == Brightness.dark
        ? darkTokens
        : lightTokens;
    final categoryColor = categoryColors[category] ?? tokens.inkSecondary;

    return Card(
      margin: const EdgeInsets.symmetric(
        horizontal: Space.md,
        vertical: Space.xs,
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(Radii.md),
        child: Padding(
          padding: const EdgeInsets.all(Space.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Category tag + reading time
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _CategoryTag(label: category, color: categoryColor),
                  Text(
                    readingTime,
                    style: Theme.of(context).textTheme.labelSmall,
                  ),
                ],
              ),
              const SizedBox(height: Space.sm),

              // Headline
              Text(
                headline,
                style: Theme.of(context).textTheme.headlineLarge,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: Space.sm),

              // Summary
              Text(
                summary,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: tokens.inkSecondary,
                    ),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: Space.md),

              // Source + time + actions
              Row(
                children: [
                  Icon(Icons.circle, size: 6, color: tokens.accentCool),
                  const SizedBox(width: Space.xs),
                  Expanded(
                    child: Text(
                      source,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: tokens.accentCool,
                            fontWeight: FontWeight.w500,
                          ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Text(
                    publishedAt,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: tokens.inkSecondary,
                        ),
                  ),
                  if (onSave != null) ...[
                    const SizedBox(width: Space.sm),
                    IconButton(
                      icon: const Icon(Icons.bookmark_outline, size: 20),
                      onPressed: onSave,
                      visualDensity: VisualDensity.compact,
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(
                        minWidth: 44,
                        minHeight: 44,
                      ),
                    ),
                  ],
                  if (onShare != null) ...[
                    IconButton(
                      icon: const Icon(Icons.share_outlined, size: 20),
                      onPressed: onShare,
                      visualDensity: VisualDensity.compact,
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(
                        minWidth: 44,
                        minHeight: 44,
                      ),
                    ),
                  ],
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CategoryTag extends StatelessWidget {
  final String label;
  final Color color;

  const _CategoryTag({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: Space.sm,
        vertical: Space.xs,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(Radii.sm),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Text(
        label.toUpperCase(),
        style: Theme.of(context).textTheme.labelMedium?.copyWith(
              color: color,
              fontSize: 10,
              fontWeight: FontWeight.w600,
            ),
      ),
    );
  }
}
