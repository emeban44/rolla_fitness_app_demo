// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;
import 'package:rolla_fitness_app_demo/core/services/data_generation_service.dart'
    as _i784;
import 'package:rolla_fitness_app_demo/features/scores/data/datasources/scores_local_datasource.dart'
    as _i1057;
import 'package:rolla_fitness_app_demo/features/scores/data/repositories/scores_repository_impl.dart'
    as _i419;
import 'package:rolla_fitness_app_demo/features/scores/domain/repositories/scores_repository.dart'
    as _i344;
import 'package:rolla_fitness_app_demo/features/scores/domain/usecases/get_insights.dart'
    as _i835;
import 'package:rolla_fitness_app_demo/features/scores/domain/usecases/get_metric_info.dart'
    as _i580;
import 'package:rolla_fitness_app_demo/features/scores/domain/usecases/get_score_detail.dart'
    as _i20;
import 'package:rolla_fitness_app_demo/features/scores/domain/usecases/get_score_history.dart'
    as _i294;
import 'package:rolla_fitness_app_demo/features/scores/domain/usecases/get_scores.dart'
    as _i151;
import 'package:rolla_fitness_app_demo/features/scores/presentation/cubit/score_detail_cubit.dart'
    as _i917;
import 'package:rolla_fitness_app_demo/features/scores/presentation/cubit/scores_cubit.dart'
    as _i217;

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    gh.lazySingleton<_i1057.ScoresLocalDataSource>(
      () => _i1057.ScoresLocalDataSourceImpl(),
    );
    gh.lazySingleton<_i344.ScoresRepository>(
      () => _i419.ScoresRepositoryImpl(gh<_i1057.ScoresLocalDataSource>()),
    );
    gh.lazySingleton<_i784.DataGenerationService>(
      () => _i784.DataGenerationService(gh<_i1057.ScoresLocalDataSource>()),
    );
    gh.lazySingleton<_i294.GetScoreHistory>(
      () => _i294.GetScoreHistory(gh<_i344.ScoresRepository>()),
    );
    gh.lazySingleton<_i151.GetScores>(
      () => _i151.GetScores(gh<_i344.ScoresRepository>()),
    );
    gh.lazySingleton<_i835.GetInsights>(
      () => _i835.GetInsights(gh<_i344.ScoresRepository>()),
    );
    gh.lazySingleton<_i580.GetMetricInfo>(
      () => _i580.GetMetricInfo(gh<_i344.ScoresRepository>()),
    );
    gh.lazySingleton<_i20.GetScoreDetail>(
      () => _i20.GetScoreDetail(gh<_i344.ScoresRepository>()),
    );
    gh.factory<_i917.ScoreDetailCubit>(
      () => _i917.ScoreDetailCubit(
        gh<_i20.GetScoreDetail>(),
        gh<_i294.GetScoreHistory>(),
        gh<_i835.GetInsights>(),
      ),
    );
    gh.factory<_i217.ScoresCubit>(
      () => _i217.ScoresCubit(
        gh<_i151.GetScores>(),
        gh<_i784.DataGenerationService>(),
      ),
    );
    return this;
  }
}
