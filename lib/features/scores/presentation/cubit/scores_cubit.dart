import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:rolla_fitness_app_demo/core/error/failures.dart';
import 'package:rolla_fitness_app_demo/core/services/data_generation_service.dart';
import 'package:rolla_fitness_app_demo/features/scores/domain/usecases/get_scores.dart';
import 'scores_state.dart';

@injectable
class ScoresCubit extends Cubit<ScoresState> {
  final GetScores getScores;
  final DataGenerationService dataGenerationService;

  // Counter for demonstrating error handling
  int _refreshCount = 0;

  ScoresCubit(
    this.getScores,
    this.dataGenerationService,
  ) : super(const ScoresState.initial());

  Future<void> loadScores() async {
    emit(const ScoresState.loading());

    // Generate fresh data before loading
    final generated = await dataGenerationService.generateData();

    if (!generated) {
      // If generation fails, try to load existing data anyway
      debugPrint('⚠️ Data generation failed, attempting to load existing data');
    }

    // Intentional delay to demonstrate loading state for presentation purposes.
    // Remove in production as data generation completes in ~100-200ms.
    await Future.delayed(const Duration(milliseconds: 1500));

    final result = await getScores();

    result.fold(
      (failure) => emit(ScoresState.error(failure)),
      (scores) => emit(ScoresState.loaded(scores)),
    );
  }

  Future<void> refreshScores() async {
    // Increment refresh counter
    _refreshCount++;

    // Every third refresh, emit an intentional error for demonstration
    if (_refreshCount % 3 == 0) {
      emit(const ScoresState.error(DataFailure('Something went wrong.')));
      return;
    }

    // Show loading state during refresh
    emit(const ScoresState.loading());

    // Generate fresh data
    await dataGenerationService.refreshData();

    // Reload scores - this will show new values with tween animation!
    final result = await getScores();

    result.fold(
      (failure) => emit(ScoresState.error(failure)),
      (scores) => emit(ScoresState.loaded(scores)),
    );
  }
}
