import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:rolla_fitness_app_demo/core/error/failures.dart';
import 'package:rolla_fitness_app_demo/features/scores/domain/entities/score.dart';
import 'package:rolla_fitness_app_demo/features/scores/domain/entities/score_type.dart';
import 'package:rolla_fitness_app_demo/features/scores/domain/entities/timeframe.dart';
import 'package:rolla_fitness_app_demo/features/scores/domain/repositories/scores_repository.dart';

/// Use case to get score detail for a specific type and timeframe
@lazySingleton
class GetScoreDetail {
  final ScoresRepository repository;

  GetScoreDetail(this.repository);

  Future<Either<Failure, Score>> call(
    ScoreType type,
    Timeframe timeframe,
    DateTime selectedDate,
  ) {
    return repository.getScoreDetail(type, timeframe, selectedDate);
  }
}
