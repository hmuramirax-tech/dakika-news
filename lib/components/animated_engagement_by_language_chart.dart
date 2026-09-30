import 'package:flutter/material.dart';
import 'package:dakika/theme/tokens.dart';

/// Animated engagement by language chart.
class AnimatedEngagementByLanguageChart extends StatefulWidget {
  final Map<String, double> data;

  const AnimatedEngagementByLanguageChart({
    super.key,
    required this.data,
  });

  @override
  State<AnimatedEngagementByLanguageChart> createState() =>
      _AnimatedEngagementByLanguageChartState();
}

class _AnimatedEngagementByLanguageChartState
    extends State<AnimatedEngagementByLanguageChart>
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
              'Engagement by Language',
              style: Theme.of(context).textTheme.headlineLarge,
            ),
            const SizedBox(height: Space.md),
            AnimatedBuilder(
              animation: _animation,
              builder: (context, child) {
                return Column(
                  children: widget.data.entries.map((entry) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: Space.sm),
                      child: Row(
                        children: [
                          SizedBox(
                            width: 80,
                            child: Text(
                              entry.key,
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                          ),
                          Expanded(
                            child: LinearProgressIndicator(
                              value: entry.value * _animation.value,
                              backgroundColor: tokens.rule,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                  tokens.accent),
                              minHeight: 8,
                              borderRadius: BorderRadius.circular(Radii.sm),
                            ),
                          ),
                          const SizedBox(width: Space.sm),
                          Text(
                            '${(entry.value * 100).toStringAsFixed(0)}%',
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
