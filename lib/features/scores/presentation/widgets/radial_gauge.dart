import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:rolla_fitness_app_demo/core/theme/app_typography.dart';

/// Neumorphic circular radial gauge showing score 0-100
class RadialGauge extends StatelessWidget {
  final int score;
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
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Dotted background pattern
          CustomPaint(
            size: Size(size, size),
            painter: DottedBackgroundPainter(
              isDark: Theme.of(context).brightness == Brightness.dark,
            ),
          ),
          // Neumorphic circle with arc
          Container(
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
                  offset: const Offset(0, -10),
                ),
              ],
            ),
            child: CustomPaint(
              painter: ArcPainter(
                score: score,
                color: color,
                strokeWidth: 8,
              ),
              child: Center(
                child: Text(
                  score.toString(),
                  style: AppTypography.scoreValueLarge(context),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Painter for the dotted background pattern
class DottedBackgroundPainter extends CustomPainter {
  final bool isDark;

  DottedBackgroundPainter({required this.isDark});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = isDark
          ? Colors.white.withValues(alpha: 0.1)
          : Colors.grey.withValues(alpha: 0.2)
      ..style = PaintingStyle.fill;

    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    // Draw dots in circular pattern
    const dotCount = 24;
    const dotRadius = 3.0;

    for (int i = 0; i < dotCount; i++) {
      final angle = (i * 2 * math.pi / dotCount) - math.pi / 2;
      final x = center.dx + radius * 0.85 * math.cos(angle);
      final y = center.dy + radius * 0.85 * math.sin(angle);
      canvas.drawCircle(Offset(x, y), dotRadius, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// Painter for the colored arc showing score
class ArcPainter extends CustomPainter {
  final int score;
  final Color color;
  final double strokeWidth;

  ArcPainter({
    required this.score,
    required this.color,
    required this.strokeWidth,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Rect.fromLTWH(0, 0, size.width, size.height);
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    // Draw arc from top (270 degrees) clockwise
    const startAngle = -math.pi / 2; // Start at top
    final sweepAngle = 2 * math.pi * (score / 100); // Score percentage

    canvas.drawArc(
      rect.deflate(strokeWidth / 2),
      startAngle,
      sweepAngle,
      false,
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant ArcPainter oldDelegate) {
    return oldDelegate.score != score || oldDelegate.color != color;
  }
}
