import 'package:flutter/material.dart';
import 'package:dakika/theme/tokens.dart';

/// Animated search bar with focus expansion.
class AnimatedSearchBar extends StatefulWidget {
  final String hintText;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onClear;

  const AnimatedSearchBar({
    super.key,
    this.hintText = 'Search...',
    this.onChanged,
    this.onClear,
  });

  @override
  State<AnimatedSearchBar> createState() => _AnimatedSearchBarState();
}

class _AnimatedSearchBarState extends State<AnimatedSearchBar>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _widthAnimation;
  final _focusNode = FocusNode();
  final _textController = TextEditingController();
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Motion.normal,
    );
    _widthAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Motion.inOut),
    );

    _focusNode.addListener(() {
      setState(() {
        _isFocused = _focusNode.hasFocus;
        if (_isFocused) {
          _controller.forward();
        } else {
          _controller.reverse();
        }
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final tokens = Theme.of(context).brightness == Brightness.dark
        ? darkTokens
        : lightTokens;

    return AnimatedContainer(
      duration: Motion.normal,
      curve: Motion.inOut,
      decoration: BoxDecoration(
        color: tokens.surface,
        borderRadius: BorderRadius.circular(Radii.md),
        border: Border.all(
          color: _isFocused ? tokens.accent : tokens.rule,
        ),
        boxShadow: _isFocused
            ? [
                BoxShadow(
                  color: tokens.accent.withValues(alpha: 0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ]
            : null,
      ),
      child: TextField(
        controller: _textController,
        focusNode: _focusNode,
        onChanged: widget.onChanged,
        decoration: InputDecoration(
          hintText: widget.hintText,
          prefixIcon: Icon(
            Icons.search,
            color: _isFocused ? tokens.accent : tokens.inkSecondary,
          ),
          suffixIcon: _textController.text.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    _textController.clear();
                    widget.onClear?.call();
                    setState(() {});
                  },
                )
              : null,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: Space.md,
            vertical: Space.md,
          ),
        ),
      ),
    );
  }
}
