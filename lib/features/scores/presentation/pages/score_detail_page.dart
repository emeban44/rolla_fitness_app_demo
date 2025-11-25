import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rolla_fitness_app_demo/core/di/service_locator.dart';
import 'package:rolla_fitness_app_demo/core/theme/theme_cubit.dart';
import 'package:rolla_fitness_app_demo/core/widgets/error_widget.dart';
import 'package:rolla_fitness_app_demo/core/widgets/loading_skeleton.dart';
import 'package:rolla_fitness_app_demo/core/widgets/section_description.dart';
import 'package:rolla_fitness_app_demo/core/widgets/section_title.dart';
import 'package:rolla_fitness_app_demo/features/scores/domain/entities/score_type.dart';
import 'package:rolla_fitness_app_demo/features/scores/domain/entities/timeframe.dart';
import 'package:rolla_fitness_app_demo/features/scores/presentation/cubit/score_detail_cubit.dart';
import 'package:rolla_fitness_app_demo/features/scores/presentation/cubit/score_detail_state.dart';
import 'package:rolla_fitness_app_demo/features/scores/presentation/widgets/daily_score_detail_bottom_sheet.dart';
import 'package:rolla_fitness_app_demo/features/scores/presentation/widgets/score_gauge_decorated_section.dart';
import 'package:rolla_fitness_app_demo/features/scores/presentation/widgets/metrics_progressive_list.dart';
import 'package:rolla_fitness_app_demo/features/scores/presentation/widgets/score_header.dart';
import 'package:rolla_fitness_app_demo/features/scores/presentation/widgets/timeframe_selector.dart';
import 'package:rolla_fitness_app_demo/features/scores/presentation/widgets/trend_chart.dart';

/// Score detail page - reusable for Health, Readiness, and Activity scores
class ScoreDetailPage extends StatelessWidget {
  final ScoreType scoreType;

  const ScoreDetailPage({
    super.key,
    required this.scoreType,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<ScoreDetailCubit>()..loadScoreDetail(scoreType, Timeframe.oneDay),
      child: ScoreDetailView(scoreType: scoreType),
    );
  }
}

class ScoreDetailView extends StatelessWidget {
  final ScoreType scoreType;

  const ScoreDetailView({
    super.key,
    required this.scoreType,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(scoreType.displayName),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
        actions: [
          TextButton.icon(
            onPressed: () {
              context.read<ThemeCubit>().toggleTheme();
            },
            icon: Icon(
              isDark ? Icons.light_mode : Icons.dark_mode,
              size: 20,
            ),
            label: Text(
              isDark ? 'Light' : 'Dark',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
        ],
      ),
      body: BlocBuilder<ScoreDetailCubit, ScoreDetailState>(
        builder: (context, state) {
          return state.when(
            initial: () => const Center(child: CircularProgressIndicator()),
            loading: () => const LoadingSkeletonView(),
            loaded: (score, history, insights, timeframe, scoreType, selectedDate) {
              return RefreshIndicator(
                onRefresh: () async {
                  await context.read<ScoreDetailCubit>().refresh();
                },
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Timeframe selector
                      TimeframeSelector(
                        selectedTimeframe: timeframe,
                        onTimeframeChanged: (newTimeframe) {
                          context.read<ScoreDetailCubit>().changeTimeframe(
                            newTimeframe,
                          );
                        },
                      ),
                      const SizedBox(height: 24),

                      // Score Header (consistent across all timeframes)
                      ScoreHeader(
                        scoreType: scoreType,
                        onInfoTap: () {
                          DailyScoreDetailBottomSheet.show(
                            context: context,
                            scoreTitle: score.displayName,
                            scoreType: scoreType,
                            scoreValue: score.value,
                            metrics: score.metrics,
                            info: scoreType.getInfo(),
                          );
                        },
                        selectedDate: selectedDate,
                        timeframe: timeframe,
                        onPrevious: () => context.read<ScoreDetailCubit>().navigatePrevious(),
                        onNext: () => context.read<ScoreDetailCubit>().navigateNext(),
                        canGoNext: context.read<ScoreDetailCubit>().canNavigateNext(),
                      ),
                      const SizedBox(height: 24),

                      // Score display or History chart
                      if (timeframe == Timeframe.oneDay) ...[
                        // 1D View - Show gauge with ripple background
                        ScoreGaugeDecoratedSection(
                          scoreType: scoreType,
                          score: score.value,
                        ),
                      ] else ...[
                        // 7D/30D/1Y View - Show chart
                        TrendChart(
                          historyPoints: history,
                          color: scoreType.accentColor,
                        ),
                      ],

                      const SizedBox(height: 16),

                      // Metrics section
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Row(
                          children: [
                            const SectionTitle(title: 'Metrics'),
                            const Spacer(),
                            if (timeframe != Timeframe.oneDay)
                              Text(
                                'Daily Avg.',
                                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                  color: Theme.of(context).textTheme.bodySmall?.color?.withValues(alpha: 0.6),
                                ),
                              ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 12),
                      // Show "No data available" if metrics list is empty
                      if (score.metrics.isEmpty)
                        const SizedBox(
                          height: 60,
                          child: Center(child: Text('No data available')),
                        )
                      else
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: MetricsProgressiveList(
                            metrics: score.metrics,
                            timeframe: timeframe,
                            scoreType: scoreType,
                          ),
                        ),

                      const SizedBox(height: 32),

                      // About section
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SectionTitle(title: 'About'),
                            const SizedBox(height: 12),
                            SectionDescription(text: scoreType.getInfo().description),
                          ],
                        ),
                      ),
                      const SizedBox(height: 50),
                    ],
                  ),
                ),
              );
            },
            error: (failure) => AppErrorWidget(
              message: 'Failed to load score details',
              onRetry: () {
                context.read<ScoreDetailCubit>().refresh();
              },
            ),
          );
        },
      ),
    );
  }
}

/// Loading skeleton for the detail page
class LoadingSkeletonView extends StatelessWidget {
  const LoadingSkeletonView({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Timeframe selector skeleton
          Row(
            children: List.generate(
              4,
              (index) => Expanded(
                child: LoadingSkeleton(
                  width: double.infinity,
                  height: 40,
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ),
          const SizedBox(height: 32),

          // Gauge skeleton
          Center(
            child: LoadingSkeleton(
              width: 200,
              height: 200,
              borderRadius: BorderRadius.circular(100),
            ),
          ),
          const SizedBox(height: 32),

          // Metrics section
          LoadingSkeleton(
            width: 100,
            height: 20,
            borderRadius: BorderRadius.circular(4),
          ),
          const SizedBox(height: 16),
          ...List.generate(
            3,
            (index) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: LoadingSkeleton(
                width: double.infinity,
                height: 70,
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
