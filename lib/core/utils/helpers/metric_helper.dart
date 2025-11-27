/// Helper class for metric-related utilities
class MetricHelper {
  MetricHelper._();

  /// Get icon emoji for a given metric ID
  static String? getIconForMetric(String metricId) {
    switch (metricId.toLowerCase()) {
      case 'sleep':
        return '😴';
      case 'resting_hr':
        return '❤️';
      case 'hrv':
        return '💓';
      case 'active_points':
        return '⭐';
      case 'steps':
        return '👟';
      case 'move_hours':
        return '⏱️';
      case 'readiness':
        return '🌟';
      case 'activity':
        return '🏃';
      default:
        return null;
    }
  }

  /// Format metric ID to human-readable title
  ///
  /// Converts snake_case metric IDs to Title Case.
  ///
  /// Example:
  /// ```dart
  /// MetricHelper.formatMetricTitle('resting_hr')
  /// // Returns: "Resting Hr"
  /// ```
  static String formatMetricTitle(String metricId) {
    return metricId
        .split('_')
        .map((word) => word[0].toUpperCase() + word.substring(1))
        .join(' ');
  }
}
