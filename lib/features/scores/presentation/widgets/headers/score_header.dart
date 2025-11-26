import 'package:flutter/material.dart';
import 'package:rolla_fitness_app_demo/core/widgets/section_title.dart';
import 'package:rolla_fitness_app_demo/features/scores/domain/enums/score_type.dart';
import 'package:rolla_fitness_app_demo/features/scores/presentation/widgets/selectors/time_period_selector.dart';
import 'package:rolla_fitness_app_demo/features/scores/domain/enums/timeframe.dart';

/// Reusable score header with title, info icon, and time period selector
/// Used consistently across all timeframes (1D, 7D, 30D, 1Y)
class ScoreHeader extends StatelessWidget {
  final ScoreType scoreType;
  final VoidCallback? onInfoTap;
  final DateTime selectedDate;
  final Timeframe timeframe;
  final VoidCallback onPrevious;
  final VoidCallback onNext;
  final bool canGoNext;

  const ScoreHeader({
    super.key,
    required this.scoreType,
    this.onInfoTap,
    required this.selectedDate,
    required this.timeframe,
    required this.onPrevious,
    required this.onNext,
    required this.canGoNext,
  });

  @override
  Widget build(BuildContext context) {
    // Show "History" without info icon for chart views (7D, 30D, 1Y)
    // Show score type name with info icon for gauge view (1D)
    final isChartView = timeframe != Timeframe.oneDay;
    final title = isChartView ? 'History' : scoreType.displayName;
    final showInfoIcon = !isChartView;

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 4, 0),
      child: Row(
        children: [
          // Title with optional info icon
          SectionTitle(
            title: title,
            onInfoTap: showInfoIcon ? onInfoTap : null,
          ),
          const Spacer(),
          // Time period selector
          TimePeriodSelector(
            selectedDate: selectedDate,
            timeframe: timeframe,
            onPrevious: onPrevious,
            onNext: onNext,
            canGoNext: canGoNext,
          ),
        ],
      ),
    );
  }
}
