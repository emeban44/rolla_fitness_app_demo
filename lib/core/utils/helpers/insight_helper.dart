import 'package:rolla_fitness_app_demo/core/utils/helpers/date_time_helper.dart';
import 'package:rolla_fitness_app_demo/features/scores/domain/entities/insight/insight.dart';

/// Helper functions for working with insights
class InsightHelper {
  InsightHelper._();

  /// Get insight for a specific date
  static Insight? getInsightForDate(List<Insight> insights, DateTime date) {
    final dateStr = DateTimeHelper.formatToISO8601Date(date);
    return insights.where((i) => i.id.endsWith(dateStr)).firstOrNull;
  }
}
