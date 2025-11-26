import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:rolla_fitness_app_demo/core/error/failures.dart';
import 'package:rolla_fitness_app_demo/core/services/data_generation_service.dart';
import 'package:rolla_fitness_app_demo/features/scores/domain/entities/score/score.dart';
import 'package:rolla_fitness_app_demo/features/scores/domain/entities/score_history_point/score_history_point.dart';
import 'package:rolla_fitness_app_demo/features/scores/domain/entities/insight/insight.dart';
import 'package:rolla_fitness_app_demo/features/scores/domain/enums/score_type.dart';
import 'package:rolla_fitness_app_demo/features/scores/domain/enums/timeframe.dart';
import 'package:rolla_fitness_app_demo/features/scores/domain/usecases/get_score_detail.dart';
import 'package:rolla_fitness_app_demo/features/scores/domain/usecases/get_score_history.dart';
import 'package:rolla_fitness_app_demo/features/scores/domain/usecases/get_insights.dart';
import 'score_detail_state.dart';

@injectable
class ScoreDetailCubit extends Cubit<ScoreDetailState> {
  final GetScoreDetail getScoreDetail;
  final GetScoreHistory getScoreHistory;
  final GetInsights getInsights;
  final DataGenerationService dataGenerationService;

  // Track which timeframes have been visited
  final Set<Timeframe> _visitedTimeframes = {};

  ScoreDetailCubit(
    this.getScoreDetail,
    this.getScoreHistory,
    this.getInsights,
    this.dataGenerationService,
  ) : super(const ScoreDetailState.initial());

  Future<void> loadScoreDetail(
    ScoreType scoreType,
    Timeframe timeframe, {
    DateTime? selectedDate,
  }) async {
    final date = selectedDate ?? DateTime.now();

    // Mark this timeframe as visited
    _visitedTimeframes.add(timeframe);

    emit(
      ScoreDetailState.loading(
        scoreType: scoreType,
        timeframe: timeframe,
        selectedDate: date,
      ),
    );

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
        emit(ScoreDetailState.error(
          failure: failure,
          scoreType: scoreType,
          timeframe: timeframe,
          selectedDate: date,
        ));
        return null;
      },
      (success) => success,
    );
    if (score == null) return;

    final history = historyResult.fold(
      (failure) {
        emit(ScoreDetailState.error(
          failure: failure,
          scoreType: scoreType,
          timeframe: timeframe,
          selectedDate: date,
        ));
        return null;
      },
      (success) => success,
    );
    if (history == null) return;

    final insights = insightsResult.fold(
      (failure) {
        emit(ScoreDetailState.error(
          failure: failure,
          scoreType: scoreType,
          timeframe: timeframe,
          selectedDate: date,
        ));
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
    final currentState = state;

    currentState.maybeWhen(
      loaded: (score, history, insights, timeframe, scoreType, selectedDate) async {
        await _handleTimeframeChange(newTimeframe, scoreType);
      },
      error: (failure, scoreType, timeframe, selectedDate) async {
        await _handleTimeframeChange(newTimeframe, scoreType);
      },
      orElse: () {},
    );
  }

  Future<void> _handleTimeframeChange(Timeframe newTimeframe, ScoreType scoreType) async {
    // Only process first-time visits to this timeframe
    if (!_visitedTimeframes.contains(newTimeframe)) {
      // Add the timeframe to visited list
      _visitedTimeframes.add(newTimeframe);

      // Show loading state with delay
      emit(
        ScoreDetailState.loading(
          scoreType: scoreType,
          timeframe: newTimeframe,
          selectedDate: DateTime.now(),
        ),
      );

      // Intentional delay to demonstrate loading state for presentation purposes.
      await Future.delayed(const Duration(milliseconds: 600));

      // Check if this is the fourth timeframe visit (for error demonstration)
      if (_visitedTimeframes.length == 4) {
        emit(ScoreDetailState.error(
          failure: const DataFailure('Something went wrong.'),
          scoreType: scoreType,
          timeframe: newTimeframe,
          selectedDate: DateTime.now(),
        ));
        return;
      }
    }

    // Always reset to today when changing timeframe
    loadScoreDetail(scoreType, newTimeframe, selectedDate: DateTime.now());
  }

  Future<void> refresh() async {
    state.maybeWhen(
      loaded: (score, history, insights, timeframe, scoreType, selectedDate) async {
        // Regenerate data like home page does
        await dataGenerationService.refreshData();

        // Reload with fresh data
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
      error: (failure, scoreType, timeframe, selectedDate) {
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
      error: (failure, scoreType, timeframe, selectedDate) {
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
        return _canNavigateToNext(selectedDate);
      },
      error: (failure, scoreType, timeframe, selectedDate) {
        return _canNavigateToNext(selectedDate);
      },
      orElse: () => false,
    );
  }

  bool _canNavigateToNext(DateTime selectedDate) {
    final today = DateTime.now();
    // Normalize both dates to start of day for comparison
    final normalizedToday = DateTime(today.year, today.month, today.day);
    final normalizedSelected = DateTime(selectedDate.year, selectedDate.month, selectedDate.day);
    return normalizedSelected.isBefore(normalizedToday);
  }
}
