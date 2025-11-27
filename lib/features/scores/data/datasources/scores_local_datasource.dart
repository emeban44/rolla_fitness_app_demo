import 'package:rolla_fitness_app_demo/features/scores/data/models/score_model/score_model.dart';
import 'package:rolla_fitness_app_demo/features/scores/data/models/score_history_point_model/score_history_point_model.dart';
import 'package:rolla_fitness_app_demo/features/scores/data/models/insight_model/insight_model.dart';
import 'package:rolla_fitness_app_demo/features/scores/data/models/metric_info_model/metric_info_model.dart';

/// Abstract datasource interface for local scores data
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

  void clearCache();

  void setGeneratedData(Map<String, dynamic> data);
}
