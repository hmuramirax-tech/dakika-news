import 'package:flutter/material.dart';
import 'package:dakika/theme/tokens.dart';

/// Animated drawer with slide-in animation.
class AnimatedDrawer extends StatefulWidget {
  final Widget child;
  final bool isOpen;
  final VoidCallback onClose;

  const AnimatedDrawer({
    super.key,
    required this.child,
    required this.isOpen,
    required this.onClose,
  });

  @override
  State<AnimatedDrawer> createState() => _AnimatedDrawerState();
}

class _AnimatedDrawerState extends State<AnimatedDrawer>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Motion.slow,
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(-1, 0),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Motion.enter));

    if (widget.isOpen) _controller.forward();
  }

  @override
  void didUpdateWidget(AnimatedDrawer oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.isOpen != widget.isOpen) {
      if (widget.isOpen) {
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
    return Stack(
      children: [
        // Backdrop
        if (widget.isOpen)
          GestureDetector(
            onTap: widget.onClose,
            child: AnimatedOpacity(
              opacity: widget.isOpen ? 1 : 0,
              duration: Motion.normal,
              child: Container(
                color: Colors.black54,
              ),
            ),
          ),
        // Drawer
        SlideTransition(
          position: _slideAnimation,
          child: widget.child,
        ),
      ],
    );
  }
}
