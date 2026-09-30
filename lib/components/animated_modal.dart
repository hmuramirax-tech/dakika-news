import 'package:flutter/material.dart';
import 'package:dakika/theme/tokens.dart';

/// Animated modal bottom sheet.
class AnimatedModal extends StatelessWidget {
  final Widget child;
  final bool isOpen;
  final VoidCallback onClose;

  const AnimatedModal({
    super.key,
    required this.child,
    required this.isOpen,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: Motion.slow,
      curve: Motion.enter,
      height: isOpen ? null : 0,
      child: child,
    );
  }
}
