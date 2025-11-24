import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:rolla_fitness_app_demo/core/error/failures.dart';
import 'package:rolla_fitness_app_demo/features/scores/domain/entities/score.dart';
import 'package:rolla_fitness_app_demo/features/scores/domain/entities/score_history_point.dart';
import 'package:rolla_fitness_app_demo/features/scores/domain/entities/insight.dart';
import 'package:rolla_fitness_app_demo/features/scores/domain/entities/timeframe.dart';
import 'package:rolla_fitness_app_demo/features/scores/domain/entities/score_type.dart';

part 'score_detail_state.freezed.dart';

@freezed
class ScoreDetailState with _$ScoreDetailState {
  const factory ScoreDetailState.initial() = _Initial;
  const factory ScoreDetailState.loading() = _Loading;
  const factory ScoreDetailState.loaded({
    required Score score,
    required List<ScoreHistoryPoint> history,
    required List<Insight> insights,
    required Timeframe timeframe,
    required ScoreType scoreType,
  }) = _Loaded;
  const factory ScoreDetailState.error(Failure failure) = _Error;
}
