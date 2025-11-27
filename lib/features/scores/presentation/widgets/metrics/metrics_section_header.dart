import 'package:flutter/material.dart';
import 'package:rolla_fitness_app_demo/core/theme/theme_extensions.dart';
import 'package:rolla_fitness_app_demo/core/widgets/section/section_title.dart';
import 'package:rolla_fitness_app_demo/features/scores/domain/enums/timeframe.dart';

/// Metrics section header with optional "Daily Avg." label
class MetricsSectionHeader extends StatelessWidget {
  final Timeframe timeframe;

  const MetricsSectionHeader({
    super.key,
    required this.timeframe,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          const SectionTitle(title: 'Metrics'),
          const Spacer(),
          if (timeframe != Timeframe.oneDay)
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
