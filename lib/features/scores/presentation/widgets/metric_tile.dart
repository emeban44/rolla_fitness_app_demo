import 'package:flutter/material.dart';
import 'package:rolla_fitness_app_demo/core/theme/app_colors.dart';
import 'package:rolla_fitness_app_demo/features/scores/domain/entities/metric.dart';

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
    final progressColor = metric.hasData
        ? AppColors.getScoreColor(metric.score)
        : AppColors.scoreNeutral;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
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
                if (metric.icon != null)
                  Text(
                    metric.icon!,
                    style: const TextStyle(fontSize: 24),
                  ),
                if (metric.icon != null) const SizedBox(width: 12),
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
            // Progress bar
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: metric.hasData ? (metric.score! / 100) : 0,
                backgroundColor: Theme.of(context).brightness == Brightness.dark
                    ? Colors.white.withValues(alpha: 0.1)
                    : Colors.grey.withValues(alpha: 0.2),
                valueColor: AlwaysStoppedAnimation<Color>(progressColor),
                minHeight: 6,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
