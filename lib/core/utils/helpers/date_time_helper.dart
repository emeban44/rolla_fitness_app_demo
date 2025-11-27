/// Helper class for date and time related utilities
class DateTimeHelper {
  DateTimeHelper._();

  /// Format date to YYYY-MM-DD string
  ///
  /// Example:
  /// ```dart
  /// DateTimeHelper.formatToISO8601Date(DateTime(2025, 1, 5))
  /// // Returns: "2025-01-05"
  /// ```
  static String formatToISO8601Date(DateTime date) {
    return '${date.year.toString().padLeft(4, '0')}-'
        '${date.month.toString().padLeft(2, '0')}-'
        '${date.day.toString().padLeft(2, '0')}';
  }

  /// Normalize a DateTime to midnight (removes time component)
  ///
  /// Example:
  /// ```dart
  /// DateTimeHelper.normalizeToMidnight(DateTime(2025, 1, 5, 14, 30))
  /// // Returns: DateTime(2025, 1, 5, 0, 0, 0)
  /// ```
  static DateTime normalizeToMidnight(DateTime date) {
    return DateTime(date.year, date.month, date.day);
  }
}
