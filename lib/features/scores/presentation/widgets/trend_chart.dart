import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:rolla_fitness_app_demo/features/scores/domain/entities/score_history_point.dart';

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
                          color: Theme.of(context).textTheme.bodySmall?.color?.withValues(alpha: 0.6),
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
                    if (!_shouldShowLabel(index)) {
                      return const SizedBox.shrink();
                    }

                    if (index >= 0 && index < historyPoints.length) {
                      final date = historyPoints[index].date;
                      final label = _getXAxisLabel(date, index);
                      return Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: Text(
                          label,
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            fontSize: 11,
                            color: Theme.of(context).textTheme.bodySmall?.color?.withValues(alpha: 0.6),
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
                  color: _getGridLineColor(context),
                  strokeWidth: 1,
                );
              },
            ),
            extraLinesData: ExtraLinesData(
              horizontalLines: [
                _createHorizontalLine(0, context),
                _createHorizontalLine(100, context),
              ],
            ),
            borderData: FlBorderData(show: false),
            barGroups: historyPoints.asMap().entries.map((entry) {
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
            }).toList(),
          ),
        ),
      ),
    );
  }

  /// Get bar width based on number of data points
  double _getBarWidth() {
    final count = historyPoints.length;
    if (count <= 7) {
      return 16; // Wider bars for 7D
    } else if (count <= 30) {
      return 6; // Thinner bars for 30D
    } else {
      return 3; // Very thin bars for 1Y
    }
  }

  /// Check if label should be shown at this index
  bool _shouldShowLabel(int index) {
    final count = historyPoints.length;
    if (count <= 7) {
      return true; // Show all labels for 7D
    } else if (count <= 30) {
      // Show labels at indices: 0, 5, 10, 15, 20, 25
      return index % 5 == 0;
    } else {
      // Show labels every 60 days for 1Y
      return index % 60 == 0;
    }
  }

  /// Get X-axis label based on timeframe
  String _getXAxisLabel(DateTime date, int index) {
    final count = historyPoints.length;
    if (count <= 7) {
      // 7D: Show day of week (Mon, Tue, etc.)
      return DateFormat('E').format(date);
    } else if (count <= 30) {
      // 30D: Show day number (1, 7, 13, 19, 25)
      return DateFormat('d').format(date);
    } else {
      // 1Y: Show month (Jan, Feb, etc.)
      return DateFormat('MMM').format(date);
    }
  }

  /// Get grid line color based on theme
  Color _getGridLineColor(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? Colors.white.withValues(alpha: 0.1)
        : Colors.grey.withValues(alpha: 0.2);
  }

  /// Create horizontal line at specified y-value
  HorizontalLine _createHorizontalLine(double y, BuildContext context) {
    return HorizontalLine(
      y: y,
      color: _getGridLineColor(context),
      strokeWidth: 1,
    );
  }
}
