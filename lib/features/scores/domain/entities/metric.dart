import 'package:freezed_annotation/freezed_annotation.dart';

part 'metric.freezed.dart';

/// Metric entity representing a single metric (e.g., Sleep, Steps)
@freezed
class Metric with _$Metric {
  const factory Metric({
    required String id,
    required String title,
    required String displayValue,
    required int? score, // null for "No data"
  }) = _Metric;

  const Metric._();

  /// Check if metric has data
  bool get hasData => score != null;
}
