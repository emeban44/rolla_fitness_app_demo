import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:rolla_fitness_app_demo/core/theme/theme_extensions.dart';
import 'package:rolla_fitness_app_demo/features/scores/domain/entities/score_history_point/score_history_point.dart';
import 'package:rolla_fitness_app_demo/features/scores/utils/helpers/trend_chart_helper.dart';

/// Bar chart widget for displaying score history
class TrendChart extends StatelessWidget {
  final List<ScoreHistoryPoint> historyPoints;
  final Color color;

  const TrendChart({
    super.key,
    required this.historyPoints,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    if (historyPoints.isEmpty) {
      return const SizedBox(
        height: 200,
        child: Center(child: Text('No data available')),
      );
    }

    final displayData = TrendChartHelper.processData(historyPoints);

    return SizedBox(
      height: 250,
      child: Padding(
        padding: const EdgeInsets.only(left: 16, right: 8, top: 16),
        child: BarChart(
          BarChartData(
            alignment: BarChartAlignment.spaceAround,
            maxY: 100,
            minY: 0,
            barTouchData: BarTouchData(enabled: false),
            titlesData: FlTitlesData(
              show: true,
              topTitles: const AxisTitles(
                sideTitles: SideTitles(showTitles: false),
              ),
              leftTitles: const AxisTitles(
                sideTitles: SideTitles(showTitles: false),
              ),
              rightTitles: _RightAxisTitles.build(context),
              bottomTitles: _BottomAxisTitles.build(
                context,
                displayData: displayData,
                originalDataCount: historyPoints.length,
              ),
            ),
            gridData: _buildGridData(context),
            extraLinesData: _buildExtraLines(context),
            borderData: FlBorderData(show: false),
            barGroups: _buildBarGroups(displayData),
          ),
        ),
      ),
    );
  }

  /// Builds grid configuration
  FlGridData _buildGridData(BuildContext context) {
    return FlGridData(
      show: true,
      drawVerticalLine: false,
      horizontalInterval: 25,
      getDrawingHorizontalLine: (value) {
        return FlLine(
          color: context.colors.gridLine,
          strokeWidth: 1,
        );
      },
    );
  }

  /// Builds extra horizontal lines (top and bottom borders)
  ExtraLinesData _buildExtraLines(BuildContext context) {
    return ExtraLinesData(
      horizontalLines: [
        HorizontalLine(y: 0, color: context.colors.gridLine, strokeWidth: 1),
        HorizontalLine(y: 100, color: context.colors.gridLine, strokeWidth: 1),
      ],
    );
  }

  /// Builds bar groups from display data
  List<BarChartGroupData> _buildBarGroups(List<ScoreHistoryPoint> displayData) {
    return displayData.asMap().entries.map((entry) {
      final index = entry.key;
      final point = entry.value;
      return BarChartGroupData(
        x: index,
        barRods: [
          BarChartRodData(
            toY: point.value?.toDouble() ?? 0,
            color: point.value != null ? color : Colors.transparent,
            width: _getBarWidth(),
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(4),
              topRight: Radius.circular(4),
            ),
          ),
        ],
      );
    }).toList();
  }

  /// Calculates bar width based on timeframe
  double _getBarWidth() {
    final dataCount = historyPoints.length;

    // Weekly view: wider bars for better visibility
    if (dataCount <= 7) return 16;

    // Monthly view: thinner bars to fit more data
    if (dataCount <= 30) return 5;

    // Yearly view: medium bars (data is aggregated to ~12 months)
    return 12;
  }
}

/// Private widget for right axis titles (Y-axis values)
class _RightAxisTitles {
  static AxisTitles build(BuildContext context) {
    return AxisTitles(
      sideTitles: SideTitles(
        showTitles: true,
        reservedSize: 50,
        interval: 25,
        getTitlesWidget: (value, meta) {
          return Padding(
            padding: const EdgeInsets.only(left: 8),
            child: Text(
              value.toInt().toString(),
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: context.colors.foregroundSubtle,
              ),
            ),
          );
        },
      ),
    );
  }
}

/// Private widget for bottom axis titles (X-axis date labels)
class _BottomAxisTitles {
  static AxisTitles build(
    BuildContext context, {
    required List<ScoreHistoryPoint> displayData,
    required int originalDataCount,
  }) {
    return AxisTitles(
      sideTitles: SideTitles(
        showTitles: true,
        getTitlesWidget: (value, meta) {
          final index = value.toInt();

          // Only show labels at specific intervals
          if (!_shouldShowLabel(index, displayData.length, originalDataCount)) {
            return const SizedBox.shrink();
          }

          if (index >= 0 && index < displayData.length) {
            final date = displayData[index].date;
            final label = TrendChartHelper.formatXAxisLabel(date, originalDataCount);
            return Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Text(
                label,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  fontSize: 11,
                  color: context.colors.foregroundSubtle,
                ),
              ),
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }

  static bool _shouldShowLabel(int index, int displayCount, int originalDataCount) {
    // Weekly view: show all labels (7 days total)
    if (originalDataCount <= 7) return true;

    // Monthly view: show every 3rd label + last one to avoid crowding
    final isEveryThird = index % 3 == 0;
    final isLastLabel = index == displayCount - 1;
    if (originalDataCount <= 30) return isEveryThird || isLastLabel;

    // Yearly view: show all labels (~12 months, already aggregated)
    return true;
  }
}
