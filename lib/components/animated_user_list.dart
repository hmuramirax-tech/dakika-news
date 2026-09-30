import 'package:flutter/material.dart';
import 'package:dakika/theme/tokens.dart';

/// Animated user list with staggered entrance.
class AnimatedUserList extends StatefulWidget {
  final List<Map<String, dynamic>> users;
  final String? emptyMessage;

  const AnimatedUserList({
    super.key,
    required this.users,
    this.emptyMessage,
  });

  @override
  State<AnimatedUserList> createState() => _AnimatedUserListState();
}

class _AnimatedUserListState extends State<AnimatedUserList>
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
      widget.users.length,
      (index) => Tween<double>(begin: 0, end: 1).animate(
        CurvedAnimation(
          parent: _controller,
          curve: Interval(
            index * 0.1,
            (index * 0.1) + 0.3,
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
    if (widget.users.isEmpty) {
      return Card(
        child: Padding(
          padding: const EdgeInsets.all(Space.lg),
          child: Center(
            child: Text(
              widget.emptyMessage ?? 'No users yet.',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
            ),
          ),
        ),
      );
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: widget.users.length,
      itemBuilder: (context, index) {
        final user = widget.users[index];

        return AnimatedBuilder(
          animation: _animations[index],
          builder: (context, child) {
            return FadeTransition(
              opacity: _animations[index],
              child: SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(0, 0.1),
                  end: Offset.zero,
                ).animate(_animations[index]),
                child: Card(
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor:
                          Theme.of(context).colorScheme.primaryContainer,
                      child: Text(
                        user['name']?[0] ?? '?',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                    ),
                    title: Text(user['name'] ?? 'User'),
                    subtitle: Text(user['email'] ?? ''),
                    trailing: Chip(
                      label: Text(
                        user['status']?.toString().toUpperCase() ?? 'ACTIVE',
                        style: const TextStyle(fontSize: 10),
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
