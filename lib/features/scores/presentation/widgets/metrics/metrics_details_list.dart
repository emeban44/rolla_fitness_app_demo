import 'package:flutter/material.dart';
import 'package:rolla_fitness_app_demo/core/theme/theme_extensions.dart';
import 'package:rolla_fitness_app_demo/core/utils/helpers/metric_helper.dart';
import 'package:rolla_fitness_app_demo/features/scores/domain/entities/metric/metric.dart';

/// Details metrics list with info rows in a card container
class MetricsDetailsList extends StatelessWidget {
  final List<Metric> metrics;

  const MetricsDetailsList({
    super.key,
    required this.metrics,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: _getDarkerBackgroundColor(context),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            spreadRadius: 2,
            offset: const Offset(0, 0),
          ),
        ],
      ),
      child: ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
        itemCount: metrics.length,
        separatorBuilder: (context, index) => Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Divider(
            height: 1,
            thickness: 1,
            color: Theme.of(context).dividerColor,
          ),
        ),
        itemBuilder: (context, index) {
          final metric = metrics[index];
          return _MetricInfoRow(metric: metric);
        },
      ),
    );
  }

  /// Get a slightly darker background color than scaffold
  Color _getDarkerBackgroundColor(BuildContext context) {
    final scaffoldColor = Theme.of(context).scaffoldBackgroundColor;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    if (isDark) {
      // In dark mode, make it slightly lighter by blending with white
      return Color.alphaBlend(
        Colors.white.withValues(alpha: 0.05),
        scaffoldColor,
      );
    } else {
      // In light mode, make it slightly darker by blending with black
      return Color.alphaBlend(
        Colors.black.withValues(alpha: 0.01),
        scaffoldColor,
      );
    }
  }
}

/// Individual metric info row
class _MetricInfoRow extends StatelessWidget {
  final Metric metric;

  const _MetricInfoRow({
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
