import 'package:flutter/material.dart';
import 'package:dakika/components/story_card.dart';
import 'package:dakika/theme/tokens.dart';

/// Story card with entrance animation.
class AnimatedStoryCard extends StatefulWidget {
  final String headline;
  final String summary;
  final String source;
  final String category;
  final String publishedAt;
  final String readingTime;
  final VoidCallback? onTap;
  final VoidCallback? onSave;
  final VoidCallback? onShare;
  final int index;

  const AnimatedStoryCard({
    super.key,
    required this.headline,
    required this.summary,
    required this.source,
    required this.category,
    required this.publishedAt,
    required this.readingTime,
    this.onTap,
    this.onSave,
    this.onShare,
    this.index = 0,
  });

  @override
  State<AnimatedStoryCard> createState() => _AnimatedStoryCardState();
}

class _AnimatedStoryCardState extends State<AnimatedStoryCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Motion.normal,
    );
    _fadeAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Motion.enter),
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.08),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Motion.enter));

    // Stagger animation based on index
    Future.delayed(Duration(milliseconds: widget.index * 80), () {
      if (mounted) _controller.forward();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return FadeTransition(
          opacity: _fadeAnimation,
          child: SlideTransition(
            position: _slideAnimation,
            child: StoryCard(
              headline: widget.headline,
              summary: widget.summary,
              source: widget.source,
              category: widget.category,
              publishedAt: widget.publishedAt,
              readingTime: widget.readingTime,
              onTap: widget.onTap,
              onSave: widget.onSave,
              onShare: widget.onShare,
            ),
          ),
        );
      },
    );
  }
}
