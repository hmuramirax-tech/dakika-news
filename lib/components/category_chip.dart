import 'package:flutter/material.dart';
import 'package:dakika/theme/tokens.dart';

/// Category chip with icon and color.
class CategoryChip extends StatelessWidget {
  final String label;
  final String? icon;
  final bool isSelected;
  final VoidCallback? onTap;

  const CategoryChip({
    super.key,
    required this.label,
    this.icon,
    this.isSelected = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final tokens = Theme.of(context).brightness == Brightness.dark
        ? darkTokens
        : lightTokens;
    final color = categoryColors[label.toLowerCase()] ?? tokens.inkSecondary;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: Motion.normal,
        curve: Motion.inOut,
        padding: const EdgeInsets.symmetric(
          horizontal: Space.md,
          vertical: Space.sm,
        ),
        decoration: BoxDecoration(
          color: isSelected ? color.withValues(alpha: 0.15) : Colors.transparent,
          borderRadius: BorderRadius.circular(Radii.full),
          border: Border.all(
            color: isSelected ? color : tokens.rule,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              Icon(
                _getIconData(icon!),
                size: 16,
                color: isSelected ? color : tokens.inkSecondary,
              ),
              const SizedBox(width: Space.xs),
            ],
            Text(
              label,
              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    color: isSelected ? color : tokens.inkSecondary,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                  ),
            ),
          ],
        ),
      ),
    );
  }

  IconData _getIconData(String iconName) {
    switch (iconName) {
      case 'sports_soccer':
        return Icons.sports_soccer;
      case 'trending_up':
        return Icons.trending_up;
      case 'computer':
        return Icons.computer;
      case 'account_balance':
        return Icons.account_balance;
      case 'movie':
        return Icons.movie;
      case 'favorite':
        return Icons.favorite;
      default:
        return Icons.article;
    }
  }
}
