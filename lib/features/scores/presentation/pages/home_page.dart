import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rolla_fitness_app_demo/core/di/scores_injection.dart';
import 'package:rolla_fitness_app_demo/core/widgets/basic_snackbar.dart';
import 'package:rolla_fitness_app_demo/core/widgets/error_widget.dart';
import 'package:rolla_fitness_app_demo/core/widgets/loading_skeleton.dart';
import 'package:rolla_fitness_app_demo/core/widgets/spinning_radial_skeleton.dart';
import 'package:rolla_fitness_app_demo/core/widgets/theme_switcher.dart';
import 'package:rolla_fitness_app_demo/features/scores/presentation/cubit/scores_cubit.dart';
import 'package:rolla_fitness_app_demo/features/scores/presentation/cubit/scores_state.dart';
import 'package:rolla_fitness_app_demo/features/scores/presentation/pages/score_detail_page.dart';
import 'package:rolla_fitness_app_demo/features/scores/presentation/widgets/score_card.dart';
import 'package:rolla_fitness_app_demo/features/scores/domain/entities/score_type.dart';

/// Home page displaying all three score cards in a grid
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<ScoresCubit>()..loadScores(),
      child: const HomePageView(),
    );
  }
}

class HomePageView extends StatelessWidget {
  const HomePageView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Rolla Fitness'),
        actions: const [
          ThemeSwitcher(),
        ],
      ),
      body: BlocListener<ScoresCubit, ScoresState>(
        listener: (context, state) {
          state.whenOrNull(
            error: (failure) {
              ScaffoldMessenger.of(context).showSnackBar(
                basicSnackbar(
                  context: context,
                  title: failure.message,
                  variant: SnackbarVariant.error,
                ),
              );
            },
          );
        },
        child: BlocBuilder<ScoresCubit, ScoresState>(
          builder: (context, state) {
            return state.when(
              initial: () => const SizedBox.shrink(),
              loading: () => const _LoadingView(),
              loaded: (scores) => RefreshIndicator.adaptive(
                onRefresh: () => context.read<ScoresCubit>().refreshScores(),
                child: GridView.count(
                  crossAxisCount: 2,
                  padding: const EdgeInsets.all(16),
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 0.95, // Slightly taller cards
                  children: scores.map((score) {
                    return ScoreCard(
                      scoreType: score.type,
                      score: score.value,
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => ScoreDetailPage(
                              scoreType: score.type,
                            ),
                          ),
                        );
                      },
                    );
                  }).toList(),
                ),
              ),
              error: (failure) => AppErrorWidget(
                message: failure.message,
                onRetry: () => context.read<ScoresCubit>().loadScores(),
              ),
            );
          },
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
    // Define the three score types for consistent colors
    final scoreTypes = [
      ScoreType.health,
      ScoreType.readiness,
      ScoreType.activity,
    ];

    return GridView.count(
      crossAxisCount: 2,
      padding: const EdgeInsets.all(16),
      crossAxisSpacing: 16,
      mainAxisSpacing: 16,
      childAspectRatio: 0.95, // Match the loaded grid
      children: List.generate(
        3,
        (index) {
          final scoreType = scoreTypes[index];

          return Container(
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final gaugeSize = (constraints.maxHeight * 0.65).clamp(80.0, 180.0);

                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Title skeleton
                      LoadingSkeleton(
                        width: 80,
                        height: 16,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      const SizedBox(height: 12),
                      // Spinning radial gauge skeleton
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
            ),
          );
        },
      ),
    );
  }
}
