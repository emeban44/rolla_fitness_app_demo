import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:rolla_fitness_app_demo/core/theme/app_typography.dart';
import 'package:rolla_fitness_app_demo/core/theme/theme_extensions.dart';

/// Neumorphic circular radial gauge showing score 0-100
/// Shows "N/A" when score is null (missing data)
class RadialGauge extends StatelessWidget {
  final int? score;
  final Color color;
  final double size;

  const RadialGauge({
    super.key,
    required this.score,
    required this.color,
    this.size = 200,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: Container(
        width: size * 0.65,
        height: size * 0.65,
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
        child: TweenAnimationBuilder<double>(
          tween: Tween<double>(
            begin: score?.toDouble() ?? 0,
            end: score?.toDouble() ?? 0,
          ),
          duration: const Duration(milliseconds: 600),
          curve: Curves.easeInOut,
          builder: (context, animatedValue, child) {
            final displayScore = score == null ? null : animatedValue.round();
            return CustomPaint(
              painter: ArcPainter(
                context: context,
                score: displayScore,
                color: color,
                strokeWidth: 6,
              ),
              child: Center(
                child: Text(
                  displayScore?.toString() ?? 'N/A',
                  style: AppTypography.scoreValueLarge(context),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

/// Painter for the colored arc showing score with background track
class ArcPainter extends CustomPainter {
  final BuildContext context;
  final int? score;
  final Color color;
  final double strokeWidth;

  ArcPainter({
    required this.context,
    required this.score,
    required this.color,
    required this.strokeWidth,
  });

  @override
  void paint(Canvas canvas, Size size) {
    const padding = 13.3; // Padding from container edge to progress bar
    final rect = Rect.fromLTWH(
      padding,
      padding,
      size.width - (padding * 2),
      size.height - (padding * 2),
    );

    // Background track color (same as dots)
    final backgroundTrackColor = context.colors.gridLine;

    // Draw full circle background track (unfinished progress)
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

    // Only draw colored arc if score is available (not null)
    final scoreValue = score;
    if (scoreValue != null) {
      final progressPaint = Paint()
        ..color = color
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth
        ..strokeCap = StrokeCap.round;

      const startAngle = -math.pi / 2; // Start at top
      final sweepAngle = 2 * math.pi * (scoreValue / 100); // Score percentage

      canvas.drawArc(
        rect,
        startAngle,
        sweepAngle,
        false,
        progressPaint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant ArcPainter oldDelegate) {
    return oldDelegate.score != score ||
        oldDelegate.color != color ||
        Theme.of(oldDelegate.context).brightness != Theme.of(context).brightness;
  }
}
