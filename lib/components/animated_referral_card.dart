import 'package:flutter/material.dart';
import 'package:dakika/theme/tokens.dart';

/// Animated referral card with pulse effect.
class AnimatedReferralCard extends StatefulWidget {
  final String title;
  final String subtitle;
  final String code;
  final VoidCallback? onShare;

  const AnimatedReferralCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.code,
    this.onShare,
  });

  @override
  State<AnimatedReferralCard> createState() => _AnimatedReferralCardState();
}

class _AnimatedReferralCardState extends State<AnimatedReferralCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    )..repeat(reverse: true);
    _pulseAnimation = Tween<double>(begin: 1, end: 1.05).animate(
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
    final tokens = Theme.of(context).brightness == Brightness.dark
        ? darkTokens
        : lightTokens;

    return AnimatedBuilder(
      animation: _pulseAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _pulseAnimation.value,
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(Space.md),
              child: Column(
                children: [
                  Text(
                    widget.title,
                    style: Theme.of(context).textTheme.headlineLarge,
                  ),
                  const SizedBox(height: Space.sm),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: Space.lg,
                      vertical: Space.md,
                    ),
                    decoration: BoxDecoration(
                      color: tokens.accent.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(Radii.md),
                      border: Border.all(
                        color: tokens.accent.withValues(alpha: 0.3),
                      ),
                    ),
                    child: Text(
                      widget.code,
                      style: Theme.of(context).textTheme.displayLarge?.copyWith(
                            fontSize: 32,
                            color: tokens.accent,
                            letterSpacing: 0.1,
                          ),
                    ),
                  ),
                  const SizedBox(height: Space.sm),
                  Text(
                    widget.subtitle,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: tokens.inkSecondary,
                        ),
                    textAlign: TextAlign.center,
                  ),
                  if (widget.onShare != null) ...[
                    const SizedBox(height: Space.md),
                    FilledButton.icon(
                      onPressed: widget.onShare,
                      icon: const Icon(Icons.share),
                      label: const Text('Share'),
                    ),
                  ],
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
