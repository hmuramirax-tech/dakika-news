import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:dakika/theme/tokens.dart';

/// The 60-Second Ring — OneNews' signature element.
/// A circular progress indicator that fills as the user reads.
class SixtySecondRing extends StatefulWidget {
  final double progress; // 0.0 to 1.0
  final double size;
  final double strokeWidth;
  final bool showLabel;
  final String? label;

  const SixtySecondRing({
    super.key,
    required this.progress,
    this.size = 44,
    this.strokeWidth = 3,
    this.showLabel = true,
    this.label,
  });

  @override
  State<SixtySecondRing> createState() => _SixtySecondRingState();
}

class _SixtySecondRingState extends State<SixtySecondRing>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Motion.slow,
    );
    _animation = Tween<double>(begin: 0, end: widget.progress).animate(
      CurvedAnimation(parent: _controller, curve: Motion.enter),
    );
    _controller.forward();
  }

  @override
  void didUpdateWidget(SixtySecondRing oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.progress != widget.progress) {
      _animation = Tween<double>(
        begin: _animation.value,
        end: widget.progress,
      ).animate(CurvedAnimation(parent: _controller, curve: Motion.inOut));
      _controller
        ..reset()
        ..forward();
    }
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
      animation: _animation,
      builder: (context, child) {
        return SizedBox(
          width: widget.size,
          height: widget.size,
          child: Stack(
            alignment: Alignment.center,
            children: [
              CustomPaint(
                size: Size(widget.size, widget.size),
                painter: _RingPainter(
                  progress: _animation.value,
                  strokeWidth: widget.strokeWidth,
                  trackColor: tokens.rule,
                  progressColor: _getColorForProgress(_animation.value, tokens),
                ),
              ),
              if (widget.showLabel)
                Text(
                  widget.label ?? '${(_animation.value * 100).round()}%',
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        fontSize: 10,
                        color: tokens.inkSecondary,
                      ),
                ),
            ],
          ),
        );
      },
    );
  }

  Color _getColorForProgress(double progress, AppTokens tokens) {
    if (progress >= 1.0) return tokens.accent;
    if (progress > 0.0) return tokens.accent;
    return tokens.rule;
  }
}

class _RingPainter extends CustomPainter {
  final double progress;
  final double strokeWidth;
  final Color trackColor;
  final Color progressColor;

  _RingPainter({
    required this.progress,
    required this.strokeWidth,
    required this.trackColor,
    required this.progressColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - strokeWidth) / 2;

    // Track
    final trackPaint = Paint()
      ..color = trackColor
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;
    canvas.drawCircle(center, radius, trackPaint);

    // Progress arc
    if (progress > 0) {
      final progressPaint = Paint()
        ..color = progressColor
        ..strokeWidth = strokeWidth
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round;

      final sweepAngle = 2 * math.pi * progress;
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        -math.pi / 2,
        sweepAngle,
        false,
        progressPaint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _RingPainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.trackColor != trackColor ||
        oldDelegate.progressColor != progressColor;
  }
}
