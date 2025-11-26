import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:flutter/rendering.dart';

void main() async {
  final random = Random(42); // Fixed seed for reproducibility

  // Read the existing JSON file
  final file = File('assets/data/scores_data.json');
  final jsonString = await file.readAsString();
  final data = json.decode(jsonString) as Map<String, dynamic>;

  // Get history data
  final history = data['history'] as Map<String, dynamic>;

  // Create daily metrics structure
  final dailyMetrics = <String, List<Map<String, dynamic>>>{};

  // Generate metrics for each score type
  for (final scoreType in ['readiness', 'activity', 'health']) {
    final scoreHistory = history[scoreType] as List;
    final dailyData = <Map<String, dynamic>>[];

    for (final entry in scoreHistory) {
      final date = entry['date'] as String;
      final score = entry['value'] as int?;

      if (score == null) {
        // No data for this day
        dailyData.add({
          'date': date,
          'score': null,
          'metrics': null,
        });
      } else {
        // Generate metrics based on the score
        final metrics = _generateMetrics(scoreType, score, random);
        dailyData.add({
          'date': date,
          'score': score,
          'metrics': metrics,
        });
      }
    }

    dailyMetrics[scoreType] = dailyData;
  }

  // Add to the data structure
  data['daily_metrics'] = dailyMetrics;

  // Write back to file with pretty printing
  final encoder = JsonEncoder.withIndent('  ');
  final prettyJson = encoder.convert(data);
  await file.writeAsString(prettyJson);

  debugPrint('✅ Generated historical metrics data successfully!');
  debugPrint('📊 Total days processed:');
  for (final scoreType in dailyMetrics.keys) {
    debugPrint('  - $scoreType: ${dailyMetrics[scoreType]!.length} days');
  }
}

Map<String, dynamic> _generateMetrics(String scoreType, int score, Random random) {
  switch (scoreType) {
    case 'readiness':
      return _generateReadinessMetrics(score, random);
    case 'activity':
      return _generateActivityMetrics(score, random);
    case 'health':
      return _generateHealthMetrics(score, random);
    default:
      return {};
  }
}

Map<String, dynamic> _generateReadinessMetrics(int score, Random random) {
  // Base values for a score of 80 (baseline)
  final baselineSleep = 7.5; // hours
  final baselineRestingHR = 55; // bpm
  final baselineHRV = 45; // ms

  // Adjust based on score (higher score = better metrics)
  final scoreFactor = score / 80;
  final variance = 0.15; // 15% variance

  // Sleep: higher score = more sleep (6-9 hours)
  final sleepHours = (baselineSleep * scoreFactor * (1 + (random.nextDouble() - 0.5) * variance)).clamp(5.5, 9.5);
  final sleepMinutes = (random.nextDouble() * 60).round();
  final sleepScore = _calculateSleepScore(sleepHours + sleepMinutes / 60);

  // Resting HR: higher score = lower HR (45-65 bpm)
  final restingHR = (baselineRestingHR / scoreFactor * (1 + (random.nextDouble() - 0.5) * variance)).round().clamp(
    45,
    70,
  );
  final restingHRScore = _calculateRestingHRScore(restingHR);

  // HRV: higher score = higher HRV (30-65 ms)
  final hrv = (baselineHRV * scoreFactor * (1 + (random.nextDouble() - 0.5) * variance)).round().clamp(25, 70);
  final hrvScore = _calculateHRVScore(hrv);

  return {
    'sleep': {
      'value': '${sleepHours.floor()}h ${sleepMinutes}min',
      'score': sleepScore,
    },
    'resting_hr': {
      'value': '$restingHR bpm',
      'score': restingHRScore,
    },
    'hrv': {
      'value': '$hrv ms',
      'score': hrvScore,
    },
  };
}

Map<String, dynamic> _generateActivityMetrics(int score, Random random) {
  // Base values for a score of 60 (baseline)
  final baselineActivePoints = 25;
  final baselineSteps = 8000;
  final baselineMoveHours = 8;

  // Adjust based on score
  final scoreFactor = score / 60;
  final variance = 0.2; // 20% variance

  // Active points (0-50 pts)
  final activePoints = (baselineActivePoints * scoreFactor * (1 + (random.nextDouble() - 0.5) * variance))
      .round()
      .clamp(5, 50);
  final activePointsScore = _calculateActivePointsScore(activePoints);

  // Steps (1000-15000)
  final steps = (baselineSteps * scoreFactor * (1 + (random.nextDouble() - 0.5) * variance)).round().clamp(1000, 15000);
  final stepsScore = _calculateStepsScore(steps);

  // Move hours (1-12h)
  final moveHours = (baselineMoveHours * scoreFactor * (1 + (random.nextDouble() - 0.5) * variance)).round().clamp(
    3,
    12,
  );
  final moveHoursScore = _calculateMoveHoursScore(moveHours);

  return {
    'active_points': {
      'value': '$activePoints pts',
      'score': activePointsScore,
    },
    'steps': {
      'value': '$steps',
      'score': stepsScore,
    },
    'move_hours': {
      'value': '$moveHours h',
      'score': moveHoursScore,
    },
  };
}

Map<String, dynamic> _generateHealthMetrics(int score, Random random) {
  // Health is the average of readiness and activity
  // Generate sub-scores that average to the health score
  final variance = 10;
  final readinessScore = (score + (random.nextInt(variance * 2) - variance)).clamp(0, 100);
  final activityScore = (score * 2 - readinessScore).clamp(0, 100);

  return {
    'readiness': {
      'title': 'Readiness',
      'value': '$readinessScore',
      'score': readinessScore,
    },
    'activity': {
      'title': 'Activity',
      'value': '$activityScore',
      'score': activityScore,
    },
  };
}

// Scoring functions
int _calculateSleepScore(double hours) {
  // Optimal sleep: 7.5-8.5 hours = 100
  // 6-7 hours or 9-9.5 hours = 70-85
  // <6 or >9.5 hours = lower scores
  if (hours >= 7.5 && hours <= 8.5) return (95 + (10 - (hours - 7.5).abs() * 10)).round();
  if (hours >= 7 && hours < 7.5) return (80 + (hours - 7) * 30).round();
  if (hours > 8.5 && hours <= 9) return (85 + (9 - hours) * 20).round();
  if (hours >= 6 && hours < 7) return (60 + (hours - 6) * 20).round();
  if (hours > 9 && hours <= 10) return (65 + (10 - hours) * 20).round();
  return 50;
}

int _calculateRestingHRScore(int hr) {
  // Lower is better: 45-50 = 100, 51-55 = 85-95, 56-60 = 70-85, 61+ = lower
  if (hr <= 50) return (100 - (50 - hr)).clamp(90, 100);
  if (hr <= 55) return (95 - (hr - 50) * 2).round();
  if (hr <= 60) return (85 - (hr - 55) * 3).round();
  if (hr <= 65) return (70 - (hr - 60) * 3).round();
  return 50;
}

int _calculateHRVScore(int hrv) {
  // Higher is better: 50+ = 100, 40-50 = 75-95, 30-40 = 55-75, <30 = lower
  if (hrv >= 50) return (100 - (hrv - 50) * 0.5).round().clamp(95, 100);
  if (hrv >= 40) return (75 + (hrv - 40) * 2).round();
  if (hrv >= 30) return (55 + (hrv - 30) * 2).round();
  return (30 + hrv).clamp(20, 55);
}

int _calculateActivePointsScore(int points) {
  // More is better: 30+ = 100, 20-30 = 70-95, 10-20 = 40-70
  if (points >= 30) return 100;
  if (points >= 20) return (70 + (points - 20) * 2.5).round();
  if (points >= 10) return (40 + (points - 10) * 3).round();
  return (points * 4).clamp(10, 40);
}

int _calculateStepsScore(int steps) {
  // 10000+ = 100, 7000-10000 = 70-95, 5000-7000 = 50-70
  if (steps >= 10000) return (100 - (steps - 10000) / 1000).round().clamp(95, 100);
  if (steps >= 7000) return (70 + (steps - 7000) / 120).round();
  if (steps >= 5000) return (50 + (steps - 5000) / 100).round();
  return (steps / 100).round().clamp(10, 50);
}

int _calculateMoveHoursScore(int hours) {
  // 10+ hours = 100, 8-10 = 75-95, 6-8 = 50-75
  if (hours >= 10) return 100;
  if (hours >= 8) return (75 + (hours - 8) * 10).round();
  if (hours >= 6) return (50 + (hours - 6) * 12.5).round();
  return (hours * 8).clamp(20, 50);
}
