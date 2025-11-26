import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:rolla_fitness_app_demo/core/error/failures.dart';
import 'package:rolla_fitness_app_demo/features/scores/domain/entities/score/score.dart';

part 'scores_state.freezed.dart';

@freezed
class ScoresState with _$ScoresState {
  const factory ScoresState.initial() = _Initial;
  const factory ScoresState.loading() = _Loading;
  const factory ScoresState.loaded(List<Score> scores) = _Loaded;
  const factory ScoresState.error(Failure failure) = _Error;
}
