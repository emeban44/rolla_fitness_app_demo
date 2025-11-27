/// App-wide dimension constants and calculations
class AppDimensions {
  AppDimensions._();

  /// Calculate gauge size based on available height
  static double calculateGaugeSize(double availableHeight) {
    return (availableHeight * 0.65).clamp(80.0, 180.0);
  }
}
