import 'package:freezed_annotation/freezed_annotation.dart';

part 'metric_info.freezed.dart';

/// Metric information for info drawer
@freezed
class MetricInfo with _$MetricInfo {
  const factory MetricInfo({
    required String title,
    required String description,
    String? baselineInfo,
  }) = _MetricInfo;
}
