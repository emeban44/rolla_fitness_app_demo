import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:rolla_fitness_app_demo/core/error/failures.dart';
import 'package:rolla_fitness_app_demo/features/scores/domain/entities/metric_info/metric_info.dart';
import 'package:rolla_fitness_app_demo/features/scores/domain/repositories/scores_repository.dart';

/// Use case to get metric information for info drawer
@lazySingleton
class GetMetricInfo {
  final ScoresRepository repository;

  GetMetricInfo(this.repository);

  Future<Either<Failure, MetricInfo>> call(String metricId) {
    return repository.getMetricInfo(metricId);
  }
}
