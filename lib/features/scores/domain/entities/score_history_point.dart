import 'package:freezed_annotation/freezed_annotation.dart';

part 'score_history_point.freezed.dart';

/// History point for chart data
@freezed
class ScoreHistoryPoint with _$ScoreHistoryPoint {
  const factory ScoreHistoryPoint({
    required DateTime date,
    int? value, // null for gaps in data
  }) = _ScoreHistoryPoint;
}
