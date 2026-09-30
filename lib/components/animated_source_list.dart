import 'package:flutter/material.dart';
import 'package:dakika/theme/tokens.dart';

/// Animated source list with follow/unfollow.
class AnimatedSourceList extends StatefulWidget {
  final List<Source> sources;
  final List<String> followedSourceIds;
  final ValueChanged<String>? onFollow;
  final ValueChanged<String>? onUnfollow;

  const AnimatedSourceList({
    super.key,
    required this.sources,
    required this.followedSourceIds,
    this.onFollow,
    this.onUnfollow,
  });

  @override
  State<AnimatedSourceList> createState() => _AnimatedSourceListState();
}

class _AnimatedSourceListState extends State<AnimatedSourceList>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late List<Animation<double>> _animations;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    _animations = List.generate(
      widget.sources.length,
      (index) => Tween<double>(begin: 0, end: 1).animate(
        CurvedAnimation(
          parent: _controller,
          curve: Interval(
            index * 0.05,
            (index * 0.05) + 0.3,
            curve: Motion.enter,
          ),
        ),
      ),
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: widget.sources.length,
      itemBuilder: (context, index) {
        final source = widget.sources[index];
        final isFollowed = widget.followedSourceIds.contains(source.id);

        return AnimatedBuilder(
          animation: _animations[index],
          builder: (context, child) {
            return FadeTransition(
              opacity: _animations[index],
              child: SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(0.2, 0),
                  end: Offset.zero,
                ).animate(_animations[index]),
                child: _SourceTile(
                  source: source,
                  isFollowed: isFollowed,
                  onFollow: () => widget.onFollow?.call(source.id),
                  onUnfollow: () => widget.onUnfollow?.call(source.id),
                ),
              ),
            );
          },
        );
      },
    );
  }
}

class _SourceTile extends StatelessWidget {
  final Source source;
  final bool isFollowed;
  final VoidCallback? onFollow;
  final VoidCallback? onUnfollow;

  const _SourceTile({
    required this.source,
    this.isFollowed = false,
    this.onFollow,
    this.onUnfollow,
  });

  @override
  Widget build(BuildContext context) {
    final tokens = Theme.of(context).brightness == Brightness.dark
        ? darkTokens
        : lightTokens;

    return Card(
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: tokens.accent.withValues(alpha: 0.1),
          child: Text(
            source.name[0],
            style: TextStyle(
              color: tokens.accent,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        title: Text(source.name),
        subtitle: Text(
          source.url,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: tokens.inkSecondary,
              ),
          overflow: TextOverflow.ellipsis,
        ),
        trailing: AnimatedSwitcher(
          duration: Motion.normal,
          child: isFollowed
              ? Chip(
                  key: const ValueKey('followed'),
                  label: const Text('Following'),
                  backgroundColor: tokens.accent.withValues(alpha: 0.1),
                  side: BorderSide(color: tokens.accent.withValues(alpha: 0.3)),
                  onDeleted: onUnfollow,
                )
              : OutlinedButton(
                  key: const ValueKey('follow'),
                  onPressed: onFollow,
                  child: const Text('Follow'),
                ),
        ),
      ),
    );
  }
}
