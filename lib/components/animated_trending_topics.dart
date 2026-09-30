import 'package:flutter/material.dart';
import 'package:dakika/theme/tokens.dart';

/// Animated trending topics horizontal list.
class AnimatedTrendingTopics extends StatefulWidget {
  final List<String> topics;
  final ValueChanged<String>? onTopicTap;

  const AnimatedTrendingTopics({
    super.key,
    required this.topics,
    this.onTopicTap,
  });

  @override
  State<AnimatedTrendingTopics> createState() => _AnimatedTrendingTopicsState();
}

class _AnimatedTrendingTopicsState extends State<AnimatedTrendingTopics>
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
      widget.topics.length,
      (index) => Tween<double>(begin: 0, end: 1).animate(
        CurvedAnimation(
          parent: _controller,
          curve: Interval(
            index * 0.08,
            (index * 0.08) + 0.3,
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
    return SizedBox(
      height: 40,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: widget.topics.length,
        itemBuilder: (context, index) {
          return AnimatedBuilder(
            animation: _animations[index],
            builder: (context, child) {
              return FadeTransition(
                opacity: _animations[index],
                child: SlideTransition(
                  position: Tween<Offset>(
                    begin: const Offset(0.2, 0),
                    end: Offset.zero,
                  ).animate(_animations[index]),
                  child: Padding(
                    padding: const EdgeInsets.only(right: Space.sm),
                    child: ActionChip(
                      label: Text(widget.topics[index]),
                      onPressed: () => widget.onTopicTap?.call(widget.topics[index]),
                      backgroundColor:
                          Theme.of(context).colorScheme.surface,
                      side: BorderSide(
                        color: Theme.of(context).colorScheme.outline,
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
