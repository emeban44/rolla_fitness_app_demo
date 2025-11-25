import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:rolla_fitness_app_demo/features/scores/domain/entities/score_type.dart';
import 'package:rolla_fitness_app_demo/features/scores/presentation/widgets/radial_gauge.dart';

/// Detail page score gauge section with ripple dotted background
/// Includes title, subtitle, gauge, and description overlaid on the background
class DetailScoreGaugeSection extends StatelessWidget {
  final ScoreType scoreType;
  final int score;
  final String? subtitle;
  final String? description;
  final VoidCallback? onInfoTap;
  final Widget? topRightWidget; // For timeframe selector or date

  const DetailScoreGaugeSection({
    super.key,
    required this.scoreType,
    required this.score,
    this.subtitle,
    this.description,
    this.onInfoTap,
    this.topRightWidget,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 24),
      child: Stack(
        children: [
          // Ripple dotted background
          Positioned.fill(
            child: CustomPaint(
              painter: RippleDottedBackgroundPainter(
                isDark: Theme.of(context).brightness == Brightness.dark,
              ),
            ),
          ),
          // Content overlaid on background
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top row: Title + Info | Timeframe/Date
                Row(
                  children: [
                    // Title with info icon
                    Text(
                      scoreType.displayName,
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    const SizedBox(width: 8),
                    if (onInfoTap != null)
                      GestureDetector(
                        onTap: onInfoTap,
                        child: Container(
                          width: 32,
                          height: 32,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Theme.of(context)
                                .textTheme
                                .bodySmall
                                ?.color
                                ?.withValues(alpha: 0.1),
                          ),
                          child: Icon(
                            Icons.help_outline,
                            size: 18,
                            color: Theme.of(context)
                                .textTheme
                                .bodySmall
                                ?.color
                                ?.withValues(alpha: 0.6),
                          ),
                        ),
                      ),
                    const Spacer(),
                    // Timeframe selector or date
                    if (topRightWidget != null) topRightWidget!,
                  ],
                ),

                // Subtitle
                if (subtitle != null) ...[
                  const SizedBox(height: 8),
                  Text(
                    subtitle!,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: Theme.of(context)
                              .textTheme
                              .bodyMedium
                              ?.color
                              ?.withValues(alpha: 0.7),
                        ),
                  ),
                ],

                const SizedBox(height: 32),

                // Centered gauge
                Center(
                  child: RadialGauge(
                    score: score,
                    color: scoreType.accentColor,
                    size: 240,
                  ),
                ),

                // Description text
                if (description != null) ...[
                  const SizedBox(height: 32),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      description!,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            height: 1.5,
                          ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ],
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

  RippleDottedBackgroundPainter({required this.isDark});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = isDark
          ? Colors.white.withValues(alpha: 0.08)
          : Colors.grey.withValues(alpha: 0.15)
      ..style = PaintingStyle.fill;

    final center = Offset(size.width / 2, size.height / 2);

    // Create multiple concentric circles of dots (ripple effect)
    const circleCount = 6; // Number of concentric circles
    const dotsPerCircle = 32; // Dots per circle
    const dotRadius = 3.0;

    for (int circleIndex = 0; circleIndex < circleCount; circleIndex++) {
      // Each circle gets progressively larger
      final circleRadius = 60.0 + (circleIndex * 35.0);
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
