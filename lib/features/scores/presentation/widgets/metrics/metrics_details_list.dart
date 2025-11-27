import 'package:flutter/material.dart';
import 'package:rolla_fitness_app_demo/core/theme/theme_extensions.dart';
import 'package:rolla_fitness_app_demo/features/scores/domain/entities/metric/metric.dart';
import 'package:rolla_fitness_app_demo/features/scores/presentation/widgets/metrics/metric_detail_tile.dart';

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
            color: context.colors.shadowLight,
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
          return MetricDetailTile(metric: metric);
        },
      ),
    );
  }

  /// Get a slightly darker background color than scaffold
  Color _getDarkerBackgroundColor(BuildContext context) {
    final scaffoldColor = Theme.of(context).scaffoldBackgroundColor;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Create a slightly different background by blending
    final blendColor = isDark
        ? Colors.white.withValues(alpha: 0.05)
        : Colors.black.withValues(alpha: 0.01);
    return Color.alphaBlend(blendColor, scaffoldColor);
  }
}
