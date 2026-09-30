import 'package:flutter/material.dart';
import 'package:dakika/theme/tokens.dart';

/// Animated subscription tier chart.
class AnimatedSubscriptionChart extends StatefulWidget {
  final Map<String, int> data;

  const AnimatedSubscriptionChart({
    super.key,
    required this.data,
  });

  @override
  State<AnimatedSubscriptionChart> createState() => _AnimatedSubscriptionChartState();
}

class _AnimatedSubscriptionChartState extends State<AnimatedSubscriptionChart>
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
    final total = widget.data.values.reduce((a, b) => a + b);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(Space.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Subscription Tiers',
              style: Theme.of(context).textTheme.headlineLarge,
            ),
            const SizedBox(height: Space.md),
            AnimatedBuilder(
              animation: _animation,
              builder: (context, child) {
                return Column(
                  children: widget.data.entries.map((entry) {
                    final percentage = (entry.value / total * 100) * _animation.value;

                    return Padding(
                      padding: const EdgeInsets.only(bottom: Space.sm),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              entry.key,
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                          ),
                          Text(
                            '${percentage.toStringAsFixed(1)}%',
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
