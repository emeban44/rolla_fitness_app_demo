import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:rolla_fitness_app_demo/core/error/failures.dart';
import 'package:rolla_fitness_app_demo/features/scores/domain/entities/score/score.dart';
import 'package:rolla_fitness_app_demo/features/scores/domain/repositories/scores_repository.dart';

/// Use case to get all scores for home screen
@lazySingleton
class GetScores {
  final ScoresRepository repository;

  GetScores(this.repository);

  Future<Either<Failure, List<Score>>> call() {
    return repository.getScores();
  }
}
