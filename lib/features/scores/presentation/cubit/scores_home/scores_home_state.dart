import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:rolla_fitness_app_demo/core/error/failures.dart';
import 'package:rolla_fitness_app_demo/features/scores/domain/entities/score/score.dart';

part 'scores_home_state.freezed.dart';

@freezed
class ScoresHomeState with _$ScoresHomeState {
  const factory ScoresHomeState.initial() = _Initial;
  const factory ScoresHomeState.loading() = _Loading;
  const factory ScoresHomeState.loaded(List<Score> scores) = _Loaded;
  const factory ScoresHomeState.error(Failure failure) = _Error;
}
