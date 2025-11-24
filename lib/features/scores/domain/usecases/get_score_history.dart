import 'package:dartz/dartz.dart';
import 'package:rolla_fitness_app_demo/core/error/failures.dart';
import 'package:rolla_fitness_app_demo/features/scores/domain/entities/score_history_point.dart';
import 'package:rolla_fitness_app_demo/features/scores/domain/entities/score_type.dart';
import 'package:rolla_fitness_app_demo/features/scores/domain/entities/timeframe.dart';
import 'package:rolla_fitness_app_demo/features/scores/domain/repositories/scores_repository.dart';

/// Use case to get score history for charts
class GetScoreHistory {
  final ScoresRepository repository;

  GetScoreHistory(this.repository);

  Future<Either<Failure, List<ScoreHistoryPoint>>> call(
    ScoreType type,
    Timeframe timeframe,
  ) {
    return repository.getScoreHistory(type, timeframe);
  }
}
