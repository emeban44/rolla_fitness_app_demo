import 'package:flutter/material.dart';
import 'package:rolla_fitness_app_demo/core/widgets/section/section_title.dart';
import 'package:rolla_fitness_app_demo/features/scores/presentation/widgets/selectors/time_period_selector.dart';
import 'package:rolla_fitness_app_demo/features/scores/domain/enums/timeframe.dart';

/// Reusable score header with title, optional info icon, and time period selector
class ScoreHeader extends StatelessWidget {
  final String title;
  final VoidCallback? onInfoTap;
  final DateTime selectedDate;
  final Timeframe timeframe;
  final VoidCallback onPrevious;
  final VoidCallback onNext;
  final bool canGoNext;

  const ScoreHeader({
    super.key,
    required this.title,
    this.onInfoTap,
    required this.selectedDate,
    required this.timeframe,
    required this.onPrevious,
    required this.onNext,
    required this.canGoNext,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 4, 0),
      child: Row(
        children: [
          SectionTitle(
            title: title,
            onInfoTap: onInfoTap,
          ),
          const Spacer(),
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
