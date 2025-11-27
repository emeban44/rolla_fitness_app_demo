import 'dart:math' as math;
import 'package:flutter/foundation.dart';
import 'package:rolla_fitness_app_demo/core/utils/helpers/date_time_helper.dart';

/// Pure Dart implementation of data generation
/// Generates 6 months of realistic fitness data
class DataGenerator {
  final math.Random _random = math.Random();

  /// Generate complete fitness data for 6 months
  /// Returns the generated data structure (doesn't write to file)
  Future<Map<String, dynamic>?> generateCompleteData() async {
    try {
      debugPrint('🚀 Starting Dart data generation...');
      final startTime = DateTime.now();

      final dates = _generateDates(months: 6);
      final totalDays = dates.length;

      debugPrint('📊 Generating data for $totalDays days...');

      // Initialize data structure
      final data = {
        'scores': {
          'health': {'current_value': 0, 'metrics': {}},
          'readiness': {'current_value': 0, 'metrics': {}},
          'activity': {'current_value': 0, 'metrics': {}},
        },
        'history': {
          'health': <Map<String, dynamic>>[],
          'readiness': <Map<String, dynamic>>[],
          'activity': <Map<String, dynamic>>[],
        },
        'daily_metrics': {
          'health': <Map<String, dynamic>>[],
          'readiness': <Map<String, dynamic>>[],
          'activity': <Map<String, dynamic>>[],
        },
        'insights': {
          'health': <String, Map<String, dynamic>>{},
          'readiness': <String, Map<String, dynamic>>{},
          'activity': <String, Map<String, dynamic>>{},
        },
      };

      // Base scores for each type
      const baseScores = {
        'health': 65,
        'readiness': 70,
        'activity': 60,
      };

      // Generate data for each date
      for (var dayIndex = 0; dayIndex < dates.length; dayIndex++) {
        final date = dates[dayIndex];
        final isToday = (dayIndex == dates.length - 1); // Last date is today

        // Generate scores for this day
        var healthScore = _generateScoreWithTrend(
          baseScores['health']!,
          dayIndex,
          totalDays,
        );
        var readinessScore = _generateScoreWithTrend(
          baseScores['readiness']!,
          dayIndex,
          totalDays,
        );
        var activityScore = _generateScoreWithTrend(
          baseScores['activity']!,
          dayIndex,
          totalDays,
        );

        // Check if we should add missing data (every 10th day)
        final day = int.parse(date.split('-')[2]);
        final isTenthDay = (day % 10 == 0);

        // Occasionally set overall score to null (2% chance), but NEVER for today
        if (!isToday) {
          if (_random.nextDouble() < 0.02) healthScore = null;
          if (_random.nextDouble() < 0.02) readinessScore = null;
          if (_random.nextDouble() < 0.02) activityScore = null;
        }

        // Add to history
        (data['history']!['health'] as List).add({
          'date': date,
          'value': healthScore ?? 0,
        });
        (data['history']!['readiness'] as List).add({
          'date': date,
          'value': readinessScore ?? 0,
        });
        (data['history']!['activity'] as List).add({
          'date': date,
          'value': activityScore ?? 0,
        });

        // === HEALTH METRICS ===
        final healthMetrics = <String, Map<String, dynamic>>{};

        var readinessMetricScore = readinessScore != null
            ? (readinessScore + _random.nextInt(11) - 5).clamp(0, 100)
            : null;
        var activityMetricScore = activityScore != null
            ? (activityScore + _random.nextInt(11) - 5).clamp(0, 100)
            : null;

        // On 10th days, randomly nullify one metric (30% chance), but NEVER for today
        if (!isToday && isTenthDay && _random.nextDouble() < 0.3) {
          if (_random.nextBool()) {
            readinessMetricScore = null;
          } else {
            activityMetricScore = null;
          }
        }

        healthMetrics['readiness'] = {
          'title': 'Readiness',
          'value': readinessMetricScore?.toString() ?? 'N/A',
          'score': readinessMetricScore,
        };
        healthMetrics['activity'] = {
          'title': 'Activity',
          'value': activityMetricScore?.toString() ?? 'N/A',
          'score': activityMetricScore,
        };

        (data['daily_metrics']!['health'] as List).add({
          'date': date,
          'score': healthScore,
          'metrics': healthMetrics,
        });

        // === READINESS METRICS ===
        final readinessMetrics = <String, Map<String, dynamic>>{};

        for (final metricType in ['sleep', 'resting_hr', 'hrv']) {
          int? metricScore;
          String metricValue;

          if (readinessScore != null) {
            var baseMetricScore =
                (readinessScore + _random.nextInt(21) - 10).clamp(0, 100);

            if (!isToday && isTenthDay && _random.nextDouble() < 0.3) {
              metricScore = null;
              metricValue = 'N/A';
            } else {
              metricScore = baseMetricScore;
              metricValue = _generateMetricValue(metricType, baseMetricScore);
            }
          } else {
            metricScore = null;
            metricValue = 'N/A';
          }

          final titles = {
            'sleep': 'Sleep',
            'resting_hr': 'Resting HR',
            'hrv': 'Overnight HRV',
          };

          readinessMetrics[metricType] = {
            'title': titles[metricType] ?? metricType,
            'value': metricValue,
            'score': metricScore,
          };
        }

        (data['daily_metrics']!['readiness'] as List).add({
          'date': date,
          'score': readinessScore,
          'metrics': readinessMetrics,
        });

        // === ACTIVITY METRICS ===
        final activityMetrics = <String, Map<String, dynamic>>{};

        for (final metricType in ['active_points', 'steps', 'move_hours']) {
          int? metricScore;
          String metricValue;

          if (activityScore != null) {
            var baseMetricScore =
                (activityScore + _random.nextInt(21) - 10).clamp(0, 100);

            if (!isToday && isTenthDay && _random.nextDouble() < 0.3) {
              metricScore = null;
              metricValue = 'N/A';
            } else {
              metricScore = baseMetricScore;
              metricValue = _generateMetricValue(metricType, baseMetricScore);
            }
          } else {
            metricScore = null;
            metricValue = 'N/A';
          }

          final titles = {
            'active_points': 'Active points',
            'steps': 'Steps',
            'move_hours': 'Move hours',
          };

          activityMetrics[metricType] = {
            'title': titles[metricType] ?? metricType,
            'value': metricValue,
            'score': metricScore,
          };
        }

        (data['daily_metrics']!['activity'] as List).add({
          'date': date,
          'score': activityScore,
          'metrics': activityMetrics,
        });

        // === GENERATE INSIGHTS ===
        for (final scoreType in ['health', 'readiness', 'activity']) {
          final insight = _generateInsight(scoreType);
          (data['insights']![scoreType] as Map<String, dynamic>)[date] = {
            'id': '${scoreType[0]}_$date',
            'text': insight['text'],
            'type': insight['type'],
          };
        }
      }

      // Set current scores (most recent date = today)
      final mostRecent = dates.last;

      for (final entry in (data['daily_metrics']!['health'] as List)) {
        if (entry['date'] == mostRecent) {
          (data['scores']!['health'] as Map)['current_value'] = entry['score'];
          (data['scores']!['health'] as Map)['metrics'] = entry['metrics'];
          break;
        }
      }

      for (final entry in (data['daily_metrics']!['readiness'] as List)) {
        if (entry['date'] == mostRecent) {
          (data['scores']!['readiness'] as Map)['current_value'] =
              entry['score'];
          (data['scores']!['readiness'] as Map)['metrics'] = entry['metrics'];
          break;
        }
      }

      for (final entry in (data['daily_metrics']!['activity'] as List)) {
        if (entry['date'] == mostRecent) {
          (data['scores']!['activity'] as Map)['current_value'] =
              entry['score'];
          (data['scores']!['activity'] as Map)['metrics'] = entry['metrics'];
          break;
        }
      }

      final healthScore =
          (data['scores']!['health'] as Map)['current_value'] ?? 0;
      final readinessScore =
          (data['scores']!['readiness'] as Map)['current_value'] ?? 0;
      final activityScore =
          (data['scores']!['activity'] as Map)['current_value'] ?? 0;

      debugPrint('✅ Generated $totalDays days of data');
      debugPrint('📈 Health: $healthScore');
      debugPrint('💪 Readiness: $readinessScore');
      debugPrint('🏃 Activity: $activityScore');

      final elapsed = DateTime.now().difference(startTime);
      debugPrint('✨ Data generation complete in ${elapsed.inMilliseconds}ms!');
      debugPrint('🎉 Successfully generated 6 months of fitness data!');

      return data;
    } catch (e, stackTrace) {
      debugPrint('❌ Error generating data: $e');
      debugPrint('Stack trace: $stackTrace');
      return null;
    }
  }

  /// Generate list of dates from today going back 'months' months
  List<String> _generateDates({required int months}) {
    final today = DateTime.now();
    final dates = <String>[];
    final totalDays = months * 30;

    for (var i = 0; i < totalDays; i++) {
      final date = today.subtract(Duration(days: i));
      dates.add(DateTimeHelper.formatToISO8601Date(date));
    }

    dates.sort(); // Chronological order (oldest first)
    return dates;
  }

  /// Generate a score with realistic variance and trends
  int? _generateScoreWithTrend(
    int baseScore,
    int dayIndex,
    int totalDays, {
    int variance = 15,
  }) {
    // Add slight upward trend over time (improvement)
    final trend = (dayIndex / totalDays) * 10;

    // Add sinusoidal variation (weekly patterns)
    final weeklyPattern = math.sin(dayIndex / 7 * 2 * math.pi) * 8;

    // Random daily variance
    final dailyVariance = (_random.nextDouble() * 2 - 1) * variance;

    final score = baseScore + trend + weeklyPattern + dailyVariance;

    return score.clamp(0, 100).round();
  }

  /// Generate realistic metric values based on score
  String _generateMetricValue(String metricType, int score) {
    switch (metricType) {
      case 'sleep':
        final hours = 6 + (score / 100) * 3; // 6-9 hours
        final minutes = _random.nextInt(60);
        return '${hours.floor()}h ${minutes}min';

      case 'resting_hr':
        final hr = 70 - (score / 100) * 20; // 70-50 bpm
        return '${hr.round()} bpm';

      case 'hrv':
        final hrv = 20 + (score / 100) * 40; // 20-60 ms
        return '${hrv.round()} ms';

      case 'active_points':
        final points = (score / 100) * 100; // 0-100 pts
        return '${points.round()} pts';

      case 'steps':
        final steps = 2000 + (score / 100) * 8000; // 2000-10000 steps
        return steps.round().toString();

      case 'move_hours':
        final hours = 3 + (score / 100) * 9; // 3-12 hours
        return '${hours.round()} h';

      default:
        return 'N/A';
    }
  }

  /// Generate a random insight
  Map<String, String> _generateInsight(String scoreType) {
    final templates = _insightTemplates[scoreType];
    if (templates == null || templates.isEmpty) {
      return {'text': 'Keep up the good work!', 'type': 'info'};
    }
    final template = templates[_random.nextInt(templates.length)];

    return _fillInsightTemplate(template);
  }

  /// Fill insight template with random variations
  Map<String, String> _fillInsightTemplate(Map<String, String> template) {
    var text = template['text']!;
    final type = template['type']!;

    final replacements = {
      '{state}': _randomChoice(['looking good', 'well-balanced', 'on track', 'improving', 'stable']),
      '{trend}': _randomChoice(['trending up', 'improving', 'steady', 'holding steady']),
      '{direction}': _randomChoice(['positively', 'upward', 'in the right direction']),
      '{condition}': _randomChoice(['good recovery', "you're well-rested", 'strong readiness']),
      '{position}': _randomChoice(['above', 'near', 'at', 'slightly above']),
      '{message}': _randomChoice(['great sign', 'looking good', 'your body is ready']),
      '{quality}': _randomChoice(['optimal', 'sufficient', 'good', 'excellent']),
      '{comparison}': _randomChoice(['approaching', 'meeting', 'exceeding', 'on track with']),
    };

    replacements.forEach((key, value) {
      text = text.replaceAll(key, value);
    });

    return {'text': text, 'type': type};
  }

  /// Random choice from list
  String _randomChoice(List<String> options) {
    return options[_random.nextInt(options.length)];
  }


  /// Insight templates for each score type
  static final Map<String, List<Map<String, String>>> _insightTemplates = {
    'health': [
      {'text': 'Your balance between rest and activity is {state}.', 'type': 'info'},
      {'text': 'Health score is {trend} compared to your weekly average.', 'type': 'info'},
      {'text': 'Great harmony between your Readiness and Activity today.', 'type': 'info'},
      {'text': 'Your body is finding a good rhythm this week.', 'type': 'info'},
      {'text': 'Consider balancing today\'s activity with adequate recovery.', 'type': 'suggestion'},
      {'text': 'Your overall wellness is trending {direction}.', 'type': 'info'},
      {'text': 'Nice balance! Keep this momentum going.', 'type': 'info'},
      {'text': 'Your health metrics show consistent improvement.', 'type': 'info'},
      {'text': 'Today\'s score reflects good lifestyle choices.', 'type': 'info'},
      {'text': 'Your body is adapting well to your routine.', 'type': 'info'},
    ],
    'readiness': [
      {'text': 'Excellent sleep quality! Your body recovered well overnight.', 'type': 'info'},
      {'text': 'Your HRV is {state} today, indicating {condition}.', 'type': 'info'},
      {'text': 'Resting heart rate is {position} your baseline - {message}.', 'type': 'info'},
      {'text': 'Your recovery metrics look strong today.', 'type': 'info'},
      {'text': 'Sleep duration was {quality}, giving your body time to recover.', 'type': 'info'},
      {'text': 'Your body shows signs of good recovery today.', 'type': 'info'},
      {'text': 'HRV suggests you\'re well-prepared for physical activity.', 'type': 'info'},
      {'text': 'Consider an earlier bedtime to boost tomorrow\'s readiness.', 'type': 'suggestion'},
      {'text': 'Your overnight metrics indicate deep, restorative sleep.', 'type': 'info'},
      {'text': 'Recovery is on track - your body is adapting well.', 'type': 'info'},
      {'text': 'Resting HR is elevated - your body may need more recovery.', 'type': 'warning'},
      {'text': 'HRV is lower than usual. Consider taking it easier today.', 'type': 'warning'},
    ],
    'activity': [
      {'text': 'You\'re building great momentum with your activity today.', 'type': 'info'},
      {'text': 'Your step count is {trend} - keep up the movement!', 'type': 'info'},
      {'text': 'Great work staying active throughout the day.', 'type': 'info'},
      {'text': 'Move hours are {state}, showing consistent activity.', 'type': 'info'},
      {'text': 'Active points reflect a {quality} level of effort today.', 'type': 'info'},
      {'text': 'Try adding some movement to boost your activity score.', 'type': 'suggestion'},
      {'text': 'You\'re {comparison} your daily activity goals.', 'type': 'info'},
      {'text': 'Consistent movement today! Your body will thank you.', 'type': 'info'},
      {'text': 'Activity level is {position} - {message}.', 'type': 'info'},
      {'text': 'Great job breaking up sedentary time today.', 'type': 'info'},
      {'text': 'Consider a short walk to increase your move hours.', 'type': 'suggestion'},
      {'text': 'Your activity pattern shows healthy variety.', 'type': 'info'},
    ],
  };
}
