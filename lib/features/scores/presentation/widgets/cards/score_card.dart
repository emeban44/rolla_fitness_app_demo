import 'package:flutter/material.dart';
import 'package:rolla_fitness_app_demo/core/constants/app_dimensions.dart';
import 'package:rolla_fitness_app_demo/core/widgets/cards/custom_card.dart';
import 'package:rolla_fitness_app_demo/features/scores/domain/enums/score_type.dart';
import 'package:rolla_fitness_app_demo/features/scores/presentation/widgets/gauge/radial_gauge.dart';

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
    return CustomCard(
      onTap: onTap,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final gaugeSize = AppDimensions.calculateGaugeSize(constraints.maxHeight);

          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                scoreType.displayName,
                style: Theme.of(context).textTheme.titleSmall,
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 8),
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
    );
  }
}
