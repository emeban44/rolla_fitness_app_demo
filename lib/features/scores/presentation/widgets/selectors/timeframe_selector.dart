import 'package:flutter/material.dart';
import 'package:rolla_fitness_app_demo/core/theme/theme_extensions.dart';
import 'package:rolla_fitness_app_demo/features/scores/domain/enums/timeframe.dart';

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
    final timeframes = [
      Timeframe.oneDay,
      Timeframe.sevenDays,
      Timeframe.thirtyDays,
      Timeframe.oneYear,
    ];
    final selectedIndex = timeframes.indexOf(selectedTimeframe);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Stack(
        children: [
          // Base border for all tabs
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              height: 2,
              color: Theme.of(context).dividerColor,
            ),
          ),
          // Sliding indicator bar
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: LayoutBuilder(
              builder: (context, constraints) {
                final tabWidth = constraints.maxWidth / 4;
                return AnimatedAlign(
                  duration: const Duration(milliseconds: 250),
                  curve: Curves.easeInOut,
                  alignment: Alignment(-1 + (selectedIndex * 2 / 3), 0),
                  child: Container(
                    width: tabWidth,
                    height: 2,
                    color: context.colors.foregroundPrimary,
                  ),
                );
              },
            ),
          ),
          // Tabs
          Row(
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
        ? context.colors.foregroundPrimary
        : context.colors.foregroundSubtle;

    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: AnimatedDefaultTextStyle(
            duration: const Duration(milliseconds: 200),
            style:
                Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: textColor,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                ) ??
                const TextStyle(),
            child: Text(
              label,
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
  }
}
