import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:rolla_fitness_app_demo/core/theme/theme_extensions.dart';
import 'package:rolla_fitness_app_demo/features/scores/domain/entities/score_history_point/score_history_point.dart';

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

    // Aggregate data for 1Y view to improve readability
    final displayData = _getProcessedData();

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
              rightTitles: AxisTitles(
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
              ),
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  getTitlesWidget: (value, meta) {
                    final index = value.toInt();

                    // Only show labels at specific intervals
                    if (!_shouldShowLabel(index, displayData.length)) {
                      return const SizedBox.shrink();
                    }

                    if (index >= 0 && index < displayData.length) {
                      final date = displayData[index].date;
                      final label = _getXAxisLabel(date, index, displayData.length);
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
              ),
            ),
            gridData: FlGridData(
              show: true,
              drawVerticalLine: false,
              horizontalInterval: 25,
              getDrawingHorizontalLine: (value) {
                return FlLine(
                  color: context.colors.gridLine,
                  strokeWidth: 1,
                );
              },
            ),
            extraLinesData: ExtraLinesData(
              horizontalLines: [
                HorizontalLine(y: 0, color: context.colors.gridLine, strokeWidth: 1),
                HorizontalLine(y: 100, color: context.colors.gridLine, strokeWidth: 1),
              ],
            ),
            borderData: FlBorderData(show: false),
            barGroups: displayData.asMap().entries.map((entry) {
              final index = entry.key;
              final point = entry.value;
              return BarChartGroupData(
                x: index,
                barRods: [
                  BarChartRodData(
                    toY: point.value?.toDouble() ?? 0,
                    color: point.value != null ? color : Colors.transparent,
                    width: _getBarWidth(displayData.length),
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(4),
                      topRight: Radius.circular(4),
                    ),
                  ),
                ],
              );
            }).toList(),
          ),
        ),
      ),
    );
  }

  /// Get processed data - aggregate for 1Y view, use original for others
  List<ScoreHistoryPoint> _getProcessedData() {
    if (historyPoints.length > 60) {
      // Aggregate to monthly data for year view
      return _aggregateToMonthly();
    }
    return historyPoints;
  }

  /// Aggregate data into monthly buckets
  List<ScoreHistoryPoint> _aggregateToMonthly() {
    if (historyPoints.isEmpty) return [];

    // Group existing points by year-month
    final Map<String, List<ScoreHistoryPoint>> monthlyBuckets = {};

    for (final point in historyPoints) {
      final monthKey = '${point.date.year}-${point.date.month.toString().padLeft(2, '0')}';
      monthlyBuckets.putIfAbsent(monthKey, () => []).add(point);
    }

    // Generate all 12 months going back from today
    final List<ScoreHistoryPoint> monthlyData = [];
    final today = DateTime.now();
    final currentMonth = DateTime(today.year, today.month, 1);

    // Generate 12 months going backwards
    for (int i = 11; i >= 0; i--) {
      final month = DateTime(currentMonth.year, currentMonth.month - i, 1);
      final monthKey = '${month.year}-${month.month.toString().padLeft(2, '0')}';

      if (monthlyBuckets.containsKey(monthKey)) {
        // Month has data - calculate average
        final points = monthlyBuckets[monthKey]!;
        final validPoints = points.where((p) => p.value != null).toList();

        if (validPoints.isEmpty) {
          monthlyData.add(ScoreHistoryPoint(date: month, value: null));
        } else {
          final sum = validPoints.fold<double>(0, (sum, point) => sum + point.value!);
          final average = sum / validPoints.length;
          monthlyData.add(ScoreHistoryPoint(date: month, value: average.round()));
        }
      } else {
        // Month has no data - add empty entry
        monthlyData.add(ScoreHistoryPoint(date: month, value: null));
      }
    }

    return monthlyData;
  }

  /// Get bar width based on original data count
  double _getBarWidth(int displayCount) {
    final originalCount = historyPoints.length;
    if (originalCount <= 7) {
      return 16; // Wider bars for 7D
    } else if (originalCount <= 30) {
      return 5; // Thinner bars for 30D
    } else {
      return 12; // Wider bars for 1Y (monthly aggregated, ~12 bars)
    }
  }

  /// Check if label should be shown at this index
  bool _shouldShowLabel(int index, int displayCount) {
    final originalCount = historyPoints.length;
    if (originalCount <= 7) {
      return true; // Show all labels for 7D
    } else if (originalCount <= 30) {
      // Show labels every 3rd day and the last one
      return index % 3 == 0 || index == displayCount - 1;
    } else {
      // Show all month labels for 1Y (monthly aggregated)
      return true;
    }
  }

  /// Get X-axis label based on timeframe
  String _getXAxisLabel(DateTime date, int index, int displayCount) {
    final originalCount = historyPoints.length;
    if (originalCount <= 7) {
      // 7D: Show day of week (Mon, Tue, etc.)
      return DateFormat('E').format(date);
    } else if (originalCount <= 30) {
      // 30D: Show day number (1, 7, 13, 19, 25)
      return DateFormat('d').format(date);
    } else {
      // 1Y: Show month (Jan, Feb, etc.)
      return DateFormat('MMM').format(date);
    }
  }
}
