import 'package:flutter/material.dart';
import 'package:rolla_fitness_app_demo/core/theme/theme_extensions.dart';
import 'package:rolla_fitness_app_demo/core/utils/helpers/metric_helper.dart';
import 'package:rolla_fitness_app_demo/features/scores/domain/entities/metric/metric.dart';

/// Metric detail tile showing name, icon, value, and score in a row format
class MetricDetailTile extends StatelessWidget {
  final Metric metric;

  const MetricDetailTile({
    super.key,
    required this.metric,
  });

  @override
  Widget build(BuildContext context) {
    final icon = MetricHelper.getIconForMetric(metric.id);

    return Row(
      children: [
        // Metric name
        Text(
          metric.title,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w500,
            fontSize: 15.0,
          ),
        ),
        // Icon (after name)
        if (icon != null) ...[
          const SizedBox(width: 8),
          Text(
            icon,
            style: const TextStyle(fontSize: 20),
          ),
        ],
        const Spacer(),
        // Value
        Text(
          metric.displayValue,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: context.colors.foregroundSubtle,
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
    );
  }
}
