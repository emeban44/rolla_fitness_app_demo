import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rolla_fitness_app_demo/core/di/service_locator.dart';
import 'package:rolla_fitness_app_demo/core/theme/theme_cubit.dart';
import 'package:rolla_fitness_app_demo/core/widgets/error_widget.dart';
import 'package:rolla_fitness_app_demo/core/widgets/loading_skeleton.dart';
import 'package:rolla_fitness_app_demo/core/widgets/section_title.dart';
import 'package:rolla_fitness_app_demo/features/scores/domain/entities/score_type.dart';
import 'package:rolla_fitness_app_demo/features/scores/domain/entities/timeframe.dart';
import 'package:rolla_fitness_app_demo/features/scores/presentation/cubit/score_detail_cubit.dart';
import 'package:rolla_fitness_app_demo/features/scores/presentation/cubit/score_detail_state.dart';
import 'package:rolla_fitness_app_demo/features/scores/presentation/widgets/daily_score_detail_bottom_sheet.dart';
import 'package:rolla_fitness_app_demo/features/scores/presentation/widgets/detail_score_gauge_section.dart';
import 'package:rolla_fitness_app_demo/features/scores/presentation/widgets/metric_tile.dart';
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
                            scoreValue: score.value,
                            scoreColor: scoreType.accentColor,
                            metrics: score.metrics,
                            info: null,
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
                        DetailScoreGaugeSection(
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
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Column(
                          children: score.metrics.map((metric) {
                            // Make Readiness and Activity metrics tappable on Health page
                            final isNavigatable =
                                scoreType == ScoreType.health &&
                                (metric.title.toLowerCase() == 'readiness' || metric.title.toLowerCase() == 'activity');

                            return MetricTile(
                              metric: metric,
                              showAvgLabel: timeframe != Timeframe.oneDay,
                              onTap: isNavigatable
                                  ? () {
                                      final targetScoreType = metric.title.toLowerCase() == 'readiness'
                                          ? ScoreType.readiness
                                          : ScoreType.activity;
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => ScoreDetailPage(
                                            scoreType: targetScoreType,
                                          ),
                                        ),
                                      );
                                    }
                                  : null,
                            );
                          }).toList(),
                        ),
                      ),

                      const SizedBox(height: 32),

                      // About section
                      if (insights.isNotEmpty) ...[
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SectionTitle(title: 'About'),
                              const SizedBox(height: 12),
                              Container(
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: Theme.of(
                                    context,
                                  ).cardColor.withValues(alpha: 0.5),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: insights.map((insight) {
                                    return Padding(
                                      padding: const EdgeInsets.only(bottom: 8),
                                      child: Text(
                                        insight.text,
                                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                          height: 1.5,
                                          color: Theme.of(context).textTheme.bodySmall?.color?.withValues(alpha: 0.8),
                                        ),
                                      ),
                                    );
                                  }).toList(),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 24),
                      ],
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
