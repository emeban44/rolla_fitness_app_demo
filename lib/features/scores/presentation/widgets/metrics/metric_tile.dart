import 'package:flutter/material.dart';
import 'package:rolla_fitness_app_demo/core/theme/app_colors.dart';
import 'package:rolla_fitness_app_demo/core/theme/theme_extensions.dart';
import 'package:rolla_fitness_app_demo/core/utils/helpers/metric_helper.dart';
import 'package:rolla_fitness_app_demo/features/scores/domain/entities/metric/metric.dart';

/// Metric tile widget showing icon, name, value, and progress bar
class MetricTile extends StatelessWidget {
  final Metric metric;
  final bool showAvgLabel;
  final VoidCallback? onTap;

  const MetricTile({
    super.key,
    required this.metric,
    this.showAvgLabel = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final progressColor = metric.hasData ? AppColors.getScoreColor(metric.score) : AppColors.scoreNeutral;

    final icon = MetricHelper.getIconForMetric(metric.id);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: context.colors.shadowLight,
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                // Icon
                if (icon != null)
                  Text(
                    icon,
                    style: const TextStyle(fontSize: 24),
                  ),
                if (icon != null) const SizedBox(width: 12),
                // Metric name
                Expanded(
                  child: Text(
                    metric.title,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                // Value
                Text(
                  metric.hasData ? metric.displayValue : 'No data',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            TweenAnimationBuilder<double>(
              tween: Tween<double>(
                begin: (metric.score ?? 0) / 100,
                end: (metric.score ?? 0) / 100,
              ),
              duration: const Duration(milliseconds: 600),
              curve: Curves.easeInOut,
              builder: (context, animatedValue, child) {
                return ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(4),
                    topRight: Radius.circular(4),
                  ),
                  child: LinearProgressIndicator(
                    value: animatedValue,
                    backgroundColor: context.colors.gridLine,
                    valueColor: AlwaysStoppedAnimation<Color>(progressColor),
                    minHeight: 6,
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
