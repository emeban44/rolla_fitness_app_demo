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

  Future<void> loadScoreDetail(
    ScoreType scoreType,
    Timeframe timeframe, {
    DateTime? selectedDate,
  }) async {
    final date = selectedDate ?? DateTime.now();
    emit(const ScoreDetailState.loading());

    final (
      Either<Failure, Score> scoreResult,
      Either<Failure, List<ScoreHistoryPoint>?> historyResult,
      Either<Failure, List<Insight>?> insightsResult,
    ) = await (
      getScoreDetail(scoreType, timeframe, date),
      getScoreHistory(scoreType, timeframe, date),
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
        selectedDate: date,
      ),
    );
  }

  Future<void> changeTimeframe(Timeframe newTimeframe) async {
    state.maybeWhen(
      loaded: (score, history, insights, timeframe, scoreType, selectedDate) {
        // Always reset to today when changing timeframe
        loadScoreDetail(scoreType, newTimeframe, selectedDate: DateTime.now());
      },
      orElse: () {},
    );
  }

  Future<void> refresh() async {
    state.maybeWhen(
      loaded: (score, history, insights, timeframe, scoreType, selectedDate) {
        loadScoreDetail(scoreType, timeframe, selectedDate: selectedDate);
      },
      orElse: () {},
    );
  }

  /// Navigate to the previous period based on current timeframe
  Future<void> navigatePrevious() async {
    state.maybeWhen(
      loaded: (score, history, insights, timeframe, scoreType, selectedDate) {
        final newDate = _calculatePreviousDate(selectedDate, timeframe);
        loadScoreDetail(scoreType, timeframe, selectedDate: newDate);
      },
      orElse: () {},
    );
  }

  /// Navigate to the next period based on current timeframe
  Future<void> navigateNext() async {
    state.maybeWhen(
      loaded: (score, history, insights, timeframe, scoreType, selectedDate) {
        final newDate = _calculateNextDate(selectedDate, timeframe);
        loadScoreDetail(scoreType, timeframe, selectedDate: newDate);
      },
      orElse: () {},
    );
  }

  /// Calculate the previous date based on timeframe
  DateTime _calculatePreviousDate(DateTime currentDate, Timeframe timeframe) {
    switch (timeframe) {
      case Timeframe.oneDay:
        return currentDate.subtract(const Duration(days: 1));
      case Timeframe.sevenDays:
        return currentDate.subtract(const Duration(days: 7));
      case Timeframe.thirtyDays:
        return currentDate.subtract(const Duration(days: 30));
      case Timeframe.oneYear:
        return DateTime(currentDate.year - 1, currentDate.month, currentDate.day);
    }
  }

  /// Calculate the next date based on timeframe
  DateTime _calculateNextDate(DateTime currentDate, Timeframe timeframe) {
    switch (timeframe) {
      case Timeframe.oneDay:
        return currentDate.add(const Duration(days: 1));
      case Timeframe.sevenDays:
        return currentDate.add(const Duration(days: 7));
      case Timeframe.thirtyDays:
        return currentDate.add(const Duration(days: 30));
      case Timeframe.oneYear:
        return DateTime(currentDate.year + 1, currentDate.month, currentDate.day);
    }
  }

  /// Check if we can navigate to the next period (not beyond today)
  bool canNavigateNext() {
    return state.maybeWhen(
      loaded: (score, history, insights, timeframe, scoreType, selectedDate) {
        final today = DateTime.now();
        // Normalize both dates to start of day for comparison
        final normalizedToday = DateTime(today.year, today.month, today.day);
        final normalizedSelected = DateTime(selectedDate.year, selectedDate.month, selectedDate.day);
        return normalizedSelected.isBefore(normalizedToday);
      },
      orElse: () => false,
    );
  }
}
