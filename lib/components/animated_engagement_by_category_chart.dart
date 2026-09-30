import 'package:flutter/material.dart';
import 'package:dakika/theme/tokens.dart';

/// Animated engagement by category chart.
class AnimatedEngagementByCategoryChart extends StatefulWidget {
  final Map<String, double> data;

  const AnimatedEngagementByCategoryChart({
    super.key,
    required this.data,
  });

  @override
  State<AnimatedEngagementByCategoryChart> createState() =>
      _AnimatedEngagementByCategoryChartState();
}

class _AnimatedEngagementByCategoryChartState
    extends State<AnimatedEngagementByCategoryChart>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );
    _animation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Motion.enter),
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
    final tokens = Theme.of(context).brightness == Brightness.dark
        ? darkTokens
        : lightTokens;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(Space.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Engagement by Category',
              style: Theme.of(context).textTheme.headlineLarge,
            ),
            const SizedBox(height: Space.md),
            AnimatedBuilder(
              animation: _animation,
              builder: (context, child) {
                return Column(
                  children: widget.data.entries.map((entry) {
                    final color = categoryColors[entry.key.toLowerCase()] ??
                        tokens.inkSecondary;

                    return Padding(
                      padding: const EdgeInsets.only(bottom: Space.sm),
                      child: Row(
                        children: [
                          Container(
                            width: 12,
                            height: 12,
                            decoration: BoxDecoration(
                              color: color,
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                          const SizedBox(width: Space.sm),
                          Expanded(
                            child: Text(
                              entry.key,
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                          ),
                          Text(
                            '${(entry.value * _animation.value).toStringAsFixed(1)}%',
                            style: Theme.of(context).textTheme.labelMedium,
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
