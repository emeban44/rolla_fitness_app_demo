import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rolla_fitness_app_demo/core/di/scores_injection.dart';
import 'package:rolla_fitness_app_demo/core/widgets/chart_loading_skeleton.dart';
import 'package:rolla_fitness_app_demo/core/widgets/error_widget.dart';
import 'package:rolla_fitness_app_demo/core/widgets/metric_tile_loading_skeleton.dart';
import 'package:rolla_fitness_app_demo/core/widgets/section_description.dart';
import 'package:rolla_fitness_app_demo/core/widgets/section_title.dart';
import 'package:rolla_fitness_app_demo/core/widgets/theme_switcher.dart';
import 'package:rolla_fitness_app_demo/features/scores/domain/entities/score_type.dart';
import 'package:rolla_fitness_app_demo/features/scores/domain/entities/timeframe.dart';
import 'package:rolla_fitness_app_demo/features/scores/domain/entities/insight.dart';
import 'package:rolla_fitness_app_demo/features/scores/presentation/cubit/score_detail_cubit.dart';
import 'package:rolla_fitness_app_demo/features/scores/presentation/cubit/score_detail_state.dart';
import 'package:rolla_fitness_app_demo/features/scores/presentation/widgets/daily_score_detail_bottom_sheet.dart';
import 'package:rolla_fitness_app_demo/features/scores/presentation/widgets/score_gauge_decorated_section.dart';
import 'package:rolla_fitness_app_demo/features/scores/presentation/widgets/metrics_progressive_list.dart';
import 'package:rolla_fitness_app_demo/features/scores/presentation/widgets/score_header.dart';
import 'package:rolla_fitness_app_demo/features/scores/presentation/widgets/timeframe_selector.dart';
import 'package:rolla_fitness_app_demo/features/scores/presentation/widgets/trend_chart.dart';
import 'package:rolla_fitness_app_demo/features/scores/presentation/widgets/daily_insight_note.dart';

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
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(scoreType.displayName),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
        actions: const [
          ThemeSwitcher(),
        ],
      ),
      body: BlocBuilder<ScoreDetailCubit, ScoreDetailState>(
        builder: (context, state) {
          return state.when(
            initial: () => const Center(child: CircularProgressIndicator()),
            loading: (scoreType, timeframe, selectedDate) {
              return LoadingSkeletonView(
                scoreType: scoreType,
                timeframe: timeframe,
                selectedDate: selectedDate,
              );
            },
            loaded: (score, history, insights, timeframe, scoreType, selectedDate) {
              return RefreshIndicator.adaptive(
                onRefresh: () async {
                  await context.read<ScoreDetailCubit>().refresh();
                },
                child: CustomScrollView(
                  slivers: [
                    SliverToBoxAdapter(
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

                          // Score Header
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
                            ScoreGaugeDecoratedSection(
                              scoreType: scoreType,
                              score: score.value,
                            ),
                            if (_getInsightForDate(insights, selectedDate) != null) ...[
                              const SizedBox(height: 16),
                              DailyInsightNote(text: _getInsightForDate(insights, selectedDate)!.text),
                              const SizedBox(height: 8),
                            ],
                          ] else ...[
                            TrendChart(
                              historyPoints: history,
                              color: scoreType.accentColor,
                            ),
                          ],

                          const SizedBox(height: 24),

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

                          const SizedBox(height: 16),

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
                  ],
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

/// Helper function to get insight for a specific date
Insight? _getInsightForDate(List<Insight> insights, DateTime date) {
  final dateStr = _formatDate(date);
  return insights.where((i) => i.id.endsWith(dateStr)).firstOrNull;
}

/// Helper function to format date as YYYY-MM-DD
String _formatDate(DateTime date) {
  return '${date.year.toString().padLeft(4, '0')}-'
      '${date.month.toString().padLeft(2, '0')}-'
      '${date.day.toString().padLeft(2, '0')}';
}

/// Loading skeleton for the detail page
/// Shows skeletons ONLY for chart and metrics - everything else stays visible
class LoadingSkeletonView extends StatelessWidget {
  final ScoreType scoreType;
  final Timeframe timeframe;
  final DateTime selectedDate;

  const LoadingSkeletonView({
    super.key,
    required this.scoreType,
    required this.timeframe,
    required this.selectedDate,
  });

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Timeframe selector - always visible
              TimeframeSelector(
                selectedTimeframe: timeframe,
                onTimeframeChanged: (newTimeframe) {
                  context.read<ScoreDetailCubit>().changeTimeframe(
                    newTimeframe,
                  );
                },
              ),
              const SizedBox(height: 24),

              // Score Header - always visible
              ScoreHeader(
                scoreType: scoreType,
                onInfoTap: () {
                  // Empty during loading
                },
                selectedDate: selectedDate,
                timeframe: timeframe,
                onPrevious: () => context.read<ScoreDetailCubit>().navigatePrevious(),
                onNext: () => context.read<ScoreDetailCubit>().navigateNext(),
                canGoNext: context.read<ScoreDetailCubit>().canNavigateNext(),
              ),
              const SizedBox(height: 24),

              // Chart skeleton (only for 7D/30D/1Y, not for 1D)
              if (timeframe != Timeframe.oneDay) ...[
                const Padding(
                  padding: EdgeInsets.all(16),
                  child: ChartLoadingSkeleton(height: 220),
                ),
                const SizedBox(height: 24),
              ],

              // Metrics section - title stays, tiles are skeletons
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

              // Metric tile skeletons
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  children: [
                    MetricTileLoadingSkeleton(color: scoreType.accentColor),
                    MetricTileLoadingSkeleton(color: scoreType.accentColor),
                  ],
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ],
    );
  }
}
