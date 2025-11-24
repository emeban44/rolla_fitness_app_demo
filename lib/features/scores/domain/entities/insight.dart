import 'package:freezed_annotation/freezed_annotation.dart';

part 'insight.freezed.dart';

/// Types of insights
enum InsightType {
  info,
  warning,
  suggestion;
}

/// Insight entity for contextual information
@freezed
class Insight with _$Insight {
  const factory Insight({
    required String id,
    required String text,
    required InsightType type,
  }) = _Insight;
}
