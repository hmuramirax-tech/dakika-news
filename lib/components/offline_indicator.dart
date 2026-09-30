import 'package:flutter/material.dart';
import 'package:dakika/theme/tokens.dart';

/// Small offline indicator shown in the app bar.
class OfflineIndicator extends StatelessWidget {
  const OfflineIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    final tokens = Theme.of(context).brightness == Brightness.dark
        ? darkTokens
        : lightTokens;

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: Space.sm,
        vertical: Space.xs,
      ),
      decoration: BoxDecoration(
        color: tokens.accentWarm.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(Radii.full),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.cloud_off,
            size: 14,
            color: tokens.accentWarm,
          ),
          const SizedBox(width: Space.xs),
          Text(
            'Offline',
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  color: tokens.accentWarm,
                  fontSize: 10,
                ),
          ),
        ],
      ),
    );
  }
}
