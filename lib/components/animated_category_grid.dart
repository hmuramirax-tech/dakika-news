import 'package:flutter/material.dart';
import 'package:dakika/theme/tokens.dart';

/// Animated category grid with staggered entrance.
class AnimatedCategoryGrid extends StatefulWidget {
  final List<Category> categories;
  final String? selectedCategory;
  final ValueChanged<String>? onCategorySelected;

  const AnimatedCategoryGrid({
    super.key,
    required this.categories,
    this.selectedCategory,
    this.onCategorySelected,
  });

  @override
  State<AnimatedCategoryGrid> createState() => _AnimatedCategoryGridState();
}

class _AnimatedCategoryGridState extends State<AnimatedCategoryGrid>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late List<Animation<double>> _animations;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _animations = List.generate(
      widget.categories.length,
      (index) => Tween<double>(begin: 0, end: 1).animate(
        CurvedAnimation(
          parent: _controller,
          curve: Interval(
            index * 0.1,
            (index * 0.1) + 0.3,
            curve: Motion.enter,
          ),
        ),
      ),
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: Space.sm,
        crossAxisSpacing: Space.sm,
        childAspectRatio: 1.5,
      ),
      itemCount: widget.categories.length,
      itemBuilder: (context, index) {
        final category = widget.categories[index];
        final isSelected = category.name == widget.selectedCategory;

        return AnimatedBuilder(
          animation: _animations[index],
          builder: (context, child) {
            return FadeTransition(
              opacity: _animations[index],
              child: SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(0, 0.2),
                  end: Offset.zero,
                ).animate(_animations[index]),
                child: _CategoryCard(
                  category: category,
                  isSelected: isSelected,
                  onTap: () => widget.onCategorySelected?.call(category.name),
                ),
              ),
            );
          },
        );
      },
    );
  }
}

class _CategoryCard extends StatelessWidget {
  final Category category;
  final bool isSelected;
  final VoidCallback? onTap;

  const _CategoryCard({
    required this.category,
    this.isSelected = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final tokens = Theme.of(context).brightness == Brightness.dark
        ? darkTokens
        : lightTokens;
    final color = _parseColor(category.color);

    return Card(
      color: isSelected ? color.withValues(alpha: 0.1) : tokens.surface,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(Radii.md),
        child: Padding(
          padding: const EdgeInsets.all(Space.md),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                _getIconData(category.icon),
                size: 32,
                color: isSelected ? color : tokens.inkSecondary,
              ),
              const SizedBox(height: Space.sm),
              Text(
                category.displayName,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                      color: isSelected ? color : tokens.ink,
                    ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _parseColor(String? colorStr) {
    if (colorStr == null) return Colors.grey;
    try {
      return Color(int.parse(colorStr.replaceFirst('#', '0xFF')));
    } catch (e) {
      return Colors.grey;
    }
  }

  IconData _getIconData(String? iconName) {
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
