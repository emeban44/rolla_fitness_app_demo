import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:rolla_fitness_app_demo/core/error/failures.dart';
import 'package:rolla_fitness_app_demo/features/scores/domain/entities/score/score.dart';
import 'package:rolla_fitness_app_demo/features/scores/domain/entities/score_history_point/score_history_point.dart';
import 'package:rolla_fitness_app_demo/features/scores/domain/entities/insight/insight.dart';
import 'package:rolla_fitness_app_demo/features/scores/domain/enums/timeframe.dart';
import 'package:rolla_fitness_app_demo/features/scores/domain/enums/score_type.dart';

part 'score_detail_state.freezed.dart';

@freezed
class ScoreDetailState with _$ScoreDetailState {
  const factory ScoreDetailState.initial() = _Initial;
  const factory ScoreDetailState.loading({
    required ScoreType scoreType,
    required Timeframe timeframe,
    required DateTime selectedDate,
  }) = _Loading;
  const factory ScoreDetailState.loaded({
    required Score score,
    required List<ScoreHistoryPoint> history,
    required List<Insight> insights,
    required Timeframe timeframe,
    required ScoreType scoreType,
    required DateTime selectedDate,
  }) = _Loaded;
  const factory ScoreDetailState.error({
    required Failure failure,
    required ScoreType scoreType,
    required Timeframe timeframe,
    required DateTime selectedDate,
  }) = _Error;
}
