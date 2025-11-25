import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:rolla_fitness_app_demo/features/scores/domain/entities/score_type.dart';
import 'package:rolla_fitness_app_demo/features/scores/presentation/widgets/radial_gauge.dart';

/// Gauge with ripple dotted background
/// Focused only on displaying the gauge with visual background effect
class DetailScoreGaugeSection extends StatelessWidget {
  final ScoreType scoreType;
  final int score;

  const DetailScoreGaugeSection({
    super.key,
    required this.scoreType,
    required this.score,
  });

  @override
  Widget build(BuildContext context) {
    const gaugeSize = 140.0;

    return SizedBox(
      width: double.infinity,
      height: 280, // Fixed height for consistent sizing
      child: Stack(
        children: [
          // Ripple dotted background centered
          Positioned.fill(
            child: CustomPaint(
              painter: RippleDottedBackgroundPainter(
                isDark: Theme.of(context).brightness == Brightness.dark,
              ),
            ),
          ),

          // Gauge centered
          Center(
            child: RadialGauge(
              score: score,
              color: scoreType.accentColor,
              size: gaugeSize,
            ),
          ),
        ],
      ),
    );
  }
}

/// Custom painter for ripple/wavelength dotted background
class RippleDottedBackgroundPainter extends CustomPainter {
  final bool isDark;

  RippleDottedBackgroundPainter({
    required this.isDark,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // Center the ripple
    final center = Offset(size.width / 2, size.height / 2);

    // Create many concentric circles of dots (ripple effect)
    const circleCount = 20; // Number of concentric circles
    const dotsPerCircle = 28; // Dots per circle
    const dotRadius = 2.5;

    for (int circleIndex = 0; circleIndex < circleCount; circleIndex++) {
      // Calculate alpha - aggressive fade in first 6 circles
      final baseAlpha = isDark ? 0.15 : 0.22;
      final fadeProgress = (circleIndex / 6.0).clamp(0.0, 1.0);
      final alpha = (baseAlpha * (1 - fadeProgress)).clamp(0.01, 1.0);

      // Create paint with progressive fade
      final paint = Paint()
        ..color = isDark ? Colors.white.withValues(alpha: alpha) : Colors.grey.withValues(alpha: alpha)
        ..style = PaintingStyle.fill;

      // Each circle gets progressively larger
      final circleRadius = 80.0 + (circleIndex * 30.0);
      final dotsInThisCircle = dotsPerCircle + (circleIndex * 4);

      for (int dotIndex = 0; dotIndex < dotsInThisCircle; dotIndex++) {
        final angle = (dotIndex * 2 * math.pi / dotsInThisCircle);
        final x = center.dx + circleRadius * math.cos(angle);
        final y = center.dy + circleRadius * math.sin(angle);

        // Only draw if within bounds
        if (x >= 0 && x <= size.width && y >= 0 && y <= size.height) {
          canvas.drawCircle(Offset(x, y), dotRadius, paint);
        }
      }
    }
  }

  @override
  bool shouldRepaint(covariant RippleDottedBackgroundPainter oldDelegate) {
    return oldDelegate.isDark != isDark;
  }
}
