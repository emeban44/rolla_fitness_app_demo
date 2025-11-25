import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:injectable/injectable.dart';
import 'package:rolla_fitness_app_demo/features/scores/data/models/score_model.dart';
import 'package:rolla_fitness_app_demo/features/scores/data/models/metric_model.dart';
import 'package:rolla_fitness_app_demo/features/scores/data/models/score_history_point_model.dart';
import 'package:rolla_fitness_app_demo/features/scores/data/models/insight_model.dart';
import 'package:rolla_fitness_app_demo/features/scores/data/models/metric_info_model.dart';

/// Abstract datasource interface
abstract class ScoresLocalDataSource {
  Future<List<ScoreModel>> getScores();
  Future<ScoreModel> getScoreDetail(
    String scoreType,
    String timeframe,
    DateTime selectedDate,
  );
  Future<List<ScoreHistoryPointModel>> getScoreHistory(
    String scoreType,
    String timeframe,
    DateTime selectedDate,
  );
  Future<List<InsightModel>> getInsights(String scoreType);
  Future<MetricInfoModel> getMetricInfo(String metricId);
}

/// Implementation of local datasource
@LazySingleton(as: ScoresLocalDataSource)
class ScoresLocalDataSourceImpl implements ScoresLocalDataSource {
  static const String _jsonPath = 'assets/data/scores_data.json';
  Map<String, dynamic>? _cachedData;

  /// Load and cache JSON data
  Future<Map<String, dynamic>> _loadData() async {
    if (_cachedData != null) return _cachedData!;

    final jsonString = await rootBundle.loadString(_jsonPath);
    _cachedData = json.decode(jsonString) as Map<String, dynamic>;
    return _cachedData!;
  }

  @override
  Future<List<ScoreModel>> getScores() async {
    final data = await _loadData();
    final scoresData = data['scores'] as Map<String, dynamic>;

    final scores = <ScoreModel>[];

    for (final entry in scoresData.entries) {
      final scoreType = entry.key;
      final scoreData = entry.value as Map<String, dynamic>;
      final currentValue = scoreData['current_value'] as int;
      final metricsData = scoreData['metrics'] as Map<String, dynamic>;

      final metrics = <MetricModel>[];
      for (final metricEntry in metricsData.entries) {
        final metricId = metricEntry.key;
        final metricData = metricEntry.value as Map<String, dynamic>;

        metrics.add(MetricModel(
          id: metricId,
          title: metricData['title'] as String,
          displayValue: metricData['value'] as String,
          score: metricData['score'] as int?,
        ));
      }

      scores.add(ScoreModel(
        type: scoreType,
        value: currentValue,
        metrics: metrics,
      ));
    }

    return scores;
  }

  @override
  Future<ScoreModel> getScoreDetail(
    String scoreType,
    String timeframe,
    DateTime selectedDate,
  ) async {
    final data = await _loadData();
    final dailyMetrics = data['daily_metrics'] as Map<String, dynamic>;
    final scoreTypeData = dailyMetrics[scoreType.toLowerCase()] as List;

    // Get score history for the period
    final history = await getScoreHistory(scoreType, timeframe, selectedDate);

    int? scoreValue;
    List<MetricModel> metrics = [];

    if (timeframe == '1d') {
      // For 1D: Get metrics for the specific selected date
      final dateStr = _formatDate(selectedDate);
      final dayData = scoreTypeData.firstWhere(
        (entry) => entry['date'] == dateStr,
        orElse: () => {'date': dateStr, 'score': null, 'metrics': null},
      );

      scoreValue = dayData['score'] as int?;
      final metricsData = dayData['metrics'] as Map<String, dynamic>?;

      if (metricsData != null) {
        metrics = _buildMetricsFromData(metricsData, scoreType);
      }
    } else {
      // For 7D/30D/1Y: Calculate average metrics over the period
      final validScores = history
          .where((point) => point.value != null)
          .map((point) => point.value!)
          .toList();

      if (validScores.isNotEmpty) {
        final averageScore = validScores.reduce((a, b) => a + b) / validScores.length;
        scoreValue = averageScore.round();

        // Calculate average metrics
        metrics = _calculateAverageMetrics(scoreTypeData, history, scoreType);
      }
    }

    return ScoreModel(
      type: scoreType,
      value: scoreValue,
      metrics: metrics,
    );
  }

  /// Build metrics list from daily metrics data
  List<MetricModel> _buildMetricsFromData(Map<String, dynamic> metricsData, String scoreType) {
    final metrics = <MetricModel>[];

    for (final entry in metricsData.entries) {
      final metricId = entry.key;
      final metricData = entry.value as Map<String, dynamic>;

      // Get title from metric_info
      String title = metricId;
      try {
        final data = _cachedData!;
        final metricInfo = data['metric_info'] as Map<String, dynamic>;
        if (metricInfo.containsKey(metricId)) {
          title = (metricInfo[metricId] as Map<String, dynamic>)['title'] as String;
        }
      } catch (_) {
        // Use default title if not found
        title = _formatMetricTitle(metricId);
      }

      metrics.add(MetricModel(
        id: metricId,
        title: title,
        displayValue: metricData['value'] as String,
        score: metricData['score'] as int?,
      ));
    }

    return metrics;
  }

  /// Calculate average metrics over a period
  List<MetricModel> _calculateAverageMetrics(
    List<dynamic> scoreTypeData,
    List<ScoreHistoryPointModel> history,
    String scoreType,
  ) {
    final metricAverages = <String, Map<String, dynamic>>{};

    // Collect all metrics from the period
    for (final historyPoint in history) {
      if (historyPoint.value == null) continue;

      final dateStr = historyPoint.date;
      final dayData = scoreTypeData.firstWhere(
        (entry) => entry['date'] == dateStr,
        orElse: () => null,
      );

      if (dayData == null) continue;
      final metricsData = dayData['metrics'] as Map<String, dynamic>?;
      if (metricsData == null) continue;

      for (final entry in metricsData.entries) {
        final metricId = entry.key;
        final metricData = entry.value as Map<String, dynamic>;
        final score = metricData['score'] as int?;

        if (score != null) {
          if (!metricAverages.containsKey(metricId)) {
            metricAverages[metricId] = {
              'scores': <int>[],
              'title': metricData['title'] ?? _formatMetricTitle(metricId),
              'sampleValue': metricData['value'],
            };
          }
          (metricAverages[metricId]!['scores'] as List<int>).add(score);
        }
      }
    }

    // Calculate averages and build metrics
    final metrics = <MetricModel>[];
    for (final entry in metricAverages.entries) {
      final metricId = entry.key;
      final data = entry.value;
      final scores = data['scores'] as List<int>;

      if (scores.isEmpty) continue;

      final avgScore = (scores.reduce((a, b) => a + b) / scores.length).round();

      metrics.add(MetricModel(
        id: metricId,
        title: data['title'] as String,
        displayValue: data['sampleValue'] as String, // Use sample value for display
        score: avgScore,
      ));
    }

    return metrics;
  }

  /// Format date to YYYY-MM-DD
  String _formatDate(DateTime date) {
    return '${date.year.toString().padLeft(4, '0')}-'
        '${date.month.toString().padLeft(2, '0')}-'
        '${date.day.toString().padLeft(2, '0')}';
  }

  /// Format metric ID to title (e.g., "resting_hr" -> "Resting HR")
  String _formatMetricTitle(String metricId) {
    return metricId
        .split('_')
        .map((word) => word[0].toUpperCase() + word.substring(1))
        .join(' ');
  }

  @override
  Future<List<ScoreHistoryPointModel>> getScoreHistory(
    String scoreType,
    String timeframe,
    DateTime selectedDate,
  ) async {
    final data = await _loadData();
    final historyData = data['history'] as Map<String, dynamic>;
    final scoreHistory = historyData[scoreType.toLowerCase()] as List;

    // Parse all history points
    final allHistory = scoreHistory
        .map((point) =>
            ScoreHistoryPointModel.fromJson(point as Map<String, dynamic>))
        .toList();

    // Calculate date range based on timeframe and selectedDate
    final endDate = DateTime(selectedDate.year, selectedDate.month, selectedDate.day);
    DateTime startDate;

    switch (timeframe.toLowerCase()) {
      case '1d':
        // Single day
        return allHistory
            .where((point) {
              final pointDate = DateTime.parse(point.date);
              final normalizedPointDate = DateTime(pointDate.year, pointDate.month, pointDate.day);
              return normalizedPointDate == endDate;
            })
            .toList();

      case '7d':
        // Last 7 days ending on selectedDate
        startDate = endDate.subtract(const Duration(days: 6));
        break;

      case '30d':
        // Last 30 days ending on selectedDate
        startDate = endDate.subtract(const Duration(days: 29));
        break;

      case '1y':
        // Last 365 days ending on selectedDate
        startDate = endDate.subtract(const Duration(days: 364));
        break;

      default:
        startDate = endDate.subtract(const Duration(days: 6));
    }

    // Filter history to date range
    return allHistory
        .where((point) {
          final pointDate = DateTime.parse(point.date);
          final normalizedPointDate = DateTime(pointDate.year, pointDate.month, pointDate.day);
          return !normalizedPointDate.isBefore(startDate) && !normalizedPointDate.isAfter(endDate);
        })
        .toList();
  }

  @override
  Future<List<InsightModel>> getInsights(String scoreType) async {
    final data = await _loadData();
    final insightsData = data['insights'] as Map<String, dynamic>;
    final scoreInsights =
        insightsData[scoreType.toLowerCase()] as List? ?? [];

    return scoreInsights
        .map(
            (insight) => InsightModel.fromJson(insight as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<MetricInfoModel> getMetricInfo(String metricId) async {
    final data = await _loadData();
    final metricInfoData = data['metric_info'] as Map<String, dynamic>;
    final infoData = metricInfoData[metricId] as Map<String, dynamic>;

    return MetricInfoModel.fromJson(infoData);
  }
}
