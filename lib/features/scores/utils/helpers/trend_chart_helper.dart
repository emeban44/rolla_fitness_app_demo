import 'package:intl/intl.dart';
import 'package:rolla_fitness_app_demo/features/scores/domain/entities/score_history_point/score_history_point.dart';

/// Helper class for trend chart data processing and calculations
class TrendChartHelper {
  /// Processes history points - aggregates to monthly for year view, returns original for others
  static List<ScoreHistoryPoint> processData(List<ScoreHistoryPoint> historyPoints) {
    if (historyPoints.length > 60) {
      // Aggregate to monthly data for year view
      return aggregateToMonthly(historyPoints);
    }
    return historyPoints;
  }

  /// Aggregates data into monthly buckets with complete 12-month view
  static List<ScoreHistoryPoint> aggregateToMonthly(List<ScoreHistoryPoint> historyPoints) {
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

      final points = monthlyBuckets[monthKey];
      if (points != null && points.isNotEmpty) {
        // Month has data - calculate average
        final validValues = points
            .map((p) => p.value)
            .whereType<int>()
            .toList();

        if (validValues.isEmpty) {
          monthlyData.add(ScoreHistoryPoint(date: month, value: null));
        } else {
          final sum = validValues.fold<int>(0, (sum, value) => sum + value);
          final average = sum / validValues.length;
          monthlyData.add(ScoreHistoryPoint(date: month, value: average.round()));
        }
      } else {
        // Month has no data - add empty entry
        monthlyData.add(ScoreHistoryPoint(date: month, value: null));
      }
    }

    return monthlyData;
  }

  /// Formats X-axis label based on timeframe
  static String formatXAxisLabel(DateTime date, int originalDataCount) {
    if (originalDataCount <= 7) {
      // 7D: Show day of week (Mon, Tue, etc.)
      return DateFormat('E').format(date);
    } else if (originalDataCount <= 30) {
      // 30D: Show day number (1, 7, 13, 19, 25)
      return DateFormat('d').format(date);
    } else {
      // 1Y: Show month (Jan, Feb, etc.)
      return DateFormat('MMM').format(date);
    }
  }
}
