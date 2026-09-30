import 'package:flutter/material.dart';
import 'package:dakika/theme/tokens.dart';

/// Simple animated bar chart for analytics.
class AnimatedAnalyticsChart extends StatefulWidget {
  final Map<String, int> data;
  final String title;

  const AnimatedAnalyticsChart({
    super.key,
    required this.data,
    required this.title,
  });

  @override
  State<AnimatedAnalyticsChart> createState() => _AnimatedAnalyticsChartState();
}

class _AnimatedAnalyticsChartState extends State<AnimatedAnalyticsChart>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late List<Animation<double>> _animations;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );

    final entries = widget.data.entries.toList();
    _animations = List.generate(
      entries.length,
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
    final tokens = Theme.of(context).brightness == Brightness.dark
        ? darkTokens
        : lightTokens;
    final entries = widget.data.entries.toList();
    final maxValue = entries.map((e) => e.value).reduce((a, b) => a > b ? a : b);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(Space.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.title,
              style: Theme.of(context).textTheme.headlineLarge,
            ),
            const SizedBox(height: Space.md),
            ...entries.asMap().entries.map((entry) {
              final index = entry.key;
              final data = entry.value;

              return AnimatedBuilder(
                animation: _animations[index],
                builder: (context, child) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: Space.sm),
                    child: Row(
                      children: [
                        SizedBox(
                          width: 80,
                          child: Text(
                            data.key,
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ),
                        Expanded(
                          child: LinearProgressIndicator(
                            value: (data.value / maxValue) * _animations[index].value,
                            backgroundColor: tokens.rule,
                            valueColor: AlwaysStoppedAnimation<Color>(tokens.accent),
                            minHeight: 8,
                            borderRadius: BorderRadius.circular(Radii.sm),
                          ),
                        ),
                        const SizedBox(width: Space.sm),
                        Text(
                          '${data.value}',
                          style: Theme.of(context).textTheme.labelMedium,
                        ),
                      ],
                    ),
                  );
                },
              );
            }),
          ],
        ),
      ),
    );
  }
}
