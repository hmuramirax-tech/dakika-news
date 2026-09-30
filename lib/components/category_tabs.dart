import 'package:flutter/material.dart';
import 'package:dakika/theme/tokens.dart';

/// Horizontal scrollable category tabs for the Digest Feed.
class CategoryTabs extends StatelessWidget {
  final List<String> categories;
  final String selected;
  final ValueChanged<String> onSelected;

  const CategoryTabs({
    super.key,
    required this.categories,
    required this.selected,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    final tokens = Theme.of(context).brightness == Brightness.dark
        ? darkTokens
        : lightTokens;

    return SizedBox(
      height: 44,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: Space.md),
        itemCount: categories.length,
        separatorBuilder: (_, __) => const SizedBox(width: Space.sm),
        itemBuilder: (context, index) {
          final category = categories[index];
          final isSelected = category == selected;

          return GestureDetector(
            onTap: () => onSelected(category),
            child: AnimatedContainer(
              duration: Motion.normal,
              curve: Motion.inOut,
              padding: const EdgeInsets.symmetric(
                horizontal: Space.md,
                vertical: Space.sm,
              ),
              decoration: BoxDecoration(
                color: isSelected ? tokens.accent : Colors.transparent,
                borderRadius: BorderRadius.circular(Radii.full),
                border: Border.all(
                  color: isSelected ? tokens.accent : tokens.rule,
                ),
              ),
              alignment: Alignment.center,
              child: Text(
                category,
                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                      color: isSelected ? Colors.white : tokens.inkSecondary,
                      fontWeight:
                          isSelected ? FontWeight.w600 : FontWeight.w500,
                    ),
              ),
            ),
          );
        },
      ),
    );
  }
}
