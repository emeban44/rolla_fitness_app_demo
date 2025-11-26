import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:rolla_fitness_app_demo/features/scores/domain/entities/score_history_point/score_history_point.dart';

part 'score_history_point_model.freezed.dart';
part 'score_history_point_model.g.dart';

@Freezed(fromJson: true, toJson: true)
class ScoreHistoryPointModel with _$ScoreHistoryPointModel {
  const factory ScoreHistoryPointModel({
    required String date,
    int? value,
  }) = _ScoreHistoryPointModel;

  const ScoreHistoryPointModel._();

  factory ScoreHistoryPointModel.fromJson(Map<String, dynamic> json) =>
      _$ScoreHistoryPointModelFromJson(json);

  /// Convert to domain entity
  ScoreHistoryPoint toDomain() {
    return ScoreHistoryPoint(
      date: DateTime.parse(date),
      value: value,
    );
  }

  /// Create from domain entity
  factory ScoreHistoryPointModel.fromDomain(ScoreHistoryPoint point) {
    return ScoreHistoryPointModel(
      date: point.date.toIso8601String(),
      value: point.value,
    );
  }
}
