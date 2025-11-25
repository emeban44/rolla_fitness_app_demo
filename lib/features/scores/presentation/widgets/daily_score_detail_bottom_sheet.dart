import 'package:flutter/material.dart';
import 'package:rolla_fitness_app_demo/features/scores/domain/entities/metric.dart';
import 'package:rolla_fitness_app_demo/features/scores/domain/entities/metric_info.dart';
import 'package:rolla_fitness_app_demo/features/scores/presentation/widgets/radial_gauge.dart';

/// Bottom sheet showing daily score details with metrics and info
class DailyScoreDetailBottomSheet extends StatelessWidget {
  final String scoreTitle;
  final int? scoreValue;
  final Color scoreColor;
  final List<Metric> metrics;
  final MetricInfo? info;

  const DailyScoreDetailBottomSheet({
    super.key,
    required this.scoreTitle,
    required this.scoreValue,
    required this.scoreColor,
    required this.metrics,
    this.info,
  });

  /// Show the bottom sheet
  static void show({
    required BuildContext context,
    required String scoreTitle,
    required int? scoreValue,
    required Color scoreColor,
    required List<Metric> metrics,
    MetricInfo? info,
  }) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DailyScoreDetailBottomSheet(
        scoreTitle: scoreTitle,
        scoreValue: scoreValue,
        scoreColor: scoreColor,
        metrics: metrics,
        info: info,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.85,
      ),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    scoreTitle,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close),
                ),
              ],
            ),
          ),

          Flexible(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Radial gauge
                  Center(
                    child: RadialGauge(
                      score: scoreValue,
                      color: scoreColor,
                      size: 160,
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Metrics section
                  Text(
                    'Metrics',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 12),
                  ...metrics.map((metric) => MetricInfoRow(metric: metric)),
                  const SizedBox(height: 24),

                  // How It Works section
                  if (info != null) ...[
                    Text(
                      'How It Works?',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      info!.description,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Theme.of(context)
                                .textTheme
                                .bodySmall
                                ?.color
                                ?.withValues(alpha: 0.7),
                            height: 1.5,
                          ),
                    ),
                    if (info!.baselineInfo != null) ...[
                      const SizedBox(height: 12),
                      Text(
                        info!.baselineInfo!,
                        style:
                            Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  color: Theme.of(context)
                                      .textTheme
                                      .bodySmall
                                      ?.color
                                      ?.withValues(alpha: 0.7),
                                  height: 1.5,
                                ),
                      ),
                    ],
                  ],
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Individual metric info row in the bottom sheet
class MetricInfoRow extends StatelessWidget {
  final Metric metric;

  const MetricInfoRow({
    super.key,
    required this.metric,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          // Icon
          if (metric.icon != null) ...[
            Text(
              metric.icon!,
              style: const TextStyle(fontSize: 20),
            ),
            const SizedBox(width: 12),
          ],
          // Metric name
          Expanded(
            child: Text(
              metric.title,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
          // Value
          Text(
            metric.displayValue,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context)
                      .textTheme
                      .bodySmall
                      ?.color
                      ?.withValues(alpha: 0.6),
                ),
          ),
          const SizedBox(width: 8),
          // Star icon
          const Icon(Icons.star, size: 16),
          const SizedBox(width: 4),
          // Score
          Text(
            metric.score?.toString() ?? '-',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
          ),
        ],
      ),
    );
  }
}
