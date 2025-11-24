import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:rolla_fitness_app_demo/features/scores/domain/entities/metric_info.dart';

part 'metric_info_model.freezed.dart';
part 'metric_info_model.g.dart';

@Freezed(fromJson: true, toJson: true)
class MetricInfoModel with _$MetricInfoModel {
  const factory MetricInfoModel({
    required String title,
    required String description,
    String? baselineInfo,
  }) = _MetricInfoModel;

  const MetricInfoModel._();

  factory MetricInfoModel.fromJson(Map<String, dynamic> json) =>
      _$MetricInfoModelFromJson(json);

  /// Convert to domain entity
  MetricInfo toDomain() {
    return MetricInfo(
      title: title,
      description: description,
      baselineInfo: baselineInfo,
    );
  }

  /// Create from domain entity
  factory MetricInfoModel.fromDomain(MetricInfo info) {
    return MetricInfoModel(
      title: info.title,
      description: info.description,
      baselineInfo: info.baselineInfo,
    );
  }
}
