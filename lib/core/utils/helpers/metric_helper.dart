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
}
