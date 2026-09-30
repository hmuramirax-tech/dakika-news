import 'package:flutter/material.dart';
import 'package:dakika/theme/tokens.dart';

/// Animated list with staggered entrance.
class AnimatedList extends StatefulWidget {
  final List<Widget> children;
  final EdgeInsets? padding;
  final ScrollPhysics? physics;

  const AnimatedList({
    super.key,
    required this.children,
    this.padding,
    this.physics,
  });

  @override
  State<AnimatedList> createState() => _AnimatedListState();
}

class _AnimatedListState extends State<AnimatedList>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late List<Animation<double>> _animations;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    _animations = List.generate(
      widget.children.length,
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
  void didUpdateWidget(AnimatedList oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.children.length != widget.children.length) {
      _animations = List.generate(
        widget.children.length,
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
    return ListView.builder(
      padding: widget.padding,
      physics: widget.physics,
      itemCount: widget.children.length,
      itemBuilder: (context, index) {
        return AnimatedBuilder(
          animation: _animations[index],
          builder: (context, child) {
            return FadeTransition(
              opacity: _animations[index],
              child: SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(0, 0.1),
                  end: Offset.zero,
                ).animate(_animations[index]),
                child: widget.children[index],
              ),
            );
          },
        );
      },
    );
  }
}
