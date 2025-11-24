/// Enum representing different timeframes for score history
enum Timeframe {
  oneDay('1D', 1),
  sevenDays('7D', 7),
  thirtyDays('30D', 30),
  oneYear('1Y', 365);

  final String label;
  final int days;

  const Timeframe(this.label, this.days);

  /// Whether this timeframe shows averages instead of totals
  bool get showsAverage => this != Timeframe.oneDay;

  /// Get API key for JSON data
  String get apiKey {
    switch (this) {
      case Timeframe.oneDay:
        return '1d';
      case Timeframe.sevenDays:
        return '7d';
      case Timeframe.thirtyDays:
        return '30d';
      case Timeframe.oneYear:
        return '1y';
    }
  }

  /// Parse from string
  static Timeframe fromString(String value) {
    return Timeframe.values.firstWhere(
      (e) => e.label.toLowerCase() == value.toLowerCase(),
      orElse: () => Timeframe.oneDay,
    );
  }
}
