import 'package:dartz/dartz.dart';
import 'package:rolla_fitness_app_demo/core/error/failures.dart';
import 'package:rolla_fitness_app_demo/features/scores/domain/entities/score.dart';
import 'package:rolla_fitness_app_demo/features/scores/domain/entities/score_type.dart';
import 'package:rolla_fitness_app_demo/features/scores/domain/entities/timeframe.dart';
import 'package:rolla_fitness_app_demo/features/scores/domain/entities/score_history_point.dart';
import 'package:rolla_fitness_app_demo/features/scores/domain/entities/insight.dart';
import 'package:rolla_fitness_app_demo/features/scores/domain/entities/metric_info.dart';

/// Repository interface for scores data
abstract class ScoresRepository {
  /// Get all scores for home screen
  Future<Either<Failure, List<Score>>> getScores();

  /// Get detailed score data for a specific type and timeframe
  Future<Either<Failure, Score>> getScoreDetail(
    ScoreType type,
    Timeframe timeframe,
    DateTime selectedDate,
  );

  /// Get score history for charts
  Future<Either<Failure, List<ScoreHistoryPoint>>> getScoreHistory(
    ScoreType type,
    Timeframe timeframe,
    DateTime selectedDate,
  );

  /// Get insights for a score type
  Future<Either<Failure, List<Insight>>> getInsights(ScoreType type);

  /// Get metric information for info drawer
  Future<Either<Failure, MetricInfo>> getMetricInfo(String metricId);
}
