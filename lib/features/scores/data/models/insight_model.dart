import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:rolla_fitness_app_demo/features/scores/domain/entities/insight.dart';

part 'insight_model.freezed.dart';
part 'insight_model.g.dart';

@Freezed(fromJson: true, toJson: true)
class InsightModel with _$InsightModel {
  const factory InsightModel({
    required String id,
    required String text,
    required String type,
  }) = _InsightModel;

  const InsightModel._();

  factory InsightModel.fromJson(Map<String, dynamic> json) =>
      _$InsightModelFromJson(json);

  /// Convert to domain entity
  Insight toDomain() {
    return Insight(
      id: id,
      text: text,
      type: _parseInsightType(type),
    );
  }

  /// Create from domain entity
  factory InsightModel.fromDomain(Insight insight) {
    return InsightModel(
      id: insight.id,
      text: insight.text,
      type: insight.type.name,
    );
  }

  static InsightType _parseInsightType(String type) {
    switch (type.toLowerCase()) {
      case 'info':
        return InsightType.info;
      case 'warning':
        return InsightType.warning;
      case 'suggestion':
        return InsightType.suggestion;
      default:
        return InsightType.info;
    }
  }
}
