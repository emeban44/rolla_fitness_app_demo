import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:rolla_fitness_app_demo/features/scores/domain/entities/score_type.dart';
import 'package:rolla_fitness_app_demo/features/scores/domain/entities/metric.dart';

part 'score.freezed.dart';

/// Score entity representing a score (Health, Readiness, or Activity)
@freezed
class Score with _$Score {
  const factory Score({
    required ScoreType type,
    required int value,
    required List<Metric> metrics,
  }) = _Score;

  const Score._();

  /// Get display name
  String get displayName => type.displayName;
}
