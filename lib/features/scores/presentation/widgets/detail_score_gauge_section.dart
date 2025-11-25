import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
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
    const gaugeSize = 140.0;
    const gaugeTopOffset = 110.0;

    return SizedBox(
      width: double.infinity,
      child: Stack(
        children: [
          // Ripple dotted background centered on gauge
          Positioned.fill(
            child: CustomPaint(
              painter: RippleDottedBackgroundPainter(
                isDark: Theme.of(context).brightness == Brightness.dark,
                gaugeCenterOffset: gaugeTopOffset + (gaugeSize / 2),
              ),
            ),
          ),

          // Content overlaid on background
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top row: Title + Info | Timeframe/Date
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
                child: Row(
                  children: [
                    // Title with info icon
                    Text(
                      scoreType.displayName,
                      style: GoogleFonts.outfit(
                        fontSize: 20,
                        fontWeight: FontWeight.w400,
                        height: 1.0,
                        letterSpacing: 0,
                        color: Theme.of(context).textTheme.bodyLarge?.color,
                      ),
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
                            color: Theme.of(context).textTheme.bodySmall?.color?.withValues(alpha: 0.1),
                          ),
                          child: Icon(
                            Icons.help_outline,
                            size: 18,
                            color: Theme.of(context).textTheme.bodySmall?.color?.withValues(alpha: 0.6),
                          ),
                        ),
                      ),
                    const Spacer(),
                    // Timeframe selector or date
                    if (topRightWidget != null) topRightWidget!,
                  ],
                ),
              ),

              // Subtitle
              if (subtitle != null)
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
                  child: Text(
                    subtitle!,
                    style: GoogleFonts.outfit(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      height: 1.0,
                      letterSpacing: 0,
                      color: Theme.of(
                        context,
                      ).textTheme.bodyLarge?.color?.withValues(alpha: 0.6),
                    ),
                  ),
                ),

              const SizedBox(height: 32),

              // Gauge at fixed position
              Center(
                child: RadialGauge(
                  score: score,
                  color: scoreType.accentColor,
                  size: gaugeSize,
                ),
              ),

              // Description text
              const SizedBox(height: 32),
              if (description != null) ...[
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Text(
                    description!,
                    style: GoogleFonts.outfit(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      height: 1.0,
                      letterSpacing: 0,
                      color: Theme.of(context).textTheme.bodyLarge?.color,
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(
                  height: 32.0,
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}

/// Custom painter for ripple/wavelength dotted background
class RippleDottedBackgroundPainter extends CustomPainter {
  final bool isDark;
  final double gaugeCenterOffset; // Y offset where gauge is centered

  RippleDottedBackgroundPainter({
    required this.isDark,
    required this.gaugeCenterOffset,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // Center the ripple on the gauge position
    final center = Offset(size.width / 2, gaugeCenterOffset);

    // Create many concentric circles of dots (ripple effect - feels infinite)
    const circleCount = 20; // Number of concentric circles
    const dotsPerCircle = 28; // Dots per circle
    const dotRadius = 2.5;

    for (int circleIndex = 0; circleIndex < circleCount; circleIndex++) {
      // Calculate alpha - aggressive fade in first 6 circles, barely visible after
      final baseAlpha = isDark ? 0.15 : 0.22;
      final fadeProgress = (circleIndex / 6.0).clamp(0.0, 1.0);
      final alpha = (baseAlpha * (1 - fadeProgress)).clamp(0.01, 1.0);

      // Create paint with progressive fade
      final paint = Paint()
        ..color = isDark ? Colors.white.withValues(alpha: alpha) : Colors.grey.withValues(alpha: alpha)
        ..style = PaintingStyle.fill;

      // Each circle gets progressively larger, starting closer to gauge
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
    return oldDelegate.isDark != isDark || oldDelegate.gaugeCenterOffset != gaugeCenterOffset;
  }
}
