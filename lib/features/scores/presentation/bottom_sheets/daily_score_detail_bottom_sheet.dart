import 'package:flutter/material.dart';
import 'package:rolla_fitness_app_demo/core/widgets/section/section_description.dart';
import 'package:rolla_fitness_app_demo/core/widgets/section/section_title.dart';
import 'package:rolla_fitness_app_demo/features/scores/domain/entities/metric/metric.dart';
import 'package:rolla_fitness_app_demo/features/scores/domain/entities/metric_info/metric_info.dart';
import 'package:rolla_fitness_app_demo/features/scores/domain/enums/score_type.dart';
import 'package:rolla_fitness_app_demo/features/scores/presentation/widgets/gauge/score_gauge_decorated_section.dart';
import 'package:rolla_fitness_app_demo/features/scores/presentation/widgets/metrics/metrics_details_list.dart';

/// Bottom sheet showing daily score details with metrics and info
class DailyScoreDetailBottomSheet extends StatelessWidget {
  final String scoreTitle;
  final ScoreType scoreType;
  final int? scoreValue;
  final List<Metric> metrics;
  final MetricInfo info;

  const DailyScoreDetailBottomSheet({
    super.key,
    required this.scoreTitle,
    required this.scoreType,
    required this.scoreValue,
    required this.metrics,
    required this.info,
  });

  /// Show the bottom sheet
  static void show({
    required BuildContext context,
    required String scoreTitle,
    required ScoreType scoreType,
    required int? scoreValue,
    required List<Metric> metrics,
    required MetricInfo info,
  }) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DailyScoreDetailBottomSheet(
        scoreTitle: scoreTitle,
        scoreType: scoreType,
        scoreValue: scoreValue,
        metrics: metrics,
        info: info,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.85,
      ),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    scoreTitle,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close),
                ),
              ],
            ),
          ),

          Flexible(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Radial gauge with dotted background
                  ScoreGaugeDecoratedSection(
                    scoreType: scoreType,
                    score: scoreValue,
                  ),
                  const SizedBox(height: 24),

                  // Metrics section
                  const SectionTitle(title: 'Metrics'),
                  const SizedBox(height: 16),
                  MetricsDetailsList(metrics: metrics),
                  const SizedBox(height: 24),

                  // How It Works section
                  const SectionTitle(title: 'How It Works?'),
                  const SizedBox(height: 12),
                  SectionDescription(text: info.description),
                  if (info.baselineInfo?.isNotEmpty ?? false) ...[
                    const SizedBox(height: 12),
                    SectionDescription(text: info.baselineInfo ?? ''),
                  ],
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
