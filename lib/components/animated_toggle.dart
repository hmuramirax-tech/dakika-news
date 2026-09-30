import 'package:flutter/material.dart';
import 'package:dakika/theme/tokens.dart';

/// Animated toggle switch.
class AnimatedToggle extends StatefulWidget {
  final bool value;
  final ValueChanged<bool> onChanged;
  final String? label;

  const AnimatedToggle({
    super.key,
    required this.value,
    required this.onChanged,
    this.label,
  });

  @override
  State<AnimatedToggle> createState() => _AnimatedToggleState();
}

class _AnimatedToggleState extends State<AnimatedToggle>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Color?> _colorAnimation;
  late Animation<double> _thumbAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Motion.normal,
      value: widget.value ? 1 : 0,
    );
    _colorAnimation = ColorTween(
      begin: Theme.of(context).colorScheme.surface,
      end: Theme.of(context).colorScheme.primary,
    ).animate(_controller);
    _thumbAnimation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(CurvedAnimation(parent: _controller, curve: Motion.inOut));
  }

  @override
  void didUpdateWidget(AnimatedToggle oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.value != widget.value) {
      if (widget.value) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
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

    return GestureDetector(
      onTap: () => widget.onChanged(!widget.value),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (widget.label != null) ...[
            Text(
              widget.label!,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(width: Space.sm),
          ],
          AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return Container(
                width: 48,
                height: 28,
                decoration: BoxDecoration(
                  color: _colorAnimation.value,
                  borderRadius: BorderRadius.circular(Radii.full),
                  border: Border.all(
                    color: widget.value
                        ? Theme.of(context).colorScheme.primary
                        : tokens.rule,
                  ),
                ),
                child: Stack(
                  children: [
                    Positioned(
                      left: _thumbAnimation.value * 20,
                      top: 2,
                      child: Container(
                        width: 24,
                        height: 24,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.1),
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
