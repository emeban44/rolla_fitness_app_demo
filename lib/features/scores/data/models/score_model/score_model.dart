import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:rolla_fitness_app_demo/features/scores/domain/entities/score/score.dart';
import 'package:rolla_fitness_app_demo/features/scores/domain/enums/score_type.dart';
import 'package:rolla_fitness_app_demo/features/scores/data/models/metric_model/metric_model.dart';

part 'score_model.freezed.dart';
part 'score_model.g.dart';

@Freezed(fromJson: true, toJson: true)
class ScoreModel with _$ScoreModel {
  const factory ScoreModel({
    required String type,
    required int? value,
    required List<MetricModel> metrics,
  }) = _ScoreModel;

  const ScoreModel._();

  factory ScoreModel.fromJson(Map<String, dynamic> json) =>
      _$ScoreModelFromJson(json);

  /// Convert to domain entity
  Score toDomain() {
    return Score(
      type: ScoreType.fromString(type),
      value: value,
      metrics: metrics.map((m) => m.toDomain()).toList(),
    );
  }

  /// Create from domain entity
  factory ScoreModel.fromDomain(Score score) {
    return ScoreModel(
      type: score.type.name,
      value: score.value,
      metrics: score.metrics.map((m) => MetricModel.fromDomain(m)).toList(),
    );
  }
}
