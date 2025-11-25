import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:rolla_fitness_app_demo/features/scores/domain/entities/metric.dart';

part 'metric_model.freezed.dart';
part 'metric_model.g.dart';

@Freezed(fromJson: true, toJson: true)
class MetricModel with _$MetricModel {
  const factory MetricModel({
    required String id,
    required String title,
    required String displayValue,
    required int? score,
  }) = _MetricModel;

  const MetricModel._();

  factory MetricModel.fromJson(Map<String, dynamic> json) => _$MetricModelFromJson(json);

  /// Convert to domain entity
  Metric toDomain() {
    return Metric(
      id: id,
      title: title,
      displayValue: displayValue,
      score: score,
    );
  }

  /// Create from domain entity
  factory MetricModel.fromDomain(Metric metric) {
    return MetricModel(
      id: metric.id,
      title: metric.title,
      displayValue: metric.displayValue,
      score: metric.score,
    );
  }
}
