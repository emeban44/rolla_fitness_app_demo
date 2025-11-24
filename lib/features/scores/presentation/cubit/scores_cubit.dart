import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:rolla_fitness_app_demo/features/scores/domain/usecases/get_scores.dart';
import 'scores_state.dart';

@injectable
class ScoresCubit extends Cubit<ScoresState> {
  final GetScores getScores;

  ScoresCubit(this.getScores) : super(const ScoresState.initial());

  Future<void> loadScores() async {
    emit(const ScoresState.loading());

    final result = await getScores();

    result.fold(
      (failure) => emit(ScoresState.error(failure)),
      (scores) => emit(ScoresState.loaded(scores)),
    );
  }

  Future<void> refreshScores() async {
    // For pull-to-refresh, we don't show loading state
    // Just silently refresh
    final result = await getScores();

    result.fold(
      (failure) => emit(ScoresState.error(failure)),
      (scores) => emit(ScoresState.loaded(scores)),
    );
  }
}
