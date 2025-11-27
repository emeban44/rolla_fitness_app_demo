import 'package:flutter/material.dart';
import 'package:rolla_fitness_app_demo/features/scores/domain/entities/metric/metric.dart';
import 'package:rolla_fitness_app_demo/features/scores/domain/enums/score_type.dart';
import 'package:rolla_fitness_app_demo/features/scores/domain/enums/timeframe.dart';
import 'package:rolla_fitness_app_demo/features/scores/presentation/pages/score_detail_page.dart';
import 'package:rolla_fitness_app_demo/features/scores/presentation/widgets/metrics/metric_progressive_tile.dart';

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
      children: metrics.map(
        (metric) {
          return MetricProgressiveTile(
            metric: metric,
            showAvgLabel: timeframe != Timeframe.oneDay,
            onTap: _getNavigationCallback(context, metric),
          );
        },
      ).toList(),
    );
  }

  /// Get navigation callback for metric tile
  /// Only Readiness and Activity metrics are tappable on Health page
  VoidCallback? _getNavigationCallback(BuildContext context, Metric metric) {
    // Navigation from here is only possible for HealthPage.
    if (scoreType != ScoreType.health) return null;

    final targetScoreType = _getTargetScoreType(metric);
    if (targetScoreType == null) return null;

    return () => _navigateToScoreDetail(context, targetScoreType);
  }

  /// Get target score type from metric title
  ScoreType? _getTargetScoreType(Metric metric) {
    final title = metric.title.toLowerCase();
    if (title == 'readiness') return ScoreType.readiness;
    if (title == 'activity') return ScoreType.activity;
    return null;
  }

  /// Navigate to score detail page
  void _navigateToScoreDetail(BuildContext context, ScoreType scoreType) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ScoreDetailPage(scoreType: scoreType),
      ),
    );
  }
}
