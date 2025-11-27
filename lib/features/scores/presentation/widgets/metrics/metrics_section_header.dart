import 'package:flutter/material.dart';
import 'package:rolla_fitness_app_demo/core/theme/theme_extensions.dart';
import 'package:rolla_fitness_app_demo/core/widgets/section/section_title.dart';

/// Metrics section header with optional "Daily Avg." label
class MetricsSectionHeader extends StatelessWidget {
  final bool showDailyAvgLabel;

  const MetricsSectionHeader({
    super.key,
    this.showDailyAvgLabel = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          const SectionTitle(title: 'Metrics'),
          const Spacer(),
          if (showDailyAvgLabel)
            Text(
              'Daily Avg.',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: context.colors.foregroundSubtle,
              ),
            ),
        ],
      ),
    );
  }
}
