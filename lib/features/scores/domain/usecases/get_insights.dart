import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:rolla_fitness_app_demo/core/error/failures.dart';
import 'package:rolla_fitness_app_demo/features/scores/domain/entities/insight/insight.dart';
import 'package:rolla_fitness_app_demo/features/scores/domain/enums/score_type.dart';
import 'package:rolla_fitness_app_demo/features/scores/domain/repositories/scores_repository.dart';

/// Use case to get insights for a score type
@lazySingleton
class GetInsights {
  final ScoresRepository repository;

  GetInsights(this.repository);

  Future<Either<Failure, List<Insight>>> call(ScoreType type) {
    return repository.getInsights(type);
  }
}
