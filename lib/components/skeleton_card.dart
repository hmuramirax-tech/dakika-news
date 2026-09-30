import 'package:flutter/material.dart';
import 'package:dakika/theme/tokens.dart';

/// Skeleton loading card — shown while content loads.
class SkeletonCard extends StatefulWidget {
  const SkeletonCard({super.key});

  @override
  State<SkeletonCard> createState() => _SkeletonCardState();
}

class _SkeletonCardState extends State<SkeletonCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat(reverse: true);
    _animation = Tween<double>(begin: 0.3, end: 0.7).animate(
      CurvedAnimation(parent: _controller, curve: Motion.inOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final tokens = Theme.of(context).brightness == Brightness.dark
        ? darkTokens
        : lightTokens;

    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Card(
          margin: const EdgeInsets.symmetric(
            horizontal: Space.md,
            vertical: Space.xs,
          ),
          child: Padding(
            padding: const EdgeInsets.all(Space.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Category tag skeleton
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _SkeletonBox(
                      width: 60,
                      height: 20,
                      color: tokens.rule.withValues(alpha: _animation.value),
                    ),
                    _SkeletonBox(
                      width: 40,
                      height: 16,
                      color: tokens.rule.withValues(alpha: _animation.value),
                    ),
                  ],
                ),
                const SizedBox(height: Space.sm),

                // Headline skeleton
                _SkeletonBox(
                  width: double.infinity,
                  height: 22,
                  color: tokens.rule.withValues(alpha: _animation.value),
                ),
                const SizedBox(height: Space.xs),
                _SkeletonBox(
                  width: 200,
                  height: 22,
                  color: tokens.rule.withValues(alpha: _animation.value),
                ),
                const SizedBox(height: Space.sm),

                // Summary skeleton
                _SkeletonBox(
                  width: double.infinity,
                  height: 16,
                  color: tokens.rule.withValues(alpha: _animation.value),
                ),
                const SizedBox(height: Space.xs),
                _SkeletonBox(
                  width: double.infinity,
                  height: 16,
                  color: tokens.rule.withValues(alpha: _animation.value),
                ),
                const SizedBox(height: Space.xs),
                _SkeletonBox(
                  width: 150,
                  height: 16,
                  color: tokens.rule.withValues(alpha: _animation.value),
                ),
                const SizedBox(height: Space.md),

                // Source skeleton
                Row(
                  children: [
                    _SkeletonBox(
                      width: 12,
                      height: 12,
                      color: tokens.rule.withValues(alpha: _animation.value),
                      shape: BoxShape.circle,
                    ),
                    const SizedBox(width: Space.xs),
                    _SkeletonBox(
                      width: 100,
                      height: 14,
                      color: tokens.rule.withValues(alpha: _animation.value),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _SkeletonBox extends StatelessWidget {
  final double width;
  final double height;
  final Color color;
  final BoxShape shape;

  const _SkeletonBox({
    required this.width,
    required this.height,
    required this.color,
    this.shape = BoxShape.rectangle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: color,
        shape: shape,
        borderRadius: shape == BoxShape.rectangle
            ? BorderRadius.circular(Radii.sm)
            : null,
      ),
    );
  }
}
