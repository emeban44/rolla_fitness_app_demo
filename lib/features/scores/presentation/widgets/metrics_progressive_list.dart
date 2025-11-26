import 'package:flutter/material.dart';
import 'package:rolla_fitness_app_demo/features/scores/domain/entities/metric/metric.dart';
import 'package:rolla_fitness_app_demo/features/scores/domain/enums/score_type.dart';
import 'package:rolla_fitness_app_demo/features/scores/domain/enums/timeframe.dart';
import 'package:rolla_fitness_app_demo/features/scores/presentation/pages/score_detail_page.dart';
import 'package:rolla_fitness_app_demo/features/scores/presentation/widgets/metric_tile.dart';

/// Progressive metrics list with tiles showing progress bars
class MetricsProgressiveList extends StatelessWidget {
  final List<Metric> metrics;
  final Timeframe timeframe;
  final ScoreType scoreType;

  const MetricsProgressiveList({
    super.key,
    required this.metrics,
    required this.timeframe,
    required this.scoreType,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: metrics.map((metric) {
        // Make Readiness and Activity metrics tappable on Health page
        final isNavigatable = scoreType == ScoreType.health &&
            (metric.title.toLowerCase() == 'readiness' ||
                metric.title.toLowerCase() == 'activity');

        return MetricTile(
          metric: metric,
          showAvgLabel: timeframe != Timeframe.oneDay,
          onTap: isNavigatable
              ? () {
                  final targetScoreType =
                      metric.title.toLowerCase() == 'readiness'
                          ? ScoreType.readiness
                          : ScoreType.activity;
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ScoreDetailPage(
                        scoreType: targetScoreType,
                      ),
                    ),
                  );
                }
              : null,
        );
      }).toList(),
    );
  }
}
