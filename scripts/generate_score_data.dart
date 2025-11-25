import 'dart:convert';
import 'dart:math';

import 'package:flutter/widgets.dart';

/// Script to generate comprehensive historical score data
void main() {
  final today = DateTime.now();
  final random = Random(42); // Fixed seed for reproducibility

  // Generate 180 days (6 months) of data
  final healthHistory = _generateHistory(today, 180, 50, 65, random);
  final readinessHistory = _generateHistory(today, 180, 75, 90, random);
  final activityHistory = _generateHistory(today, 180, 45, 75, random);

  // Ensure today's values are not null
  final todayReadiness = readinessHistory.last['value'] ?? 84;
  final todayActivity = activityHistory.last['value'] ?? 66;
  final todayHealth = ((todayReadiness + todayActivity) / 2).round();

  // Update last entries if they were null
  readinessHistory.last['value'] = todayReadiness;
  activityHistory.last['value'] = todayActivity;
  healthHistory.last['value'] = todayHealth;

  final data = {
    "scores": {
      "health": {
        "current_value": todayHealth,
        "metrics": {
          "readiness": {
            "title": "Readiness",
            "value": "${readinessHistory.last['value']}",
            "score": readinessHistory.last['value'],
          },
          "activity": {
            "title": "Activity",
            "value": "${activityHistory.last['value']}",
            "score": activityHistory.last['value'],
          },
        },
      },
      "readiness": {
        "current_value": readinessHistory.last['value'],
        "metrics": {
          "sleep": {"title": "Sleep", "value": "8h 40min", "score": 100},
          "resting_hr": {"title": "Resting HR", "value": "51 bpm", "score": 84},
          "hrv": {"title": "Overnight HRV", "value": "39 ms", "score": 66},
        },
      },
      "activity": {
        "current_value": activityHistory.last['value'],
        "metrics": {
          "active_points": {"title": "Active points", "value": "19 pts", "score": 17},
          "steps": {"title": "Steps", "value": "1852", "score": 26},
          "move_hours": {"title": "Move hours", "value": "5 h", "score": 48},
        },
      },
    },
    "history": {"health": healthHistory, "readiness": readinessHistory, "activity": activityHistory},
    "insights": {
      "health": [
        {
          "id": "h1",
          "text":
              "Your Health Score brings rest and activity together into one number, showing how balanced your day is.",
          "type": "info",
        },
      ],
      "readiness": [
        {"id": "r1", "text": "Great sleep quality! Your body is well-rested and ready for the day.", "type": "info"},
        {
          "id": "r2",
          "text": "Your HRV is slightly lower than usual. Consider taking it easy today.",
          "type": "warning",
        },
      ],
      "activity": [
        {
          "id": "a1",
          "text": "You're off to a good start! Keep up the momentum throughout the day.",
          "type": "suggestion",
        },
      ],
    },
    "metric_info": {
      "health_score": {
        "title": "Health Score",
        "description":
            "Your Health Score brings rest and activity together into one number, showing how balanced your day is. It's the average of your Readiness and Activity scores.",
        "baseline_info":
            "A score of 80 represents your personal baseline. This is the point where your daily metrics align with your 30-day averages. Get above 80 and you're performing beyond your usual. Fall below 80 and you may want to focus on recovery.",
      },
      "readiness": {
        "title": "Readiness",
        "description":
            "Readiness shows how prepared your body is for the day. It combines sleep quality, resting heart rate, and heart rate variability to give you an overall picture of your recovery.",
      },
      "activity": {
        "title": "Activity",
        "description":
            "Activity tracks your daily movement and exercise. It combines active points, steps, and move hours to show how active you've been throughout the day.",
      },
      "sleep": {
        "title": "Sleep",
        "description":
            "Total time spent asleep based on your sleep tracking data. Quality sleep is essential for recovery and overall health.",
      },
      "resting_hr": {
        "title": "Resting Heart Rate",
        "description":
            "Your heart rate measured during rest. Lower values typically indicate better cardiovascular fitness and recovery.",
      },
      "hrv": {
        "title": "Heart Rate Variability",
        "description":
            "The variation in time between heartbeats. Higher HRV often indicates better recovery and stress resilience.",
      },
      "active_points": {
        "title": "Active Points",
        "description":
            "Points earned through physical activity throughout the day. Higher intensity activities earn more points.",
      },
      "steps": {
        "title": "Steps",
        "description": "Total steps taken during the day. Aim for at least 10,000 steps for optimal health benefits.",
      },
      "move_hours": {
        "title": "Move Hours",
        "description":
            "Hours during which you recorded significant movement. Breaking up sedentary time is important for health.",
      },
    },
  };

  // Output JSON
  final encoder = JsonEncoder.withIndent('  ');
  debugPrint(encoder.convert(data));
}

List<Map<String, dynamic>> _generateHistory(
  DateTime endDate,
  int days,
  int minScore,
  int maxScore,
  Random random,
) {
  final history = <Map<String, dynamic>>[];

  for (int i = days - 1; i >= 0; i--) {
    final date = endDate.subtract(Duration(days: i));
    final dateStr = "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";

    // Occasionally add null values (missing data) - about 5% of the time
    final value = random.nextDouble() < 0.05 ? null : minScore + random.nextInt(maxScore - minScore + 1);

    history.add({
      "date": dateStr,
      "value": value,
    });
  }

  return history;
}
