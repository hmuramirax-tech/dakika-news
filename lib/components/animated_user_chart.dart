import 'package:flutter/material.dart';
import 'package:dakika/theme/tokens.dart';

/// Animated user growth chart.
class AnimatedUserChart extends StatefulWidget {
  final List<int> data;
  final List<String> labels;

  const AnimatedUserChart({
    super.key,
    required this.data,
    required this.labels,
  });

  @override
  State<AnimatedUserChart> createState() => _AnimatedUserChartState();
}

class _AnimatedUserChartState extends State<AnimatedUserChart>
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
    final maxValue = widget.data.reduce((a, b) => a > b ? a : b);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(Space.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'User Growth',
              style: Theme.of(context).textTheme.headlineLarge,
            ),
            const SizedBox(height: Space.md),
            SizedBox(
              height: 120,
              child: AnimatedBuilder(
                animation: _animation,
                builder: (context, child) {
                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: widget.data.asMap().entries.map((entry) {
                      final index = entry.key;
                      final value = entry.value;
                      final height = (value / maxValue) * 100 * _animation.value;

                      return Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 2),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text(
                                '$value',
                                style: Theme.of(context).textTheme.labelSmall,
                              ),
                              const SizedBox(height: 4),
                              Container(
                                height: height,
                                decoration: BoxDecoration(
                                  color: tokens.accentCool,
                                  borderRadius: const BorderRadius.vertical(
                                    top: Radius.circular(4),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                widget.labels[index],
                                style: Theme.of(context).textTheme.labelSmall,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
