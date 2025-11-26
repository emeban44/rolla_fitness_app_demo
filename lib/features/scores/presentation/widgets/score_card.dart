import 'package:flutter/material.dart';
import 'package:rolla_fitness_app_demo/features/scores/domain/enums/score_type.dart';
import 'package:rolla_fitness_app_demo/features/scores/presentation/widgets/radial_gauge.dart';

/// Reusable score card widget displaying a score with radial gauge
/// Used on both home page and detail page
/// Shows "N/A" when score is null (missing data)
class ScoreCard extends StatelessWidget {
  final ScoreType scoreType;
  final int? score;
  final VoidCallback? onTap;

  const ScoreCard({
    super.key,
    required this.scoreType,
    required this.score,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(0.0),
          child: LayoutBuilder(
            builder: (context, constraints) {
              // Calculate gauge size based on available space
              final availableHeight = constraints.maxHeight;
              final gaugeSize = (availableHeight * 0.65).clamp(80.0, 180.0);

              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Score type title
                  Text(
                    scoreType.displayName,
                    style: Theme.of(context).textTheme.titleSmall,
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  // Radial gauge
                  Flexible(
                    child: RadialGauge(
                      score: score,
                      color: scoreType.accentColor,
                      size: gaugeSize,
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
