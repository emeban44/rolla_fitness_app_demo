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
    // Get the score value for the selected date from history
    final history = await getScoreHistory(scoreType, '1d', selectedDate);
    final historyPoint = history.firstOrNull;

    // Get metrics from the static scores data
    final data = await _loadData();
    final scoresData = data['scores'] as Map<String, dynamic>;
    final scoreData = scoresData[scoreType.toLowerCase()] as Map<String, dynamic>;
    final metricsData = scoreData['metrics'] as Map<String, dynamic>;

    // Use the historical value if available, otherwise fall back to current_value
    final scoreValue = historyPoint?.value ?? scoreData['current_value'] as int;

    // Build metrics
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

    return ScoreModel(
      type: scoreType,
      value: scoreValue,
      metrics: metrics,
    );
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
