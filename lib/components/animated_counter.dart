import 'package:flutter/material.dart';
import 'package:dakika/theme/tokens.dart';

/// Animated counter for stats display.
class AnimatedCounter extends StatefulWidget {
  final int value;
  final String label;
  final IconData icon;
  final Duration duration;

  const AnimatedCounter({
    super.key,
    required this.value,
    required this.label,
    required this.icon,
    this.duration = const Duration(milliseconds: 800),
  });

  @override
  State<AnimatedCounter> createState() => _AnimatedCounterState();
}

class _AnimatedCounterState extends State<AnimatedCounter>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<int> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    );
    _animation = IntTween(begin: 0, end: widget.value).animate(
      CurvedAnimation(parent: _controller, curve: Motion.enter),
    );
    _controller.forward();
  }

  @override
  void didUpdateWidget(AnimatedCounter oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.value != widget.value) {
      _animation = IntTween(begin: _animation.value, end: widget.value).animate(
        CurvedAnimation(parent: _controller, curve: Motion.inOut),
      );
      _controller
        ..reset()
        ..forward();
    }
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
        return Column(
          children: [
            Icon(widget.icon, color: tokens.accent, size: 28),
            const SizedBox(height: Space.xs),
            Text(
              '${_animation.value}',
              style: Theme.of(context).textTheme.displayLarge?.copyWith(
                    fontSize: 24,
                  ),
            ),
            Text(
              widget.label,
              style: Theme.of(context).textTheme.labelMedium,
              textAlign: TextAlign.center,
            ),
          ],
        );
      },
    );
  }
}
