import 'package:flutter/material.dart';
import 'package:dakika/theme/tokens.dart';

/// Animated floating action button.
class AnimatedFab extends StatefulWidget {
  final VoidCallback onPressed;
  final IconData icon;
  final String label;
  final bool isExtended;

  const AnimatedFab({
    super.key,
    required this.onPressed,
    required this.icon,
    this.label = '',
    this.isExtended = false,
  });

  @override
  State<AnimatedFab> createState() => _AnimatedFabState();
}

class _AnimatedFabState extends State<AnimatedFab>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Motion.fast,
    );
    _scaleAnimation = Tween<double>(begin: 1, end: 0.95).animate(
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
    return GestureDetector(
      onTapDown: (_) => _controller.forward(),
      onTapUp: (_) => _controller.reverse(),
      onTapCancel: () => _controller.reverse(),
      onTap: widget.onPressed,
      child: AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: widget.isExtended
                ? FloatingActionButton.extended(
                    onPressed: null,
                    icon: Icon(widget.icon),
                    label: Text(widget.label),
                  )
                : FloatingActionButton(
                    onPressed: null,
                    child: Icon(widget.icon),
                  ),
          );
        },
      ),
    );
  }
}
