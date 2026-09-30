import 'package:flutter/material.dart';
import 'package:dakika/theme/tokens.dart';

/// Animated engagement by screen size chart.
class AnimatedEngagementByScreenSizeChart extends StatefulWidget {
  final Map<String, double> data;

  const AnimatedEngagementByScreenSizeChart({
    super.key,
    required this.data,
  });

  @override
  State<AnimatedEngagementByScreenSizeChart> createState() =>
      _AnimatedEngagementByScreenSizeChartState();
}

class _AnimatedEngagementByScreenSizeChartState
    extends State<AnimatedEngagementByScreenSizeChart>
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
    _animation = Tween<double>(begin: 0, end: 1</longcat_think>
