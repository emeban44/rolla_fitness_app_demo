import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rolla_fitness_app_demo/core/di/scores_injection.dart';
import 'package:rolla_fitness_app_demo/core/utils/helpers/insight_helper.dart';
import 'package:rolla_fitness_app_demo/core/widgets/app_bars/custom_app_bar.dart';
import 'package:rolla_fitness_app_demo/core/widgets/error/error_widget.dart';
import 'package:rolla_fitness_app_demo/core/widgets/section/section_description.dart';
import 'package:rolla_fitness_app_demo/core/widgets/section/section_title.dart';
import 'package:rolla_fitness_app_demo/core/widgets/snackbar/basic_snackbar.dart';
import 'package:rolla_fitness_app_demo/features/scores/domain/entities/insight/insight.dart';
import 'package:rolla_fitness_app_demo/features/scores/domain/entities/score/score.dart';
import 'package:rolla_fitness_app_demo/features/scores/domain/entities/score_history_point/score_history_point.dart';
import 'package:rolla_fitness_app_demo/features/scores/domain/enums/score_type.dart';
import 'package:rolla_fitness_app_demo/features/scores/domain/enums/timeframe.dart';
import 'package:rolla_fitness_app_demo/features/scores/presentation/bottom_sheets/daily_score_detail_bottom_sheet.dart';
import 'package:rolla_fitness_app_demo/features/scores/presentation/cubit/score_detail/score_detail_cubit.dart';
import 'package:rolla_fitness_app_demo/features/scores/presentation/cubit/score_detail/score_detail_state.dart';
import 'package:rolla_fitness_app_demo/features/scores/presentation/widgets/charts/chart_loading_skeleton.dart';
import 'package:rolla_fitness_app_demo/features/scores/presentation/widgets/charts/trend_chart.dart';
import 'package:rolla_fitness_app_demo/features/scores/presentation/widgets/gauge/radial_gauge_decorated_section.dart';
import 'package:rolla_fitness_app_demo/features/scores/presentation/widgets/headers/score_header.dart';
import 'package:rolla_fitness_app_demo/features/scores/presentation/widgets/insights/daily_insight_note.dart';
import 'package:rolla_fitness_app_demo/features/scores/presentation/widgets/metrics/metric_tile_loading_skeleton.dart';
import 'package:rolla_fitness_app_demo/features/scores/presentation/widgets/metrics/metrics_progressive_list.dart';
import 'package:rolla_fitness_app_demo/features/scores/presentation/widgets/metrics/metrics_section_header.dart';
import 'package:rolla_fitness_app_demo/features/scores/presentation/widgets/selectors/timeframe_selector.dart';

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
      create: (context) => getIt<ScoreDetailCubit>()
        ..loadScoreDetail(
          scoreType,
          Timeframe.oneDay,
        ),
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
      appBar: CustomAppBar(
        title: scoreType.displayName,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
      ),
      body: BlocListener<ScoreDetailCubit, ScoreDetailState>(
        listener: (context, state) => state.whenOrNull(
          error: (failure, scoreType, timeframe, selectedDate) => showErrorSnackbar(
            context,
            message: failure.message,
          ),
        ),
        child: BlocBuilder<ScoreDetailCubit, ScoreDetailState>(
          builder: (context, state) {
            return state.when(
              initial: () => const Center(child: CircularProgressIndicator()),
              loading: (scoreType, timeframe, selectedDate) => ScoreDetailBody(
                scoreType: scoreType,
                timeframe: timeframe,
                selectedDate: selectedDate,
                onInfoTap: null,
                content: _LoadingContent(scoreType: scoreType, timeframe: timeframe),
              ),
              loaded: (score, history, insights, timeframe, scoreType, selectedDate) {
                return RefreshIndicator.adaptive(
                  onRefresh: () async => context.read<ScoreDetailCubit>().refresh(),
                  child: ScoreDetailBody(
                    scoreType: scoreType,
                    timeframe: timeframe,
                    selectedDate: selectedDate,
                    onInfoTap: () => DailyScoreDetailBottomSheet.show(
                      context: context,
                      scoreTitle: score.displayName,
                      scoreType: scoreType,
                      scoreValue: score.value,
                      metrics: score.metrics,
                      info: scoreType.getInfo(),
                    ),
                    content: _LoadedContent(
                      score: score,
                      history: history,
                      insights: insights,
                      timeframe: timeframe,
                      scoreType: scoreType,
                      selectedDate: selectedDate,
                    ),
                  ),
                );
              },
              error: (failure, scoreType, timeframe, selectedDate) => ScoreDetailBody(
                scoreType: scoreType,
                timeframe: timeframe,
                selectedDate: selectedDate,
                onInfoTap: null,
                content: SliverFillRemaining(
                  hasScrollBody: false,
                  child: Center(
                    child: AppErrorWidget(
                      message: failure.message,
                      onRetry: () => context.read<ScoreDetailCubit>().loadScoreDetail(
                        scoreType,
                        timeframe,
                        selectedDate: selectedDate,
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

/// Unified body structure for all states (loading, loaded, error)
class ScoreDetailBody extends StatelessWidget {
  final ScoreType scoreType;
  final Timeframe timeframe;
  final DateTime selectedDate;
  final VoidCallback? onInfoTap;
  final Widget content;

  const ScoreDetailBody({
    super.key,
    required this.scoreType,
    required this.timeframe,
    required this.selectedDate,
    required this.onInfoTap,
    required this.content,
  });

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TimeframeSelector(
                selectedTimeframe: timeframe,
                onTimeframeChanged: (newTimeframe) {
                  context.read<ScoreDetailCubit>().changeTimeframe(newTimeframe);
                },
              ),
              const SizedBox(height: 24),
              ScoreHeader(
                title: timeframe == Timeframe.oneDay ? scoreType.displayName : 'History',
                onInfoTap: timeframe == Timeframe.oneDay ? onInfoTap : null,
                selectedDate: selectedDate,
                timeframe: timeframe,
                onPrevious: () => context.read<ScoreDetailCubit>().navigatePrevious(),
                onNext: () => context.read<ScoreDetailCubit>().navigateNext(),
                canGoNext: context.read<ScoreDetailCubit>().canNavigateNext(),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
        content,
      ],
    );
  }
}

/// Content widget for loaded state
class _LoadedContent extends StatelessWidget {
  final Score score;
  final List<ScoreHistoryPoint> history;
  final List<Insight> insights;
  final Timeframe timeframe;
  final ScoreType scoreType;
  final DateTime selectedDate;

  const _LoadedContent({
    required this.score,
    required this.history,
    required this.insights,
    required this.timeframe,
    required this.scoreType,
    required this.selectedDate,
  });

  @override
  Widget build(BuildContext context) {
    final Insight? insight = InsightHelper.getInsightForDate(insights, selectedDate);

    return SliverToBoxAdapter(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (timeframe == Timeframe.oneDay) ...[
            RadialGaugeDecoratedSection(
              scoreType: scoreType,
              score: score.value,
            ),
            if (insight != null) ...[
              const SizedBox(height: 16),
              DailyInsightNote(text: insight.text),
              const SizedBox(height: 8),
            ],
          ] else ...[
            TrendChart(
              historyPoints: history,
              color: scoreType.accentColor,
            ),
          ],
          const SizedBox(height: 24),
          MetricsSectionHeader(showDailyAvgLabel: timeframe != Timeframe.oneDay),
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
    );
  }
}

/// Content widget for loading state
class _LoadingContent extends StatelessWidget {
  final ScoreType scoreType;
  final Timeframe timeframe;

  const _LoadingContent({
    required this.scoreType,
    required this.timeframe,
  });

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (timeframe != Timeframe.oneDay) ...[
            const Padding(
              padding: EdgeInsets.all(16),
              child: ChartLoadingSkeleton(height: 220),
            ),
            const SizedBox(height: 24),
          ],
          MetricsSectionHeader(
            showDailyAvgLabel: timeframe != Timeframe.oneDay,
          ),
          const SizedBox(height: 12),
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
    );
  }
}
