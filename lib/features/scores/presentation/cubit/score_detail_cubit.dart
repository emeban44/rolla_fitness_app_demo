import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:rolla_fitness_app_demo/core/error/failures.dart';
import 'package:rolla_fitness_app_demo/features/scores/domain/entities/score.dart';
import 'package:rolla_fitness_app_demo/features/scores/domain/entities/score_history_point.dart';
import 'package:rolla_fitness_app_demo/features/scores/domain/entities/insight.dart';
import 'package:rolla_fitness_app_demo/features/scores/domain/entities/score_type.dart';
import 'package:rolla_fitness_app_demo/features/scores/domain/entities/timeframe.dart';
import 'package:rolla_fitness_app_demo/features/scores/domain/usecases/get_score_detail.dart';
import 'package:rolla_fitness_app_demo/features/scores/domain/usecases/get_score_history.dart';
import 'package:rolla_fitness_app_demo/features/scores/domain/usecases/get_insights.dart';
import 'score_detail_state.dart';

@injectable
class ScoreDetailCubit extends Cubit<ScoreDetailState> {
  final GetScoreDetail getScoreDetail;
  final GetScoreHistory getScoreHistory;
  final GetInsights getInsights;

  ScoreDetailCubit(this.getScoreDetail, this.getScoreHistory, this.getInsights)
    : super(const ScoreDetailState.initial());

  Future<void> loadScoreDetail(ScoreType scoreType, Timeframe timeframe) async {
    emit(const ScoreDetailState.loading());

    final (
      Either<Failure, Score> scoreResult,
      Either<Failure, List<ScoreHistoryPoint>?> historyResult,
      Either<Failure, List<Insight>?> insightsResult,
    ) = await (
      getScoreDetail(scoreType, timeframe),
      getScoreHistory(scoreType, timeframe),
      getInsights(scoreType),
    ).wait;

    final score = scoreResult.fold(
      (failure) {
        emit(ScoreDetailState.error(failure));
        return null;
      },
      (success) => success,
    );
    if (score == null) return;

    final history = historyResult.fold(
      (failure) {
        emit(ScoreDetailState.error(failure));
        return null;
      },
      (success) => success,
    );
    if (history == null) return;

    final insights = insightsResult.fold(
      (failure) {
        emit(ScoreDetailState.error(failure));
        return null;
      },
      (success) => success,
    );
    if (insights == null) return;

    emit(
      ScoreDetailState.loaded(
        score: score,
        history: history,
        insights: insights,
        timeframe: timeframe,
        scoreType: scoreType,
      ),
    );
  }

  Future<void> changeTimeframe(Timeframe newTimeframe) async {
    state.maybeWhen(
      loaded: (score, history, insights, timeframe, scoreType) {
        loadScoreDetail(scoreType, newTimeframe);
      },
      orElse: () {},
    );
  }

  Future<void> refresh() async {
    state.maybeWhen(
      loaded: (score, history, insights, timeframe, scoreType) {
        loadScoreDetail(scoreType, timeframe);
      },
      orElse: () {},
    );
  }
}
