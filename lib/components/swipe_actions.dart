import 'package:flutter/material.dart';
import 'package:dakika/theme/tokens.dart';

/// Swipe action overlay for story cards.
class SwipeActions extends StatelessWidget {
  final Widget child;
  final VoidCallback? onSave;
  final VoidCallback? onShare;
  final VoidCallback? onHide;

  const SwipeActions({
    super.key,
    required this.child,
    this.onSave,
    this.onShare,
    this.onHide,
  });

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(child.hashCode),
      background: _buildSwipeBackground(
        context,
        alignment: Alignment.centerLeft,
        color: Theme.of(context).colorScheme.primary,
        icon: Icons.bookmark,
        label: 'Save',
      ),
      secondaryBackground: _buildSwipeBackground(
        context,
        alignment: Alignment.centerRight,
        color: Theme.of(context).colorScheme.secondary,
        icon: Icons.share,
        label: 'Share',
      ),
      confirmDismiss: (direction) async {
        if (direction == DismissDirection.startToEnd) {
          onSave?.call();
        } else {
          onShare?.call();
        }
        return false;
      },
      child: child,
    );
  }

  Widget _buildSwipeBackground(
    BuildContext context, {
    required Alignment alignment,
    required Color color,
    required IconData icon,
    required String label,
  }) {
    return Container(
      alignment: alignment,
      padding: const EdgeInsets.symmetric(horizontal: Space.lg),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(Radii.md),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: Colors.white),
          const SizedBox(width: Space.sm),
          Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
