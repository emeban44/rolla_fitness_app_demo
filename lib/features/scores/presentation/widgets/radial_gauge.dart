import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:rolla_fitness_app_demo/core/theme/app_typography.dart';

/// Neumorphic circular radial gauge showing score 0-100
/// Shows "N/A" when score is null (missing data)
/// Clean, reusable widget without background decorations
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
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
            BoxShadow(
              color: Colors.white.withValues(alpha: 0.8),
              blurRadius: 20,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        child: CustomPaint(
          painter: ArcPainter(
            score: score,
            color: color,
            strokeWidth: 6,
            isDark: Theme.of(context).brightness == Brightness.dark,
          ),
          child: Center(
            child: Text(
              score?.toString() ?? 'N/A',
              style: AppTypography.scoreValueLarge(context),
            ),
          ),
        ),
      ),
    );
  }
}

/// Painter for the colored arc showing score with background track
class ArcPainter extends CustomPainter {
  final int? score;
  final Color color;
  final double strokeWidth;
  final bool isDark;

  ArcPainter({
    required this.score,
    required this.color,
    required this.strokeWidth,
    required this.isDark,
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
    final backgroundTrackColor = isDark
        ? Colors.white.withValues(alpha: 0.1)
        : Colors.grey.withValues(alpha: 0.2);

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
    if (score != null) {
      final progressPaint = Paint()
        ..color = color
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth
        ..strokeCap = StrokeCap.round;

      const startAngle = -math.pi / 2; // Start at top
      final sweepAngle = 2 * math.pi * (score! / 100); // Score percentage

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
        oldDelegate.isDark != isDark;
  }
}
