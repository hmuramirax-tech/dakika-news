import 'package:flutter/material.dart';
import 'package:dakika/components/ring.dart';
import 'package:dakika/theme/tokens.dart';

/// Custom pull-to-refresh with 60-Second Ring animation.
class PullToRefreshRing extends StatelessWidget {
  final Widget child;
  final Future<void> Function() onRefresh;

  const PullToRefreshRing({
    super.key,
    required this.child,
    required this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: onRefresh,
      displacement: 80,
      edgeOffset: 0,
      color: Theme.of(context).colorScheme.primary,
      backgroundColor: Theme.of(context).colorScheme.surface,
      child: child,
    );
  }
}
