import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:rolla_fitness_app_demo/core/error/failures.dart';
import 'package:rolla_fitness_app_demo/features/scores/domain/entities/score.dart';
import 'package:rolla_fitness_app_demo/features/scores/domain/entities/score_type.dart';
import 'package:rolla_fitness_app_demo/features/scores/domain/entities/timeframe.dart';
import 'package:rolla_fitness_app_demo/features/scores/domain/entities/score_history_point.dart';
import 'package:rolla_fitness_app_demo/features/scores/domain/entities/insight.dart';
import 'package:rolla_fitness_app_demo/features/scores/domain/entities/metric_info.dart';
import 'package:rolla_fitness_app_demo/features/scores/domain/repositories/scores_repository.dart';
import 'package:rolla_fitness_app_demo/features/scores/data/datasources/scores_local_datasource.dart';

/// Repository implementation using local datasource
@LazySingleton(as: ScoresRepository)
class ScoresRepositoryImpl implements ScoresRepository {
  final ScoresLocalDataSource localDataSource;

  ScoresRepositoryImpl(this.localDataSource);

  @override
  Future<Either<Failure, List<Score>>> getScores() async {
    try {
      final models = await localDataSource.getScores();
      final scores = models.map((model) => model.toDomain()).toList();
      return Right(scores);
    } catch (e) {
      return Left(DataFailure('Failed to load scores: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, Score>> getScoreDetail(
    ScoreType type,
    Timeframe timeframe,
    DateTime selectedDate,
  ) async {
    try {
      final model = await localDataSource.getScoreDetail(
        type.name,
        timeframe.apiKey,
        selectedDate,
      );
      return Right(model.toDomain());
    } catch (e) {
      return Left(DataFailure('Failed to load score detail: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, List<ScoreHistoryPoint>>> getScoreHistory(
    ScoreType type,
    Timeframe timeframe,
    DateTime selectedDate,
  ) async {
    try {
      final models = await localDataSource.getScoreHistory(
        type.name,
        timeframe.apiKey,
        selectedDate,
      );
      final history = models.map((model) => model.toDomain()).toList();
      return Right(history);
    } catch (e) {
      return Left(
          DataFailure('Failed to load score history: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, List<Insight>>> getInsights(ScoreType type) async {
    try {
      final models = await localDataSource.getInsights(type.name);
      final insights = models.map((model) => model.toDomain()).toList();
      return Right(insights);
    } catch (e) {
      return Left(DataFailure('Failed to load insights: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, MetricInfo>> getMetricInfo(String metricId) async {
    try {
      final model = await localDataSource.getMetricInfo(metricId);
      return Right(model.toDomain());
    } catch (e) {
      return Left(DataFailure('Failed to load metric info: ${e.toString()}'));
    }
  }
}
