import 'package:flutter/material.dart';
import 'package:dakika/theme/tokens.dart';

/// Time-based greeting for the Digest Feed header.
class Greeting extends StatelessWidget {
  const Greeting({super.key});

  static String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good morning';
    if (hour < 18) return 'Good afternoon';
    return 'Good evening';
  }

  static String _getFormattedDate() {
    final now = DateTime.now();
    final weekdays = [
      'Monday', 'Tuesday', 'Wednesday', 'Thursday',
      'Friday', 'Saturday', 'Sunday',
    ];
    final months = [
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December',
    ];
    return '${weekdays[now.weekday - 1]}, ${now.day} ${months[now.month - 1]}';
  }

  @override
  Widget build(BuildContext context) {
    final tokens = Theme.of(context).brightness == Brightness.dark
        ? darkTokens
        : lightTokens;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          _getGreeting(),
          style: Theme.of(context).textTheme.displayLarge,
        ),
        const SizedBox(height: Space.xs),
        Text(
          _getFormattedDate(),
          style: Theme.of(context).textTheme.labelMedium,
        ),
      ],
    );
  }
}
