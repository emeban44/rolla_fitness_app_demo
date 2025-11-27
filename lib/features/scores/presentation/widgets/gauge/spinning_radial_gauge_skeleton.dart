import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:rolla_fitness_app_demo/core/theme/theme_extensions.dart';

/// A spinning radial gauge skeleton for loading states
/// Looks like a radial gauge that's spinning/loading
/// Perfect for showing loading while maintaining the visual structure
class SpinningRadialGaugeSkeleton extends StatefulWidget {
  final double size;
  final Color? color;

  const SpinningRadialGaugeSkeleton({
    super.key,
    this.size = 200,
    this.color,
  });

  @override
  State<SpinningRadialGaugeSkeleton> createState() => _SpinningRadialGaugeSkeletonState();
}

class _SpinningRadialGaugeSkeletonState extends State<SpinningRadialGaugeSkeleton> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final baseColor = widget.color ?? context.colors.skeletonBase;

    return SizedBox(
      width: widget.size,
      height: widget.size,
      child: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Theme.of(context).scaffoldBackgroundColor,
          boxShadow: [
            BoxShadow(
              color: context.colors.shadowMedium,
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
            BoxShadow(
              color: context.colors.shadowStrong,
              blurRadius: 20,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return CustomPaint(
              painter: _SpinningArcPainter(
                context: context,
                progress: _controller.value,
                color: baseColor,
                strokeWidth: 6,
              ),
              child: Center(
                child: _ShimmeringText(
                  controller: _controller,
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

/// Shimmer effect for the score text during loading
class _ShimmeringText extends StatelessWidget {
  final AnimationController controller;

  const _ShimmeringText({
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        final shimmerValue = (math.sin(controller.value * 2 * math.pi) + 1) / 2;
        final opacity = 0.2 + (shimmerValue * 0.4); // Oscillate between 0.2 and 0.6

        return Container(
          width: 50,
          height: 30,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: context.colors.decorativeWithOpacity(opacity),
          ),
        );
      },
    );
  }
}

/// Painter for the spinning arc
class _SpinningArcPainter extends CustomPainter {
  final BuildContext context;
  final double progress;
  final Color color;
  final double strokeWidth;

  _SpinningArcPainter({
    required this.context,
    required this.progress,
    required this.color,
    required this.strokeWidth,
  });

  @override
  void paint(Canvas canvas, Size size) {
    const padding = 6.0;
    final rect = Rect.fromLTWH(
      padding,
      padding,
      size.width - (padding * 2),
      size.height - (padding * 2),
    );

    // Background track
    final backgroundTrackColor = context.colors.gridLine;

    final backgroundPaint = Paint()
      ..color = backgroundTrackColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    canvas.drawCircle(
      Offset(size.width / 2, size.height / 2),
      (size.width - (padding * 2)) / 2,
      backgroundPaint,
    );

    // Spinning arc
    final spinningPaint = Paint()
      ..shader = SweepGradient(
        colors: [
          color.withValues(alpha: 0.0),
          color.withValues(alpha: 0.3),
          color.withValues(alpha: 0.8),
          color.withValues(alpha: 0.3),
          color.withValues(alpha: 0.0),
        ],
        stops: const [0.0, 0.25, 0.5, 0.75, 1.0],
        transform: GradientRotation(progress * 2 * math.pi),
      ).createShader(rect)
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    canvas.drawCircle(
      Offset(size.width / 2, size.height / 2),
      (size.width - (padding * 2)) / 2,
      spinningPaint,
    );
  }

  @override
  bool shouldRepaint(covariant _SpinningArcPainter oldDelegate) {
    return oldDelegate.progress != progress || oldDelegate.color != color;
  }
}
