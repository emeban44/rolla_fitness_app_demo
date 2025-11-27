import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rolla_fitness_app_demo/core/constants/app_dimensions.dart';
import 'package:rolla_fitness_app_demo/core/di/scores_injection.dart';
import 'package:rolla_fitness_app_demo/core/widgets/app_bars/custom_app_bar.dart';
import 'package:rolla_fitness_app_demo/core/widgets/cards/custom_card.dart';
import 'package:rolla_fitness_app_demo/core/widgets/error/error_widget.dart';
import 'package:rolla_fitness_app_demo/core/widgets/loading/loading_skeleton.dart';
import 'package:rolla_fitness_app_demo/core/widgets/snackbar/basic_snackbar.dart';
import 'package:rolla_fitness_app_demo/features/scores/domain/enums/score_type.dart';
import 'package:rolla_fitness_app_demo/features/scores/presentation/cubit/scores_home/scores_home_cubit.dart';
import 'package:rolla_fitness_app_demo/features/scores/presentation/cubit/scores_home/scores_home_state.dart';
import 'package:rolla_fitness_app_demo/features/scores/presentation/pages/score_detail_page.dart';
import 'package:rolla_fitness_app_demo/features/scores/presentation/widgets/cards/score_card.dart';
import 'package:rolla_fitness_app_demo/features/scores/presentation/widgets/gauge/spinning_radial_skeleton.dart';
import 'package:rolla_fitness_app_demo/features/scores/presentation/widgets/grid/scores_grid.dart';

/// Home page displaying all three score cards in a grid
class ScoresHomePage extends StatelessWidget {
  const ScoresHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<ScoresHomeCubit>()..loadScores(),
      child: const ScoresHomePageView(),
    );
  }
}

class ScoresHomePageView extends StatelessWidget {
  const ScoresHomePageView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'Rolla Fitness'),
      body: BlocListener<ScoresHomeCubit, ScoresHomeState>(
        listener: (context, state) => state.whenOrNull(
          error: (failure) => showErrorSnackbar(context, message: failure.message),
        ),
        child: BlocBuilder<ScoresHomeCubit, ScoresHomeState>(
          builder: (context, state) {
            return state.when(
              initial: () => const SizedBox.shrink(),
              loading: () => const _LoadingView(),
              loaded: (scores) => RefreshIndicator.adaptive(
                onRefresh: () => context.read<ScoresHomeCubit>().refreshScores(),
                child: ScoresGrid(
                  children: scores.map(
                    (score) {
                      return ScoreCard(
                        scoreType: score.type,
                        score: score.value,
                        onTap: () => _navigateToScoreDetail(context, score.type),
                      );
                    },
                  ).toList(),
                ),
              ),
              error: (failure) => AppErrorWidget(
                message: failure.message,
                onRetry: () => context.read<ScoresHomeCubit>().loadScores(),
              ),
            );
          },
        ),
      ),
    );
  }

  void _navigateToScoreDetail(BuildContext context, ScoreType scoreType) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => ScoreDetailPage(
          scoreType: scoreType,
        ),
      ),
    );
  }
}

/// Loading view with spinning skeleton cards
class _LoadingView extends StatelessWidget {
  const _LoadingView();

  @override
  Widget build(BuildContext context) {
    final scoreTypes = [
      ScoreType.health,
      ScoreType.readiness,
      ScoreType.activity,
    ];

    return ScoresGrid(
      children: List.generate(
        3,
        (index) {
          final scoreType = scoreTypes[index];

          return CustomCard(
            padding: const EdgeInsets.all(12.0),
            child: LayoutBuilder(
              builder: (context, constraints) {
                final gaugeSize = AppDimensions.calculateGaugeSize(constraints.maxHeight);

                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Title shimmer
                    LoadingSkeleton(
                      width: 80,
                      height: 16,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    const SizedBox(height: 12),
                    // Score value shimmer
                    Flexible(
                      child: SpinningRadialSkeleton(
                        size: gaugeSize,
                        color: scoreType.accentColor,
                      ),
                    ),
                  ],
                );
              },
            ),
          );
        },
      ),
    );
  }
}
