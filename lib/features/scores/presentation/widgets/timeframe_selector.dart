import 'package:flutter/material.dart';
import 'package:rolla_fitness_app_demo/features/scores/domain/entities/timeframe.dart';

/// Timeframe selector widget with 1D, 7D, 30D, 1Y tabs
class TimeframeSelector extends StatelessWidget {
  final Timeframe selectedTimeframe;
  final ValueChanged<Timeframe> onTimeframeChanged;

  const TimeframeSelector({
    super.key,
    required this.selectedTimeframe,
    required this.onTimeframeChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          TimeframeTab(
            timeframe: Timeframe.oneDay,
            label: '1D',
            isSelected: selectedTimeframe == Timeframe.oneDay,
            onTap: () => onTimeframeChanged(Timeframe.oneDay),
          ),
          TimeframeTab(
            timeframe: Timeframe.sevenDays,
            label: '7D',
            isSelected: selectedTimeframe == Timeframe.sevenDays,
            onTap: () => onTimeframeChanged(Timeframe.sevenDays),
          ),
          TimeframeTab(
            timeframe: Timeframe.thirtyDays,
            label: '30D',
            isSelected: selectedTimeframe == Timeframe.thirtyDays,
            onTap: () => onTimeframeChanged(Timeframe.thirtyDays),
          ),
          TimeframeTab(
            timeframe: Timeframe.oneYear,
            label: '1Y',
            isSelected: selectedTimeframe == Timeframe.oneYear,
            onTap: () => onTimeframeChanged(Timeframe.oneYear),
          ),
        ],
      ),
    );
  }
}

/// Individual timeframe tab
class TimeframeTab extends StatelessWidget {
  final Timeframe timeframe;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const TimeframeTab({
    super.key,
    required this.timeframe,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final textColor = isSelected
        ? Theme.of(context).textTheme.bodyLarge?.color
        : Theme.of(context).textTheme.bodyMedium?.color?.withValues(alpha: 0.5);

    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: isSelected
                    ? Theme.of(context).textTheme.bodyLarge?.color ??
                        Colors.black
                    : Colors.transparent,
                width: 2,
              ),
            ),
          ),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: textColor,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                ),
          ),
        ),
      ),
    );
  }
}
